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
	NSMutableDictionary *typeInfo;
    NSString *typeId;
	
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *infoLabel;
	IBOutlet UILabel *priceLabel;
	IBOutlet UILabel *numberLabel;
	IBOutlet UILabel *totalLabel;
}

@property (nonatomic, readonly) NSString *typeId;
@property (nonatomic, readonly) NSMutableDictionary *typeInfo;
@property (nonatomic, assign) id delegate;

- (IBAction)numberChanged:(UIStepper *)stepper;

- (id)initWithTypeInfo:(NSDictionary *)tI;

@end
