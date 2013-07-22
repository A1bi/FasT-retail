//
//  FasTConfirmStepViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 21.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTConfirmStepViewController.h"
#import "FasTOrderViewController.h"
#import "FasTOrder.h"
#import "FasTEvent.h"
#import "FasTEventDate.h"
#import "FasTTicketType.h"
#import "FasTFormatter.h"

@interface FasTConfirmStepViewController ()

- (void)updateDate;
- (void)updateTickets;

@end

@implementation FasTConfirmStepViewController

- (id)initWithOrderController:(FasTOrderViewController *)oc
{
    self = [super initWithStepName:@"confirm" orderController:oc];
    if (self) {
        ticketTypeViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDate];
    [self updateTickets];
}

- (void)dealloc {
    [ticketTypesView release];
    [dateLabel release];
    [totalLabel release];
    [super dealloc];
}

- (void)updateDate
{
    [dateLabel setText:[[[orderController order] date] localizedString]];
}

- (void)updateTickets
{
    for (UIView *typeView in ticketTypeViews) {
        [typeView removeFromSuperview];
    }
    [ticketTypeViews removeAllObjects];
    
    int y = ticketTypesView.frame.origin.y;
    for (NSDictionary *typeInfo in [[orderController order] tickets]) {
        NSInteger number = [typeInfo[@"number"] intValue];
        FasTTicketType *type = typeInfo[@"type"];
        
        if (number < 1) continue;
        
        UIView *typeView = [[[NSBundle mainBundle] loadNibNamed:@"FasTConfirmTicketTypeView" owner:nil options:nil] objectAtIndex:0];
        [ticketTypeViews addObject:typeView];
        [[self view] addSubview:typeView];
        
        CGRect frame = typeView.frame;
        frame.origin.x += ticketTypesView.frame.origin.x;
        frame.origin.y += y;
        y += frame.size.height;
        typeView.frame = frame;
        
        NSArray *strings = @[
                             [NSString stringWithFormat:@"%i %@", number, [type name]],
                             [NSString stringWithFormat:NSLocalizedStringByKey(@"ticketPriceEach"), [type localizedPrice]],
                             [FasTFormatter stringForPrice:[typeInfo[@"total"] floatValue]]
                             ];
        int i = 1;
        for (NSString *string in strings) {
            [(UILabel *)[typeView viewWithTag:i] setText:string];
            i++;
        }
    }
    
    [totalLabel setText:[NSString stringWithFormat:NSLocalizedStringByKey(@"finalPriceAndNumberOfTickets"), [[orderController order] numberOfTickets], [FasTFormatter stringForPrice:[[orderController order] total]]]];
}

@end
