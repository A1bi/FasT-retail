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
        
        [self setName:info[@"name"]];
        
        NSMutableArray *tmpDates = [NSMutableArray array];
        for (NSDictionary *date in info[@"dates"]) {
            NSMutableDictionary *dateInfo = [NSMutableDictionary dictionaryWithDictionary:date];
            NSInteger dateTimestamp = [date[@"date"] integerValue];
            dateInfo[@"date"] = [NSDate dateWithTimeIntervalSince1970:dateTimestamp];
            [tmpDates addObject:dateInfo];
        }
        [self setDates:[NSArray arrayWithArray:tmpDates]];
        
        [self setTicketTypes:info[@"ticketTypes"]];
        
        [self updateSeats:info[@"seats"]];
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
        NSMutableDictionary *eventDateSeats = seats[date];
        if (!eventDateSeats) {
            eventDateSeats = [NSMutableDictionary dictionary];
            seats[date] = eventDateSeats;
        }
        
        NSDictionary *dateSeats = seatsInfo[date];
        for (NSString *seatId in dateSeats) {
            eventDateSeats[seatId] = dateSeats[seatId];
        }
    }
}

@end
