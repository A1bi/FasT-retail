//
//  FasTTicketTypeViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 15.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTTicketTypeViewController.h"
#import "FasTTicketsViewController.h"
#import "FasTFormatter.h"

@interface FasTTicketTypeViewController ()

@end

@implementation FasTTicketTypeViewController

@synthesize typeId, typeInfo, delegate;

- (id)initWithTypeInfo:(NSDictionary *)tI
{
    self = [super init];
    if (self) {
        typeInfo = [[NSMutableDictionary dictionaryWithDictionary:tI] retain];
        typeId = tI[@"id"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: NSNull should be nil (JSONSerialization)
    NSString *info = [typeInfo objectForKey:@"info"];
    if ([info isKindOfClass:[NSNull class]]) info = nil;
    
	[nameLabel setText:[typeInfo objectForKey:@"name"]];
	[infoLabel setText:info];
	[priceLabel setText:[NSString stringWithFormat:NSLocalizedStringByKey(@"ticketPriceEach"), [FasTFormatter stringForPrice:[typeInfo[@"price"] floatValue]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[typeInfo release];
    
	[nameLabel release];
	[infoLabel release];
	[numberLabel release];
	[totalLabel release];
	[priceLabel release];
	[super dealloc];
}

#pragma mark actions

- (IBAction)numberChanged:(UIStepper *)stepper {
	NSInteger number = (int)[stepper value];
	float total = number * [typeInfo[@"price"] floatValue];
    
    typeInfo[@"number"] = @(number);
    typeInfo[@"total"] = @(total);
	
	[numberLabel setText:[NSString stringWithFormat:@"%i", number]];
	[totalLabel setText:[FasTFormatter stringForPrice:total]];
	
	[(FasTTicketsViewController *)delegate changedTotalOfTicketType:self];
}

@end
