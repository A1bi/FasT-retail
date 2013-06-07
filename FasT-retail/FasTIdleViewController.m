//
//  FasTIdleViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 07.06.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTIdleViewController.h"

@interface FasTIdleViewController ()

@end

@implementation FasTIdleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
