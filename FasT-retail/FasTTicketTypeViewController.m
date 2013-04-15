//
//  FasTTicketTypeViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 15.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTTicketTypeViewController.h"
#import "FasTTicketsViewController.h"

@interface FasTTicketTypeViewController ()

@end

@implementation FasTTicketTypeViewController

@synthesize typeId, total, number, delegate;

- (id)initWithTypeInfo:(NSDictionary *)tI
{
    self = [super init];
    if (self) {
        typeInfo = [tI retain];
        typeId = [[tI objectForKey:@"id"] retain];
		total = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[nameLabel setText:[typeInfo objectForKey:@"name"]];
	[infoLabel setText:[typeInfo objectForKey:@"info"]];
	[priceLabel setText:[NSString stringWithFormat:@"je %.2f €", [[typeInfo objectForKey:@"price"] floatValue]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[typeInfo release];
    [typeId release];
    
	[nameLabel release];
	[infoLabel release];
	[numberLabel release];
	[totalLabel release];
	[priceLabel release];
	[super dealloc];
}

- (IBAction)numberChanged:(UIStepper *)stepper {
	number = (int)[stepper value];
	total = number * [[typeInfo objectForKey:@"price"] floatValue];
	
	[numberLabel setText:[NSString stringWithFormat:@"%i", number]];
	[totalLabel setText:[NSString stringWithFormat:@"%.2f €", total]];
	
	[(FasTTicketsViewController *)delegate changedTotalOfTicketType:self];
}

@end
