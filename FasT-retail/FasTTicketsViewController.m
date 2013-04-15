//
//  FasTTicketsViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTTicketsViewController.h"
#import "FasTTicketTypeViewController.h"
#import "FasTOrderViewController.h"
#import "FasTOrder.h"

@interface FasTTicketsViewController ()

- (void)updateTotal;

@end

@implementation FasTTicketsViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSDictionary *adults = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"id", @"Erwachsene", @"name", @"", @"info", [NSNumber numberWithFloat:12.0f], @"price", nil];
	NSDictionary *kids = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"id", @"Ermäßigt", @"name", @"Kinder und Jugendliche bis 17 Jahre.", @"info", [NSNumber numberWithFloat:6.5f], @"price", nil];
	NSArray *types = [[NSArray alloc] initWithObjects:adults, kids, nil];
	
	NSMutableArray *tmpTypeVCs = [NSMutableArray array];
	int i = 0;
	for (NSDictionary *type in types) {
		
		FasTTicketTypeViewController *typeVC = [[FasTTicketTypeViewController alloc] initWithTypeInfo:type];
		[typeVC setDelegate:self];
		[tmpTypeVCs addObject:typeVC];
		[self addChildViewController:typeVC];
		
		CGRect frame = ticketsView.frame;
        frame.size.height = typeVC.view.frame.size.height;
		frame.origin.y += i * frame.size.height;
		typeVC.view.frame = frame;
		
		[[self view] addSubview:typeVC.view];
		[typeVC didMoveToParentViewController:self];
		
		i++;
		
	}
	
	typeVCs = [[NSArray arrayWithArray:tmpTypeVCs] retain];
    
    [self updateTotal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[typeVCs release];
    [totalLabel release];
    [ticketsView release];
	[super dealloc];
}

- (void)updateTotal
{
    float total = 0;
    NSInteger totalNumber = 0;
    NSMutableDictionary *tickets = [NSMutableDictionary dictionary];
	for (FasTTicketTypeViewController *typeVC in typeVCs) {
		total += [typeVC total];
        totalNumber += [typeVC number];
        [tickets setObject:[NSNumber numberWithInteger:[typeVC number]] forKey:[typeVC typeId]];
	}
    
    [[[self orderController] order] setTickets:[NSDictionary dictionaryWithDictionary:tickets]];
    
    [totalLabel setText:[NSString stringWithFormat:@"Gesamt: %i Karten für %.2f €", totalNumber, total]];
}

#pragma mark delegate methods

- (void)changedTotalOfTicketType:(FasTTicketTypeViewController *)t
{
	[self updateTotal];
}

@end
