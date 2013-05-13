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
@class FasTStepViewController;

@interface FasTOrderViewController : UIViewController
{
    FasTOrder *order;
	UINavigationController *nvc;
    int currentStepIndex;
    NSArray *stepControllers;
    FasTStepViewController *currentStepController;
    
	IBOutlet UIButton *nextBtn;
	IBOutlet UIButton *prevBtn;
}

@property (nonatomic, readonly) FasTOrder *order;

- (IBAction)nextTapped:(id)sender;
- (IBAction)prevTapped:(id)sender;

- (FasTEvent *)event;
- (void)updateNextButton;

@end
