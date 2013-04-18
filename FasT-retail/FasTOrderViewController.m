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
#import "FasTNode.h"


@interface FasTOrderViewController ()

- (void)pushNextStepController;

@end

@implementation FasTOrderViewController

@synthesize order, event;

- (id)init
{
    self = [super init];
    if (self) {
        nvc = [[UINavigationController alloc] init];
		[nvc setNavigationBarHidden:YES];
        
        order = [[FasTOrder alloc] init];
        
        currentStepIndex = -1;
        
        NSMutableArray *tmpStepControllers = [NSMutableArray array];
        NSArray *stepControllerClasses = [NSArray arrayWithObjects:
                                  [FasTDatesViewController class],
                                  [FasTTicketsViewController class],
                                  [FasTSeatsViewController class],
                                nil];
        
        for (Class klass in stepControllerClasses) {
            FasTStepViewController *vc = [[[klass alloc] init] autorelease];
            [vc setOrderController:self];
            [tmpStepControllers addObject:vc];
        }
        
        stepControllers = [[NSArray arrayWithArray:tmpStepControllers] retain];
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
    
    [self pushNextStepController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[nvc release];
	[nextBtn release];
	[prevBtn release];
	[order release];
    [stepControllers release];
	[super dealloc];
}

- (FasTEvent *)event
{
    return [[FasTNode defaultNode] event];
}

#pragma mark class methods

- (void)pushNextStepController
{
    FasTStepViewController *nextStepController = [stepControllers objectAtIndex:++currentStepIndex];
    [nvc pushViewController:nextStepController animated:YES];
}

#pragma mark actions

- (IBAction)nextTapped:(id)sender {
    [self pushNextStepController];
}

- (IBAction)prevTapped:(id)sender {
    if (currentStepIndex <= 0) return;
    currentStepIndex--;
	[nvc popViewControllerAnimated:YES];
}

@end
