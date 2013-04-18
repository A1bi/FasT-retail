//
//  FasTSeatsView.h
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FasTSeatsView : UIView
{
	NSMutableDictionary *seats;
    NSArray *grid, *sizes;
}

- (void)updateSeatWithId:(NSString *)seatId info:(NSDictionary *)seatInfo;

@end
