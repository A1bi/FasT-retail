//
//  FasTSeatsViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTSeatsViewController.h"
#import "FasTSeatView.h"
#import "FasTOrderViewController.h"
#import "FasTEvent.h"
#import "FasTEventDate.h"
#import "FasTSeat.h"
#import "FasTOrder.h"
#import "FasTApi.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSeatsWithNotification:) name:FasTApiUpdatedSeatsNotification object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [seatsView release];
    [super dealloc];
}

#pragma mark class methods

- (void)updateSeatsWithInfo:(NSDictionary *)seats
{
    NSString *dateId = [[[orderController order] date] dateId];
    NSDictionary *dateSeats = seats[dateId];
    if (!dateSeats) return;
    
    for (NSString *seatId in dateSeats) {
        FasTSeat *seat = dateSeats[seatId];
        if (![seat isKindOfClass:[FasTSeat class]]) {
            seat = [[orderController event] seats][dateId][seatId];
        }
        [seatsView updatedSeat:seat];
    }
}

- (void)updateSeatsWithNotification:(NSNotification *)note
{
    [self updateSeatsWithInfo:[note userInfo]];
}

- (void)updateSeats
{
    [self updateSeatsWithInfo:[[orderController event] seats]];
}

#pragma mark seating delegate methods

- (void)didSelectSeatView:(FasTSeatView *)seatView
{
    [orderController resetExpiration];
    
    [[FasTApi defaultApi] reserveSeatWithId:[seatView seatId]];
}

@end
