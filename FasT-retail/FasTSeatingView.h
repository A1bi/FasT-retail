//
//  FasTSeatsView.h
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FasTSeatingView;
@class FasTSeatView;

@protocol FasTSeatingViewDelegate <NSObject>

- (void)didSelectSeatView:(FasTSeatView *)seatView;

@end

@interface FasTSeatingView : UIView
{
	NSMutableDictionary *seats;
    NSArray *grid, *sizes;
}

@property (nonatomic, assign) IBOutlet id<FasTSeatingViewDelegate> delegate;

- (void)updateSeatWithId:(NSString *)seatId info:(NSDictionary *)seatInfo;

@end
