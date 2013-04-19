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

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        seats = [[NSMutableDictionary dictionary] retain];
        
        [self setName:[info objectForKey:@"name"]];
        
        NSMutableArray *tmpDates = [NSMutableArray array];
        for (NSDictionary *date in [info objectForKey:@"dates"]) {
            NSMutableDictionary *dateInfo = [NSMutableDictionary dictionaryWithDictionary:date];
            NSInteger dateTimestamp = [[date objectForKey:@"date"] integerValue];
            [dateInfo setObject:[NSDate dateWithTimeIntervalSince1970:dateTimestamp] forKey:@"date"];
            [tmpDates addObject:dateInfo];
        }
        [self setDates:[NSArray arrayWithArray:tmpDates]];
        
        [self setTicketTypes:[info objectForKey:@"ticketTypes"]];
        
        [self updateSeats:[info objectForKey:@"seats"]];
    }
    return self;
}

- (void)dealloc
{
    [name release];
    [dates release];
    [ticketTypes release];
    [seats release];
    [super dealloc];
}

#pragma mark class methods

- (void)updateSeats:(NSDictionary *)seatsInfo
{
    for (NSString *date in seatsInfo) {
        NSMutableDictionary *eventDateSeats = [seats objectForKey:date];
        if (!eventDateSeats) {
            eventDateSeats = [NSMutableDictionary dictionary];
            [seats setObject:eventDateSeats forKey:date];
        }
        
        NSDictionary *dateSeats = [seatsInfo objectForKey:date];
        for (NSString *seatId in dateSeats) {
            [eventDateSeats setObject:[dateSeats objectForKey:seatId] forKey:seatId];
        }
    }
}

@end