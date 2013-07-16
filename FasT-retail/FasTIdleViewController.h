//
//  FasTIdleViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 07.06.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FasTIdleViewController : UIViewController
{
    CALayer *titleMaskLayer, *titleLayer;
    BOOL titleVisible;
    NSInteger animationsToComplete;
}

@end
