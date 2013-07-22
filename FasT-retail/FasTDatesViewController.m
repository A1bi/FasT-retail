//
//  FasTDateViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 11.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTDatesViewController.h"
#import "FasTSeatsViewController.h"
#import "FasTOrderViewController.h"
#import "FasTOrder.h"
#import "FasTEvent.h"
#import "FasTEventDate.h"

@interface FasTDatesViewController ()

- (NSArray *)dates;
- (void)addDateButtons;
- (void)dateSelected:(UIButton *)btn;
- (void)deselectedDate;
- (void)updateDateButtonWithSelectedButton:(UIButton *)selected;
- (void)setDate:(FasTEventDate *)date;

@end

@implementation FasTDatesViewController

- (id)initWithOrderController:(FasTOrderViewController *)oc
{
    return [super initWithStepName:@"date" orderController:oc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDateButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [orderController updateNextButton];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)dealloc
{
    [dateButtons release];
	[super dealloc];
}

#pragma mark class methods

- (void)addDateButtons
{
    CGFloat width = self.view.bounds.size.width * .6,
            height = 55,
            x = self.view.bounds.size.width / 2 - width / 2,
            y = 150;
    
    NSMutableArray *tmpDateButtons = [NSMutableArray array];
    
    for (FasTEventDate *date in [self dates]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(x, y, width, height)];
        [button setTitle:[date localizedString] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(deselectedDate) forControlEvents:UIControlEventTouchUpOutside];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:25]];
        
        [[self view] addSubview:button];
        [tmpDateButtons addObject:button];
        
        y += height + 10;
    }
    
    [dateButtons release];
    dateButtons = [[NSArray arrayWithArray:tmpDateButtons] retain];
}

- (BOOL)isValid
{
    return [[orderController order] date] != nil;
}

- (NSArray *)dates
{
    return [[orderController event] dates];
}

- (void)setDate:(FasTEventDate *)date
{
    [[orderController order] setDate:date];
    
    [orderController updateNextButton];
}

#pragma mark date button

- (void)dateSelected:(UIButton *)btn
{
    [self performSelector:@selector(updateDateButtonWithSelectedButton:) withObject:btn afterDelay:0];
    
    NSInteger dateIndex = [dateButtons indexOfObject:btn];
    [self setDate:[self dates][dateIndex]];
}

- (void)deselectedDate
{
    [self performSelector:@selector(updateDateButtonWithSelectedButton:) withObject:nil afterDelay:0];
    
    [self setDate:nil];
}

- (void)updateDateButtonWithSelectedButton:(UIButton *)selected
{
    for (UIButton *button in dateButtons) {
        [button setHighlighted:button == selected];
    }
}

@end
