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
        
        grid = [[NSArray arrayWithObjects:
                 [NSNumber numberWithFloat:self.frame.size.width / kMaxCellsX],
                 [NSNumber numberWithFloat:self.frame.size.height / kMaxCellsY],
                nil] retain];
        
        sizes = [[NSArray arrayWithObjects:
                    [NSNumber numberWithFloat:[[grid objectAtIndex:0] floatValue] * kSizeFactorsX],
                    [NSNumber numberWithFloat:[[grid objectAtIndex:1] floatValue] * kSizeFactorsY],
                nil] retain];
    }
    return self;
}

- (void)updateSeatWithId:(NSString *)seatId info:(NSDictionary *)seatInfo
{
    FasTSeatsViewSeat *seat = [seats objectForKey:seatId];
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
	frame.size.width = [[sizes objectAtIndex:0] floatValue];
	frame.size.height = [[sizes objectAtIndex:1] floatValue];
	frame.origin.x = [[grid objectAtIndex:0] floatValue] * [[gridPos objectForKey:@"x"] intValue];
	frame.origin.y = [[grid objectAtIndex:1] floatValue] * [[gridPos objectForKey:@"y"] intValue];
	
	FasTSeatsViewSeat *seat = [[[FasTSeatsViewSeat alloc] initWithFrame:frame seatId:seatId info:seatInfo] autorelease];
    [seats setObject:seat forKey:seatId];
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
