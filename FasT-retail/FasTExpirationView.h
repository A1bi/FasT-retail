//
//  FasTExpirationView.h
//  FasT-retail
//
//  Created by Albrecht Oster on 04.06.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FasTExpirationView : UIView
{
    NSTimer *timer;
    NSInteger currentIteration, seconds;
    double iterationLength;
    
    UILabel *label;
    UIProgressView *progressBar;
}

- (void)startWithNumberOfSeconds:(NSInteger)seconds;
- (void)stopAndHide;

@end
