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
	NSString *seatId;
    BOOL isAvailable;
}

@property (nonatomic) BOOL isAvailable;
@property (nonatomic, readonly) NSString *seatId;

- (id)initWithFrame:(CGRect)frame seatId:(NSString *)sId info:(NSDictionary *)info;
- (void)updateWithInfo:(NSDictionary *)info;

@end
