//
//  FasTOrder.m
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTOrder.h"

@implementation FasTOrder

@synthesize date, tickets;

- (id)init
{
	self = [super init];
	if (self) {
		tickets = [[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"1", nil] retain];
		seats = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[tickets release];
	[seats release];
	[super dealloc];
}

@end
