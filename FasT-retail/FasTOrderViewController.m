//
//  FasTOrderViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTOrderViewController.h"
#import "FasTOrder.h"
#import "FasTDatesViewController.h"
#import "FasTTicketsViewController.h"
#import "FasTSeatsViewController.h"
#import "FasTConfirmStepViewController.h"
#import "FasTFinishViewController.h"
#import "FasTApi.h"
#import "FasTExpirationView.h"
#import "FasTIdleViewController.h"
#import "MBProgressHUD.h"


@interface FasTOrderViewController ()

- (void)initSteps;
- (void)pushNextStepController;
- (void)popStepController;
- (void)updateButtons;
- (void)updateOrder;
- (void)expireOrder;
- (void)resetOrder;
- (void)disconnected;
- (void)showLocalizedHUDMessageWithKey:(NSString *)key;
- (void)showIdleController:(BOOL)animated;
- (void)showIdleController;
- (void)showIdleControllerWithDelay:(NSTimeInterval)delay;
- (void)toggleBtn:(UIButton *)btn enabled:(BOOL)enabled;
- (void)toggleBtns:(BOOL)toggle;
- (void)disableBtns;

@end

@implementation FasTOrderViewController

@synthesize order;

- (id)init
{
    self = [super init];
    if (self) {
        nvc = [[UINavigationController alloc] init];
		[nvc setNavigationBarHidden:YES];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserverForName:FasTApiIsReadyNotification object:[FasTApi defaultApi] queue:nil usingBlock:^(NSNotification *note) {
            [self resetOrder];
        }];
        [center addObserver:self selector:@selector(expireOrder) name:FasTApiOrderExpiredNotification object:nil];
        [center addObserver:self selector:@selector(disconnected) name:FasTApiDisconnectedNotification object:nil];
        [center addObserverForName:FasTApiAboutToExpireNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [expirationView startWithNumberOfSeconds:[[note userInfo][@"secondsLeft"] intValue]];
        }];
        [center addObserverForName:FasTApiPlacedOrderNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self showIdleControllerWithDelay:20];
        }];
        [center addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self showIdleController:NO];
        }];
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [hud setMode:MBProgressHUDModeCustomView];
        [hud setMinSize:CGSizeMake(self.view.bounds.size.width * .5, self.view.bounds.size.height * .3)];
        [hud setLabelFont:[UIFont systemFontOfSize:25]];
        [hud setDetailsLabelFont:[UIFont systemFontOfSize:20]];
        [hud setOpacity:.9];
        [self.view addSubview:hud];
        
        returnedFromIdle = NO;
        idleController = [[FasTIdleViewController alloc] init];
        
        [self disableBtns];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self addChildViewController:nvc];
	nvc.view.frame = self.view.bounds;
	
	[[self view] addSubview:[nvc view]];
	[[self view] sendSubviewToBack:[nvc view]];
	[nvc didMoveToParentViewController:self];
    
    if (!returnedFromIdle) [self showIdleController:NO];
    returnedFromIdle = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIScreen mainScreen] setBrightness:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[nvc release];
    [hud release];
	[nextBtn release];
	[prevBtn release];
	[order release];
    [stepControllers release];
    [idleController release];
    [expirationView release];
    [loadingView release];
	[super dealloc];
}

- (FasTEvent *)event
{
    return [[FasTApi defaultApi] event];
}

#pragma mark class methods

- (void)initSteps
{
    [order release];
    order = [[FasTOrder alloc] init];
    
    currentStepIndex = -1;
    
    NSMutableArray *tmpStepControllers = [NSMutableArray array];
    NSArray *stepControllerClasses = @[ [FasTDatesViewController class], [FasTTicketsViewController class], [FasTSeatsViewController class],  [FasTConfirmStepViewController class], [FasTFinishViewController class] ];
    
    for (Class klass in stepControllerClasses) {
        FasTStepViewController *vc = [[[klass alloc] initWithOrderController:self] autorelease];
        [tmpStepControllers addObject:vc];
    }
    
    [stepControllers release];
    stepControllers = [[NSArray arrayWithArray:tmpStepControllers] retain];
    
    [nvc popToRootViewControllerAnimated:NO];
    [self pushNextStepController];
}

