//
//  FasTExpirationView.m
//  FasT-retail
//
//  Created by Albrecht Oster on 04.06.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTExpirationView.h"

#define kFasTExpirationViewUpdateInterval .1

@interface FasTExpirationView ()

- (void)update;
- (void)releaseTimer;

@end

@implementation FasTExpirationView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGFloat halfHeight = self.bounds.size.height / 2;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, halfHeight)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setText:NSLocalizedStringByKey(@"orderAboutToExpire")];
        
        progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(0, halfHeight, self.bounds.size.width, halfHeight)];
        [progressBar setUserInteractionEnabled:NO];
        [progressBar setProgressViewStyle:UIProgressViewStyleBar];
        
        [self addSubview:label];
        [self addSubview:progressBar];
        [self setHidden:YES];
    }
    return self;
}

- (void)dealloc
{
    [label release];
    [progressBar release];
    [self releaseTimer];
    [super dealloc];
}

- (void)startWithNumberOfSeconds:(NSInteger)s
{
    seconds = s;
    currentIteration = 0;
    
    iterationLength = 1.f / (seconds / kFasTExpirationViewUpdateInterval);
    [self releaseTimer];
    timer = [[NSTimer timerWithTimeInterval:kFasTExpirationViewUpdateInterval target:self selector:@selector(update) userInfo:nil repeats:YES] retain];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [progressBar setProgress:1 animated:NO];
    [self setHidden:NO];
}

- (void)stopAndHide
{
    [timer invalidate];
    [self setHidden:YES];
}

- (void)update
{
    float progress = [progressBar progress] - iterationLength;
    [progressBar setProgress:progress animated:NO];
    
    if (progress < 0) {
        [timer invalidate];
        return;
    }
    
    currentIteration++;
}

- (void)releaseTimer
{
    [timer invalidate];
    [timer release];
}

@end
