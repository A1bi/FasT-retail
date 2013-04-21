//
//  FasTOrder.h
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FasTOrder : NSObject
{
	NSDictionary *date;
	NSMutableDictionary *tickets;
	NSMutableArray *seats;
    NSInteger numberOfTickets;
    float total;
}

@property (nonatomic, retain) NSDictionary *date;
@property (nonatomic, readonly) NSMutableDictionary *tickets;
@property (nonatomic, assign) NSInteger numberOfTickets;
@property (nonatomic, assign) float total;

@end
