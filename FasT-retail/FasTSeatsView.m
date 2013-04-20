//
//  FasTSeatsView.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTSeatsView.h"
#import "FasTSeatsViewSeat.h"

static int      kMaxCellsX = 100;
static int      kMaxCellsY = 60;
static float    kSizeFactorsX = 3.5;
static float    kSizeFactorsY = 3;

@interface FasTSeatsView ()

- (void)addSeatWithId:(NSString *)seatId info:(NSDictionary *)seatInfo;

@end

@implementation FasTSeatsView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		seats = [[NSMutableDictionary dictionary] retain];
        
        grid = [@[ @(self.frame.size.width / kMaxCellsX), @(self.frame.size.height / kMaxCellsY) ] retain];
        
        sizes = [@[ @([grid[0] floatValue] * kSizeFactorsX), @([grid[1] floatValue] * kSizeFactorsY) ] retain];
    }
    return self;
}

- (void)updateSeatWithId:(NSString *)seatId info:(NSDictionary *)seatInfo
{
    FasTSeatsViewSeat *seat = seats[seatId];
    if (!seat) {
        [self addSeatWithId:seatId info:seatInfo];
    } else {
        [seat updateWithInfo:seatInfo];
    }
}

- (void)addSeatWithId:(NSString *)seatId info:(NSDictionary *)seatInfo
{
    NSDictionary *gridPos = [seatInfo objectForKey:@"grid"];
    
	CGRect frame;
	frame.size.width = [sizes[0] floatValue];
	frame.size.height = [sizes[1] floatValue];
	frame.origin.x = [grid[0] floatValue] * [gridPos[@"x"] intValue];
	frame.origin.y = [grid[1] floatValue] * [gridPos[@"y"] intValue];
	
	FasTSeatsViewSeat *seat = [[[FasTSeatsViewSeat alloc] initWithFrame:frame seatId:seatId info:seatInfo] autorelease];
    seats[seatId] = seat;
	[self addSubview:seat];
}

- (void)dealloc
{
    [grid release];
    [sizes release];
    [seats release];
    [super dealloc];
}

@end
