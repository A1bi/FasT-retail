//
//  FasTEvent.h
//  FasT-retail
//
//  Created by Albrecht Oster on 15.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FasTEvent : NSObject
{
    NSString *name;
    NSArray *dates;
    NSArray *ticketTypes;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *dates;
@property (nonatomic, readonly) NSArray *ticketTypes;

- (id)initWithInfo:(NSDictionary *)info;

@end
