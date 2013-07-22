//
//  FasTFinishViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 23.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FasTStepViewController.h"

@interface FasTFinishViewController : FasTStepViewController
{
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *noteLabel;
    IBOutlet UILabel *queueNumberLabel;
}

@end
