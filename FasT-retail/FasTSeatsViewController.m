//
//  FasTSeatsViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FasTSeatsViewController.h"
#import "FasTSeatView.h"
#import "FasTOrderViewController.h"
#import "FasTEvent.h"
#import "FasTEventDate.h"
#import "FasTSeat.h"
#import "FasTOrder.h"
#import "FasTApi.h"
#import "FasTSeatView.h"

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
        selectedSeats = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSeatsWithNotification:) name:FasTApiUpdatedSeatsNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 10; i <= 12 ; i++) {
        FasTSeatViewState state = FasTSeatViewStateAvailable;
        if (i == 11) {
            state = FasTSeatViewStateReserved;
        } else if (i == 12) {
            state = FasTSeatViewStateSelected;
        }
        [(FasTSeatView *)[[self view] viewWithTag:i] setState:state];
    }
    
    seatsView.layer.cornerRadius = 5;
    seatsView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSeats];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [errorAlert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [selectedSeats release];
    [seatsView release];
    [errorAlert release];
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
        
        if ([seat selected]) {
            [selectedSeats addObject:seat];
        } else {
            [selectedSeats removeObject:seat];
        }
    }
}

- (void)updateSeatsWithNotification:(NSNotification *)note
{
    [self updateSeatsWithInfo:[note userInfo]];
}

- (void)updateSeats
{
    [selectedSeats removeAllObjects];
    [self updateSeatsWithInfo:[[orderController event] seats]];
}

- (BOOL)isValid
{
    NSInteger numberOfTickets = [[orderController order] numberOfTickets];
    if (numberOfTickets != [selectedSeats count]) {
        NSString *message = [NSString stringWithFormat:NSLocalizedStringByKey(@"notEnoughSeatsErrorMessage"), numberOfTickets];
        if (!errorAlert) {
            errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringByKey(@"notEnoughSeatsErrorTitle") message:message delegate:nil cancelButtonTitle:NSLocalizedStringByKey(@"dismissAlert") otherButtonTitles:nil];
        } else {
            [errorAlert setMessage:message];
        }
        [errorAlert show];
        
        return NO;
    }

    return YES;
}

#pragma mark seating delegate methods

- (void)didSelectSeatView:(FasTSeatView *)seatView
{
    [orderController resetExpiration];
    
    [[FasTApi defaultApi] reserveSeatWithId:[seatView seatId]];
}

@end
