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
	NSString *date;
	NSDictionary *tickets;
	NSMutableArray *seats;
}

@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSDictionary *tickets;

@end
