//
//  FasTFinishViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 23.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTFinishViewController.h"
#import "FasTOrderViewController.h"
#import "FasTOrder.h"
#import "FasTApi.h"
#import "FasTEventDate.h"
#import "FasTTicketType.h"

@interface FasTFinishViewController ()

- (void)placeOrder;
- (void)placedOrderWithResponse:(NSDictionary *)response;

@end

@implementation FasTFinishViewController

- (id)initWithOrderController:(FasTOrderViewController *)oc
{
    return [super initWithStepName:@"finish" orderController:oc];
}

- (void)dealloc {
    [statusLabel release];
    [noteLabel release];
    [queueNumberLabel release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self placeOrder];
}

#pragma mark class methods

- (void)placeOrder
{
    [statusLabel setHighlighted:YES];
    [orderController toggleWaitingSpinner:YES];
    
    NSMutableDictionary *tickets = [NSMutableDictionary dictionary];
    for (NSDictionary *type in [[orderController order] tickets]) {
        tickets[[type[@"type"] typeId]] = type[@"number"];
    }
    NSDictionary *orderInfo = @{@"date": [[[orderController order] date] dateId], @"tickets": tickets};
    [[FasTApi defaultApi] placeOrderWithInfo:orderInfo callback:^(NSDictionary *response) {
        [self placedOrderWithResponse:response];
    }];
}

- (void)placedOrderWithResponse:(NSDictionary *)response
{
    [orderController toggleWaitingSpinner:NO];
    [statusLabel setHidden:NO];
    NSInteger idleDelay = 20;
    if (![response[@"ok"] boolValue]) {
        [statusLabel setText:NSLocalizedStringByKey(@"unknownErrorOccurred")];
        idleDelay = 10;
    } else {
        FasTOrder *order = [[[FasTOrder alloc] initWithInfo:response[@"order"] event:[orderController event]] autorelease];
        [queueNumberLabel setHidden:NO];
        [queueNumberLabel setText:[order queueNumber]];
        [noteLabel setHidden:NO];
    }
    [orderController showIdleControllerWithDelay:idleDelay];
}

@end
