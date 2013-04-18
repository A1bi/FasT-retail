//
//  FasTEvent.m
//  FasT-retail
//
//  Created by Albrecht Oster on 15.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTEvent.h"

@implementation FasTEvent

@synthesize name, dates, ticketTypes, seats;

- (id)init
{
    self = [super init];
    if (self) {
        seats = [[NSMutableDictionary dictionary] retain];
    }
    return self;
}

- (void)updateWithInfo:(NSDictionary *)info
{
    [self setName:[info objectForKey:@"name"]];
    
    NSMutableArray *tmpDates = [NSMutableArray array];
    for (NSNumber *dateTimestamp in [info objectForKey:@"dates"]) {
        [tmpDates addObject:[NSDate dateWithTimeIntervalSince1970:[dateTimestamp integerValue]]];
    }
    [self setDates:[NSArray arrayWithArray:tmpDates]];
    
    [self setTicketTypes:[info objectForKey:@"ticket_types"]];
}

- (void)dealloc
{
    [name release];
    [dates release];
    [ticketTypes release];
    [seats release];
    [super dealloc];
}

@end
