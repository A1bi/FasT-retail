//
//  FasTConfirmStepViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 21.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FasTStepViewController.h"

@interface FasTConfirmStepViewController : FasTStepViewController
{
    NSMutableArray *ticketTypeViews;
    
    IBOutlet UIView *ticketTypesView;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *totalLabel;
}

@end
