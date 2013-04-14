//
//  FasTSeatsViewSeat.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTSeatsViewSeat.h"

@implementation FasTSeatsViewSeat

@synthesize isAvailable, seatId;

- (id)initWithFrame:(CGRect)frame seatId:(NSInteger)sId availability:(BOOL)available
{
    self = [super initWithFrame:frame];
    if (self) {
		seatId = sId;
        [self setIsAvailable:available];
		
		UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)] autorelease];
		[self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)setIsAvailable:(BOOL)available
{
	isAvailable = available;
	
	UIColor *color = [UIColor redColor];
	if (isAvailable) {
		color = [UIColor greenColor];
	}
	[self setBackgroundColor:color];
}

- (void)toggleAvailability
{
	[self setIsAvailable:![self isAvailable]];
}

- (void)tapped
{
	[self toggleAvailability];
}

@end
