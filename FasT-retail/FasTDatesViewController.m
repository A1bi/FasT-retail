//
//  FasTDateViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTDatesViewController.h"
#import "FasTSeatsViewController.h"
#import "FasTOrderViewController.h"
#import "FasTOrder.h"
#import "FasTEvent.h"

@interface FasTDatesViewController ()

@end

@implementation FasTDatesViewController

@synthesize datesTable;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[datesTable setDataSource:self];
    [datesTable setDelegate:self];
	[datesTable setRowHeight:60.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[datesTable release];
	[super dealloc];
}

#pragma mark table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"date"] autorelease];
    NSDate *date = [[[[self orderController] event] dates] objectAtIndex:[indexPath row]];
	[[cell textLabel] setText:[NSString stringWithFormat:@"%@", date]];
	[[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[[self orderController] event] dates] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[[self orderController] order] setDate:[NSString stringWithFormat:@"%i", [indexPath row] + 1]];
}

#pragma mark actions

- (IBAction)tappedNext:(UIButton *)sender {
	FasTSeatsViewController *seatsVC = [[[FasTSeatsViewController alloc] init] autorelease];
	
	[[self navigationController] pushViewController:seatsVC animated:YES];
}

@end
