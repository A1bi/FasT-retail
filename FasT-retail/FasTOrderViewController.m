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
#import "FasTIdleViewController.h"
#import "MBProgressHUD.h"

#define kFasTIdleTimeTotal 150
#define kFasTIdleTimeBefore 30

@interface FasTOrderViewController ()

- (void)initSteps;
- (void)pushNextStepController;
- (void)popStepController;
- (void)updateButtons;
- (void)stopExpiration;
- (void)showExpirationView;
- (void)expireOrder;
- (void)resetOrder;
- (void)disconnected;
- (void)showLocalizedHUDMessageWithKey:(NSString *)key;
- (void)stopIdleController;
- (void)showIdleController:(BOOL)animated;
- (void)showIdleController;
- (void)toggleBtn:(UIButton *)btn enabled:(BOOL)enabled;
- (void)toggleBtns:(BOOL)toggle;
- (void)disableBtns;
- (void)cancelTasksWithSelector:(SEL)selector;

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
        [expirationView setDelegate:self];
        
        [self disableBtns];
    }
    return self;
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

- (void)resetOrder
{
    [[FasTApi defaultApi] resetSeating];
    [self stopIdleController];
    [self initSteps];
    [self resetExpiration];
    [hud hide:NO];
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
    [self showLocalizedHUDMessageWithKey:@"orderExpiredMessage"];
    [self showIdleControllerWithDelay:10];
}

- (void)disconnected
{
    [self showLocalizedHUDMessageWithKey:@"disconnectedMessage"];
    [self showIdleControllerWithDelay:10];
}

- (void)showLocalizedHUDMessageWithKey:(NSString *)key
{
    [self disableBtns];
    [self stopExpiration];
    
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:NSLocalizedStringByKey(key)];
    [hud setDetailsLabelText:NSLocalizedStringByKey(([NSString stringWithFormat:@"%@Details", key]))];
    [hud show:YES];
}

- (void)toggleWaitingSpinner:(BOOL)toggle
{
    if (toggle) {
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud setLabelText:NSLocalizedStringByKey(@"oneMoment")];
        [hud setDetailsLabelText:nil];
        [hud show:YES];
    } else {
        [hud hide:YES];
    }
}

- (void)stopExpiration
{
    [expirationView stopAndHide];
    [self cancelTasksWithSelector:@selector(showExpirationView)];
}

- (void)resetExpiration
{
    [self stopExpiration];
    [self performSelector:@selector(showExpirationView) withObject:nil afterDelay:kFasTIdleTimeTotal - kFasTIdleTimeBefore];
}

- (void)showExpirationView
{
    [expirationView startWithNumberOfSeconds:kFasTIdleTimeBefore];
}

- (void)stopIdleController
{
    [self cancelTasksWithSelector:@selector(showIdleController)];
}

- (void)showIdleController:(BOOL)animated
{
    [self stopExpiration];
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
    [self stopExpiration];
    [self stopIdleController];
    [self performSelector:@selector(showIdleController) withObject:nil afterDelay:delay];
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

- (void)cancelTasksWithSelector:(SEL)selector
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
}

#pragma mark actions

- (IBAction)nextTapped:(id)sender {
    [self resetExpiration];
    if ([currentStepController isValid]) {
        [self pushNextStepController];
    }
}

- (IBAction)prevTapped:(id)sender {
    [self resetExpiration];
    [self popStepController];
}

#pragma mark expiration view delegate

- (void)expirationViewDidExpire:(FasTExpirationView *)view
{
    [self expireOrder];
}

@end
