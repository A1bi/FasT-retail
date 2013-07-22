//
//  FasTOrderViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FasTExpirationView.h"

@class FasTOrder;
@class FasTEvent;
@class FasTStepViewController;
@class FasTIdleViewController;
@class FasTExpirationView;
@class MBProgressHUD;

@interface FasTOrderViewController : UIViewController <FasTExpirationViewDelegate>
{
    FasTOrder *order;
	UINavigationController *nvc;
    int currentStepIndex;
    NSArray *stepControllers;
    FasTStepViewController *currentStepController;
    FasTIdleViewController *idleController;
    MBProgressHUD *hud;
    BOOL returnedFromIdle;
    
	IBOutlet UIButton *nextBtn;
	IBOutlet UIButton *prevBtn;
    IBOutlet FasTExpirationView *expirationView;
}

@property (nonatomic, readonly) FasTOrder *order;

- (IBAction)nextTapped:(id)sender;
- (IBAction)prevTapped:(id)sender;

- (FasTEvent *)event;
- (void)updateNextButton;
- (void)toggleWaitingSpinner:(BOOL)toggle;
- (void)showIdleControllerWithDelay:(NSTimeInterval)delay;
- (void)resetExpiration;

@end
