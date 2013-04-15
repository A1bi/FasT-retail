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

@interface FasTOrderViewController ()

- (void)pushNextStepController;

@end

@implementation FasTOrderViewController

@synthesize order;

- (id)init
{
    self = [super init];
    if (self) {
        nvc = [[UINavigationController alloc] init];
		[nvc setNavigationBarHidden:YES];
        
        currentStepIndex = -1;
        
        stepControllers = [[NSMutableArray array] retain];
        stepControllerClasses = [[NSArray arrayWithObjects:
                                  [FasTDatesViewController class],
                                  [FasTTicketsViewController class],
                                  [FasTSeatsViewController class],
                                nil] retain];
		
		order = [[FasTOrder alloc] init];
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

- (void)pushNextStepController
{
    FasTStepViewController *nextStepController;
    @try {
        nextStepController = [stepControllers objectAtIndex:++currentStepIndex];     
    }
    @catch (NSException *exception) {
        nextStepController = [[[[stepControllerClasses objectAtIndex:currentStepIndex] alloc] init] autorelease];
        [nextStepController setOrderController:self];
        [stepControllers insertObject:nextStepController atIndex:currentStepIndex];
    }
    @finally {
        [nvc pushViewController:nextStepController animated:YES];
    }
}

#pragma mark actions

- (IBAction)nextTapped:(id)sender {
    [self pushNextStepController];
}

- (IBAction)prevTapped:(id)sender {
    currentStepIndex--;
	[nvc popViewControllerAnimated:YES];
}


@end
