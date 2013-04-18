//
//  FasTOrderViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FasTOrder;
@class FasTEvent;

@interface FasTOrderViewController : UIViewController
{
    FasTOrder *order;
	UINavigationController *nvc;
    int currentStepIndex;
    NSArray *stepControllers;
    
	IBOutlet UIButton *nextBtn;
	IBOutlet UIButton *prevBtn;
}

@property (nonatomic, readonly) FasTOrder *order;
@property (nonatomic, retain) FasTEvent *event;

- (IBAction)nextTapped:(id)sender;
- (IBAction)prevTapped:(id)sender;

@end
