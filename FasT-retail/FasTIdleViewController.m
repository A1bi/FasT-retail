//
//  FasTIdleViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 07.06.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTIdleViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface FasTIdleViewController ()

- (void)fadeInTitle;
- (void)fadeOutTitle;
- (void)addAnimation:(CAAnimation *)anim toLayer:(CALayer *)layer;
- (CABasicAnimation *)opacityAnimationForTiteWithFadeInToggle:(BOOL)toggle duration:(CFTimeInterval)duration;

@end

@implementation FasTIdleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"idle_background.png"];
        UIImageView *backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        [[self view] addSubview:backgroundView];
        
        UIImage *titleImage = [UIImage imageNamed:@"idle_title.png"];
        UIImageView *titleView = [[[UIImageView alloc] initWithImage:titleImage] autorelease];
        CGRect titleRect;
        titleRect.size = [titleImage size];
        titleRect.origin = CGPointMake(500, 80);
        [titleView setFrame:titleRect];
        [[self view] addSubview:titleView];
        
        UIImage *blurImage = [UIImage imageNamed:@"idle_title_mask.png"];
        titleMaskLayer = [[CALayer layer] retain];
        [titleMaskLayer setFrame:CGRectMake(0, 0, blurImage.size.width, blurImage.size.height)];
        [titleMaskLayer setPosition:CGPointMake(250, 120)];
        [titleMaskLayer setContents:(id)blurImage.CGImage];
        
        titleLayer = [[titleView layer] retain];
        [titleLayer setMask:titleMaskLayer];
        [titleLayer setOpacity:0];
        
        [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIScreen mainScreen] setBrightness:0.5];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(fadeInTitle) withObject:nil afterDelay:.5];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [titleMaskLayer removeAllAnimations];
    [titleLayer removeAllAnimations];
    [titleLayer setOpacity:0];
}

- (void)dealloc
{
    [titleMaskLayer release];
    [titleLayer release];
    [super dealloc];
}

- (void)addAnimation:(CAAnimation *)anim toLayer:(CALayer *)layer
{
    [anim setDelegate:self];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [layer addAnimation:anim forKey:nil];
}

- (CABasicAnimation *)opacityAnimationForTiteWithFadeInToggle:(BOOL)toggle duration:(CFTimeInterval)duration
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [anim setFromValue:@(!toggle)];
    [anim setToValue:@(toggle)];
    [anim setDuration:duration];
    return anim;
}

- (void)fadeInTitle
{
    animationsToComplete = 2;
    titleVisible = YES;
    
    [titleLayer setOpacity:1];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    [anim setFromValue:[NSValue valueWithCGPoint:CGPointMake(-250, 120)]];
    [anim setToValue:[NSValue valueWithCGPoint:CGPointMake(250, 120)]];
    [anim setDuration:4];
    [self addAnimation:anim toLayer:titleMaskLayer];
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [anim2 setFromValue:@(.5)];
    [anim2 setToValue:@(1)];
    
    CABasicAnimation *anim3 = [self opacityAnimationForTiteWithFadeInToggle:YES duration:4];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    [animGroup setAnimations:@[anim2, anim3]];
    [animGroup setDuration:4];
    [self addAnimation:animGroup toLayer:titleLayer];
}

- (void)fadeOutTitle
{
    animationsToComplete = 1;
    titleVisible = NO;
    
    [self addAnimation:[self opacityAnimationForTiteWithFadeInToggle:NO duration:2] toLayer:titleLayer];
}

#pragma mark animation delegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!flag || --animationsToComplete > 0) return;
    if (titleVisible) {
        [self performSelector:@selector(fadeOutTitle) withObject:nil afterDelay:30];
    } else {
        [self fadeInTitle];
    }
}

@end
