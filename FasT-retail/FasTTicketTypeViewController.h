//
//  FasTTicketTypeViewController.h
//  FasT-retail
//
//  Created by Albrecht Oster on 15.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FasTTicketTypeViewController : UIViewController
{
	NSDictionary *typeInfo;
	NSInteger number;
	float total;
    NSString *typeId;
	
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *infoLabel;
	IBOutlet UILabel *priceLabel;
	IBOutlet UILabel *numberLabel;
	IBOutlet UILabel *totalLabel;
}

@property (nonatomic, readonly) NSString *typeId;
@property (nonatomic, readonly) float total;
@property (nonatomic, readonly) NSInteger number;
@property (nonatomic, assign) id delegate;

- (IBAction)numberChanged:(UIStepper *)stepper;

- (id)initWithTypeInfo:(NSDictionary *)tI;

@end
