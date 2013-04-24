//
//  FasTFinishViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 23.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTFinishViewController.h"

@interface FasTFinishViewController ()

- (void)updateOrderStatusWithNotification:(NSNotification *)note;

@end

@implementation FasTFinishViewController

- (id)initWithOrderController:(FasTOrderViewController *)oc
{
    self = [super initWithOrderController:oc];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderStatusWithNotification:) name:@"orderPlaced" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [statusLabel release];
    [spinnerView release];
    [super dealloc];
}

#pragma mark class methods

- (void)updateOrderStatusWithNotification:(NSNotification *)note
{
    NSDictionary *response = [note userInfo];
    if (![response[@"ok"] boolValue]) {
        [statusLabel setText:@"Es ist ein Fehler aufgetreten"];
    }
    [spinnerView setHidden:YES];
}

@end
