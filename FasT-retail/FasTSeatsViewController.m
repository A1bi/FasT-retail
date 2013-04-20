//
//  FasTSeatsViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTSeatsViewController.h"
#import "FasTSeatsView.h"
#import "FasTSeatsViewSeat.h"
#import "FasTOrderViewController.h"
#import "FasTEvent.h"
#import "FasTOrder.h"

@interface FasTSeatsViewController ()

- (void)updateSeatsWithInfo:(NSDictionary *)seats;
- (void)updateSeatsWithNotification:(NSNotification *)note;
- (void)updateSeats;

@end

@implementation FasTSeatsViewController

@synthesize seatsView;

- (id)initWithOrderController:(FasTOrderViewController *)oc
{
    self = [super initWithStepName:@"seats" orderController:oc];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSeatsWithNotification:) name:@"updateSeats" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateSeats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [seatsView release];
    [super dealloc];
}

#pragma mark class methods

- (void)updateSeatsWithInfo:(NSDictionary *)seats
{
    NSDictionary *dateSeats = [seats objectForKey:[[orderController order] date]];
    if (!dateSeats) return;
    
    for (NSString *seatId in dateSeats) {
        NSDictionary *seat = [dateSeats objectForKey:seatId];
        [seatsView updateSeatWithId:seatId info:seat];
    }
}

- (void)updateSeatsWithNotification:(NSNotification *)note
{
    [self updateSeatsWithInfo:[note userInfo]];
}

- (void)updateSeats
{
    NSDictionary *seats = [[orderController event] seats];
    [self updateSeatsWithInfo:seats];
}

@end
