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
	UINavigationController *nvc;
	IBOutlet UIButton *nextBtn;
	IBOutlet UIButton *prevBtn;
	FasTOrder *order;
}

@property (nonatomic, readonly) FasTOrder *order;

- (IBAction)nextTapped:(id)sender;
- (IBAction)prevTapped:(id)sender;

- (void)dateChanged:(NSInteger)date;

@end
