//
//  FasTStepViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTStepViewController.h"
#import "FasTOrderViewController.h"
#import "FasTEvent.h"

@interface FasTStepViewController ()

@end

@implementation FasTStepViewController

@synthesize stepName;

- (id)initWithStepName:(NSString *)name orderController:(FasTOrderViewController *)oc
{
    self = [super init];
    if (self) {
        stepName = [name retain];
        orderController = oc;
    }
    return self;
}

- (id)initWithOrderController:(FasTOrderViewController *)oc
{
    return [self initWithStepName:nil orderController:oc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [stepName release];
    [super dealloc];
}

#pragma mark class methods

- (BOOL)isValid
{
    return YES;
}

- (NSDictionary *)stepInfo
{
    return [NSDictionary dictionary];
}

@end
