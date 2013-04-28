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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDate];
    [self updateTickets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [ticketTypesView release];
    [dateLabel release];
    [totalLabel release];
    [super dealloc];
}

- (void)updateDate
{
    NSDate *date = [[orderController order] date][@"date"];
    [dateLabel setText:[FasTFormatter stringForEventDate:date]];
}

- (void)updateTickets
{
    for (UIView *typeView in ticketTypeViews) {
        [typeView removeFromSuperview];
    }
    [ticketTypeViews removeAllObjects];
    
    int y = ticketTypesView.frame.origin.y;
    for (NSString *typeId in [[orderController order] tickets]) {
        NSDictionary *ticket = [[orderController order] tickets][typeId];
        if ([ticket[@"total"] intValue] < 1) continue;
        
        UIView *typeView = [[[NSBundle mainBundle] loadNibNamed:@"FasTConfirmTicketTypeView" owner:nil options:nil] objectAtIndex:0];
        [ticketTypeViews addObject:typeView];
        [[self view] addSubview:typeView];
        
        CGRect frame = typeView.frame;
        frame.origin.x += ticketTypesView.frame.origin.x;
        frame.origin.y += y;
        y += frame.size.height;
        typeView.frame = frame;
        
        NSArray *strings = @[
                             [NSString stringWithFormat:@"%i %@", [ticket[@"number"] intValue], ticket[@"name"]],
                             [NSString stringWithFormat:NSLocalizedStringByKey(@"ticketPriceEach"), [FasTFormatter stringForPrice:[ticket[@"price"] floatValue]]],
                             [FasTFormatter stringForPrice:[ticket[@"total"] floatValue]]
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
