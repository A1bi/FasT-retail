//
//  FasTEvent.m
//  FasT-retail
//
//  Created by Albrecht Oster on 15.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTEvent.h"

@implementation FasTEvent

@synthesize name, dates, ticketTypes;

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        name = [[info objectForKey:@"name"] retain];
        
        NSMutableArray *tmpDates = [NSMutableArray array];
        for (NSNumber *dateTimestamp in [info objectForKey:@"dates"]) {
            [tmpDates addObject:[NSDate dateWithTimeIntervalSince1970:[dateTimestamp integerValue]]];
        }
        dates = [[NSArray arrayWithArray:tmpDates] retain];
        
        ticketTypes = [[info objectForKey:@"ticket_types"] retain];
    }
    return self;
}

- (void)dealloc
{
    [name release];
    [dates release];
    [super dealloc];
}

@end
