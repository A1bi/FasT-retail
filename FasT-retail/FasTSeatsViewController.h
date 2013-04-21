//
//  FasTSeatsViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FasTStepViewController.h"
#import "FasTSeatingView.h"

@class FasTSeatingView;

@interface FasTSeatsViewController : FasTStepViewController <FasTSeatingViewDelegate>
{
    FasTSeatingView *seatsView;
}

@property (retain, nonatomic) IBOutlet FasTSeatingView *seatsView;

@end
