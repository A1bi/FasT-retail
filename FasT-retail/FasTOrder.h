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
	NSInteger date;
	NSDictionary *tickets;
	NSMutableArray *seats;
}

@property (nonatomic, assign) NSInteger date;

@end
