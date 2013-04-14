//
//  FasTSeatsViewSeat.h
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FasTSeatsViewSeat : UIView
{
	BOOL isAvailable;
	NSInteger seatId;
}

@property (nonatomic) BOOL isAvailable;
@property (nonatomic, readonly) NSInteger seatId;

- (id)initWithFrame:(CGRect)frame seatId:(NSInteger)sId availability:(BOOL)available;
- (void)toggleAvailability;

@end
