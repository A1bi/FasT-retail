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
#import "FasTEvent.h"

@interface FasTTicketsViewController ()

- (void)updateTicketTypes;
- (void)updateTotal;

@end

@implementation FasTTicketsViewController

- (id)initWithOrderController:(FasTOrderViewController *)oc
{
    self = [super initWithStepName:@"tickets" orderController:oc];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTicketTypes];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [orderController updateNextButton];
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

#pragma mark class methods

- (void)updateTicketTypes
{
    NSMutableArray *tmpTypeVCs = [NSMutableArray array];
	int i = 0;
	for (NSDictionary *type in [[orderController event] ticketTypes]) {
		
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

- (void)updateTotal
{
    float total = 0;
    numberOfTickets = 0;
    NSMutableDictionary *tickets = [NSMutableDictionary dictionary];
	for (FasTTicketTypeViewController *typeVC in typeVCs) {
		total += [typeVC total];
        numberOfTickets += [typeVC number];
        [tickets setObject:[NSNumber numberWithInteger:[typeVC number]] forKey:[typeVC typeId]];
	}
    
    [[orderController order] setTickets:[NSDictionary dictionaryWithDictionary:tickets]];
    
    [totalLabel setText:[NSString stringWithFormat:@"Gesamt: %i Karten für %.2f €", (int)numberOfTickets, total]];
    
    [orderController updateNextButton];
}

- (BOOL)isValid
{
    return numberOfTickets > 0;
}

#pragma mark delegate methods

- (void)changedTotalOfTicketType:(FasTTicketTypeViewController *)t
{
	[self updateTotal];
}

@end
