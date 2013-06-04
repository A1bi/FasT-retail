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
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [hud setMode:MBProgressHUDModeCustomView];
        [hud setMinSize:CGSizeMake(self.view.bounds.size.width * .5, self.view.bounds.size.height * .3)];
        [hud setLabelFont:[UIFont systemFontOfSize:25]];
        [hud setDetailsLabelFont:[UIFont systemFontOfSize:20]];
        [hud setOpacity:.9];
        [self.view addSubview:hud];
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

- (void)updateOrder
{
    [self resetExpiration];
    
    SocketIOCallback callback = ^(NSDictionary *response) {
        if ([(NSNumber *)response[@"ok"] boolValue]) {
            [self pushNextStepController];
        }
    };

    [[FasTApi defaultApi] updateOrderWithStep:[currentStepController stepName] info:[currentStepController stepInfo] callback:callback];
}

- (void)resetOrder
{
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
    if (currentStepIndex <= 0) return;
    currentStepIndex--;
    
    [self updateButtons];
    [nvc popViewControllerAnimated:YES];
    
    currentStepController = (FasTStepViewController *)[nvc visibleViewController];
}

- (void)updateButtons
{
    [nextBtn setEnabled:YES];
    [prevBtn setEnabled:(currentStepIndex > 0)];
}

- (void)updateNextButton
{
    [nextBtn setEnabled:[currentStepController isValid]];
}

- (void)expireOrder
{
    [expirationView stopAndHide];
    [self showLocalizedHUDMessageWithKey:@"orderExpiredMessage"];
}

- (void)disconnected
{
    [expirationView stopAndHide];
    [self showLocalizedHUDMessageWithKey:@"disconnectedMessage"];
}

- (void)showLocalizedHUDMessageWithKey:(NSString *)key
{
    [nextBtn setEnabled:NO];
    [prevBtn setEnabled:NO];
    
    [hud setLabelText:NSLocalizedStringByKey(key)];
    [hud setDetailsLabelText:NSLocalizedStringByKey(([NSString stringWithFormat:@"%@Details", key]))];
    [hud show:YES];
}

- (void)resetExpiration
{
    [expirationView stopAndHide];
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
