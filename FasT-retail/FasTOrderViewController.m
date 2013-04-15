//
//  FasTOrderViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTOrderViewController.h"
#import "FasTDatesViewController.h"
#import "FasTTicketsViewController.h"
#import "FasTOrder.h"

@interface FasTOrderViewController ()

@end

@implementation FasTOrderViewController

@synthesize order;

- (id)init
{
    self = [super init];
    if (self) {
        nvc = [[UINavigationController alloc] init];
		[nvc setNavigationBarHidden:YES];
		
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
	
	FasTDatesViewController *dates = [[FasTDatesViewController alloc] init];
	[dates setOrderController:self];
	[nvc pushViewController:dates animated:NO];
	
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
	[nvc release];
	[nextBtn release];
	[prevBtn release];
	[order release];
	[super dealloc];
}

#pragma mark actions

- (IBAction)nextTapped:(id)sender {
	FasTTicketsViewController *tickets = [[FasTTicketsViewController alloc] init];
	[tickets setOrderController:self];
	[nvc pushViewController:tickets animated:YES];
}

- (IBAction)prevTapped:(id)sender {
	[nvc popViewControllerAnimated:YES];
}


@end
