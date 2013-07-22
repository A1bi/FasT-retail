//
//  FasTExpirationView.h
//  FasT-retail
//
//  Created by Albrecht Oster on 04.06.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FasTExpirationView;

@protocol FasTExpirationViewDelegate <NSObject>

- (void)expirationViewDidExpire:(FasTExpirationView *)view;

@end

@interface FasTExpirationView : UIView
{
    NSTimer *timer;
    NSInteger currentIteration, seconds;
    double iterationLength;
    
    UILabel *label;
    UIProgressView *progressBar;
}

@property (nonatomic, assign) id<FasTExpirationViewDelegate> delegate;

- (void)startWithNumberOfSeconds:(NSInteger)seconds;
- (void)stopAndHide;

@end
