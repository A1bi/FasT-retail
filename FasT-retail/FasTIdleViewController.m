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
        UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"idle_background.png"]] autorelease];
        [[self view] addSubview:background];
        
        [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIScreen mainScreen] setBrightness:0.3];
}

@end
