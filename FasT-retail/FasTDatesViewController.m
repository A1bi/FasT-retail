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

#pragma table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"date"] autorelease];
	[[cell textLabel] setText:@"Montag, 1. Januar 2007"];
	[[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

#pragma table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self orderController] dateChanged:[indexPath row]];
}

#pragma actions

- (IBAction)tappedNext:(UIButton *)sender {
	FasTSeatsViewController *seatsVC = [[[FasTSeatsViewController alloc] init] autorelease];
	
	[[self navigationController] pushViewController:seatsVC animated:YES];
}

@end
