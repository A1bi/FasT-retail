//
//  FasTOrderViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FasTOrder;

@interface FasTOrderViewController : UIViewController
{
    FasTOrder *order;
	UINavigationController *nvc;
    int currentStepIndex;
    NSMutableArray *stepControllers;
    NSArray *stepControllerClasses;
    
	IBOutlet UIButton *nextBtn;
	IBOutlet UIButton *prevBtn;
}

@property (nonatomic, readonly) FasTOrder *order;

- (IBAction)nextTapped:(id)sender;
- (IBAction)prevTapped:(id)sender;

@end