- (void)updateOrder
{
    [self resetExpiration];
    [self disableBtns];
    [loadingView startAnimating];
    
    SocketIOCallback callback = ^(NSDictionary *response) {
        [loadingView stopAnimating];
        if ([(NSNumber *)response[@"ok"] boolValue]) {
            [self pushNextStepController];
        }
    };

    [[FasTApi defaultApi] updateOrderWithStep:[currentStepController stepName] info:[currentStepController stepInfo] callback:callback];
}

- (void)resetOrder
{
    [[FasTApi defaultApi] resetOrder];
    [self initSteps];
    [hud hide:NO];
    [expirationView stopAndHide];
}

- (void)pushNextStepController
{
    if (currentStepIndex+1 >= [stepControllers count]) return;
    currentStepController = stepControllers[++currentStepIndex];
    [self updateButtons];
    [nvc pushViewController:currentStepController animated:YES];
}

- (void)popStepController
{
    if (currentStepIndex <= 0) {
        [self showIdleController];
        
    } else {
        currentStepController = stepControllers[--currentStepIndex];
        
        [self updateButtons];
        [nvc popViewControllerAnimated:YES];
    }
}

- (void)updateButtons
{
    BOOL btnToggle = NO;
    if (currentStepController != [stepControllers lastObject]) {
        NSString *nextBtnTitleKey;
        if (currentStepController == stepControllers[[stepControllers count] - 2]) {
            nextBtnTitleKey = @"buy";
        } else {
            nextBtnTitleKey = @"next";
        }
        [nextBtn setTitle:NSLocalizedStringByKey(nextBtnTitleKey) forState:UIControlStateNormal];
        [prevBtn setTitle:NSLocalizedStringByKey((currentStepIndex > 0) ? @"back" : @"cancel") forState:UIControlStateNormal];
        btnToggle = YES;
    }
    [self toggleBtns:btnToggle];
}

- (void)updateNextButton
{
    [self toggleBtn:nextBtn enabled:[currentStepController isValid]];
}

- (void)expireOrder
{
    [expirationView stopAndHide];
    [self showLocalizedHUDMessageWithKey:@"orderExpiredMessage"];
    [self showIdleControllerWithDelay:10];
}

- (void)disconnected
{
    [expirationView stopAndHide];
    [self showLocalizedHUDMessageWithKey:@"disconnectedMessage"];
    [self showIdleControllerWithDelay:10];
}

- (void)showLocalizedHUDMessageWithKey:(NSString *)key
{
    [self disableBtns];
    [loadingView stopAnimating];
    
    [hud setLabelText:NSLocalizedStringByKey(key)];
    [hud setDetailsLabelText:NSLocalizedStringByKey(([NSString stringWithFormat:@"%@Details", key]))];
    [hud show:YES];
}

- (void)resetExpiration
{
    [expirationView stopAndHide];
}

- (void)showIdleController:(BOOL)animated
{
    if ([self presentedViewController]) return;
    [self presentViewController:idleController animated:animated completion:nil];
}

- (void)showIdleController
{
    [self showIdleController:YES];
}

- (void)showIdleControllerWithDelay:(NSTimeInterval)delay
{
    if ([self presentedViewController]) return;
    SEL selector = @selector(showIdleController);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:nil afterDelay:delay];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [self resetOrder];
    [super dismissViewControllerAnimated:flag completion:completion];
    returnedFromIdle = YES;
}

- (void)toggleBtn:(UIButton *)btn enabled:(BOOL)enabled
{
    [btn setHidden:!enabled];
}

- (void)toggleBtns:(BOOL)toggle
{
    for (UIButton *btn in @[prevBtn, nextBtn]) {
        [self toggleBtn:btn enabled:toggle];
    }
}

- (void)disableBtns
{
    [self toggleBtns:NO];
}

#pragma mark actions

- (IBAction)nextTapped:(id)sender {
    if ([currentStepController isValid]) {
        [self updateOrder];
    }
}

- (IBAction)prevTapped:(id)sender {
    [self popStepController];
}

@end
