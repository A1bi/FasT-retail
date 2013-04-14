//
//  FasTSeatsView.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTSeatsView.h"
#import "FasTSeatsViewSeat.h"

@implementation FasTSeatsView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		seats = [[NSDictionary dictionary] retain];
		[self addSeat];
    }
    return self;
}

- (FasTSeatsViewSeat *)addSeat
{
	CGRect frame;
	frame.size.width = 15;
	frame.size.height = 15;
	frame.origin.x = 100;
	frame.origin.y = 250;
	
	FasTSeatsViewSeat *seat = [[[FasTSeatsViewSeat alloc] initWithFrame:frame seatId:2 availability:YES] autorelease];
	[self addSubview:seat];
	
	return seat;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
