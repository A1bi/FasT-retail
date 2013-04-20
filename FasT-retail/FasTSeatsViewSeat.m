//
//  FasTSeatsViewSeat.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTSeatsViewSeat.h"

@interface FasTSeatsViewSeat ()

- (void)toggleAvailability;
- (void)updateSeat;

@end

@implementation FasTSeatsViewSeat

@synthesize isAvailable, seatId;

- (id)initWithFrame:(CGRect)frame seatId:(NSString *)sId info:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
		seatId = [sId retain];
        [self updateWithInfo:info];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] autorelease];
		[self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)dealloc
{
    [seatId release];
    [super dealloc];
}

#pragma mark class methods

- (void)updateWithInfo:(NSDictionary *)info
{
    [self setIsAvailable:![info[@"reserved"] boolValue]];
}

- (void)toggleAvailability
{
	[self setIsAvailable:![self isAvailable]];
}

- (void)setIsAvailable:(BOOL)a
{
    isAvailable = a;
    [self updateSeat];
}

- (void)updateSeat
{
    UIColor *color = [UIColor redColor];
	if (isAvailable) {
		color = [UIColor greenColor];
	}
	[self setBackgroundColor:color];
}

#pragma mark gesture recognizer delegate methods

- (void)tapped
{
	[self toggleAvailability];
}

@end
