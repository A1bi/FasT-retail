//
//  FasTSeatsViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FasTStepViewController.h"

@class FasTSeatsView;

@interface FasTSeatsViewController : FasTStepViewController
{
    FasTSeatsView *seatsView;
}

@property (retain, nonatomic) IBOutlet FasTSeatsView *seatsView;

@end
