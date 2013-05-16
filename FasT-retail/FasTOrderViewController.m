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


@interface FasTOrderViewController ()

- (void)initSteps;
- (void)pushNextStepController;
- (void)popStepController;
- (void)updateButtons;
- (void)updateOrder;

@end

@implementation FasTOrderViewController

@synthesize order;

- (id)init
{
    self = [super init];
    if (self) {
        nvc = [[UINavigationController alloc] init];
		[nvc setNavigationBarHidden:YES];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:FasTApiIsReadyNotification object:[FasTApi defaultApi] queue:nil usingBlock:^(NSNotification *note) {
            [self initSteps];
        }];
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
	[nextBtn release];
	[prevBtn release];
	[order release];
    [stepControllers release];
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
    SocketIOCallback callback = ^(NSDictionary *response) {
        if ([(NSNumber *)response[@"ok"] boolValue]) {
            [self pushNextStepController];
        }
    };

    [[FasTApi defaultApi] updateOrderWithStep:[currentStepController stepName] info:[currentStepController stepInfo] callback:callback];
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
