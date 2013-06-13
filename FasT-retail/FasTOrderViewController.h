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
@class FasTIdleViewController;
@class FasTExpirationView;
@class MBProgressHUD;

@interface FasTOrderViewController : UIViewController
{
    FasTOrder *order;
	UINavigationController *nvc;
    int currentStepIndex;
    NSArray *stepControllers;
    FasTStepViewController *currentStepController;
    FasTIdleViewController *idleController;
    MBProgressHUD *hud;
    
	IBOutlet UIButton *nextBtn;
	IBOutlet UIButton *prevBtn;
    IBOutlet FasTExpirationView *expirationView;
    IBOutlet UIActivityIndicatorView *loadingView;
}

@property (nonatomic, readonly) FasTOrder *order;

- (IBAction)nextTapped:(id)sender;
- (IBAction)prevTapped:(id)sender;

- (FasTEvent *)event;
- (void)updateNextButton;
- (void)resetExpiration;

@end
