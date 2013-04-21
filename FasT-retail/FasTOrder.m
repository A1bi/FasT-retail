//
//  FasTOrder.m
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTOrder.h"

@implementation FasTOrder

@synthesize date, tickets, numberOfTickets, total;

- (id)init
{
	self = [super init];
	if (self) {
        tickets = [[NSMutableDictionary alloc] init];
        seats = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[tickets release];
	[seats release];
    [date release];
	[super dealloc];
}

@end
