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
#import "FasTEventDate.h"

@interface FasTDatesViewController ()

- (NSArray *)dates;

@end

@implementation FasTDatesViewController

@synthesize datesTable;

- (id)initWithOrderController:(FasTOrderViewController *)oc
{
    self = [super initWithStepName:@"date" orderController:oc];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [orderController updateNextButton];
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
    [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
    
    NSString *date = [[self dates][ [indexPath row] ] localizedString];
	[[cell textLabel] setText:date];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self dates] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[orderController order] setDate:[self dates][ [indexPath row] ]];
    
    [orderController updateNextButton];
}

#pragma mark actions

- (IBAction)tappedNext:(UIButton *)sender {
	FasTSeatsViewController *seatsVC = [[[FasTSeatsViewController alloc] init] autorelease];
	
	[[self navigationController] pushViewController:seatsVC animated:YES];
}

#pragma mark class methods

- (BOOL)isValid
{
    return [[orderController order] date] != nil;
}

- (NSDictionary *)stepInfo
{
    return @{@"date": [[[orderController order] date] dateId]};
}

- (NSArray *)dates
{
    return [[orderController event] dates];
}

@end
