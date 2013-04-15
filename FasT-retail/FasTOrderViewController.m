//
//  FasTOrderViewController.m
//  FasT-retail
//
//  Created by Albrecht Oster on 14.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTOrderViewController.h"
#import "FasTOrder.h"
#import "FasTDatesViewController.h"
#import "FasTTicketsViewController.h"
#import "FasTSeatsViewController.h"
#import "FasTEvent.h"


@implementation NSURLRequest(AllowAllCerts)

+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString *) host {
    return YES;
}

@end


@interface FasTOrderViewController ()

- (void)pushNextStepController;
- (void)updateEvent;

@end

@implementation FasTOrderViewController

@synthesize order, event;

- (id)init
{
    self = [super init];
    if (self) {
        nvc = [[UINavigationController alloc] init];
		[nvc setNavigationBarHidden:YES];
        
        currentStepIndex = -1;
        
        stepControllers = [[NSMutableArray array] retain];
        stepControllerClasses = [[NSArray arrayWithObjects:
                                  [FasTDatesViewController class],
                                  [FasTTicketsViewController class],
                                  [FasTSeatsViewController class],
                                nil] retain];
		
		order = [[FasTOrder alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateEvent];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self addChildViewController:nvc];
	nvc.view.frame = self.view.bounds;
	
	[[self view] addSubview:[nvc view]];
	[[self view] sendSubviewToBack:[nvc view]];
	[nvc didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[nvc release];
	[nextBtn release];
	[prevBtn release];
	[order release];
    [stepControllers release];
    [event release];
	[super dealloc];
}

#pragma mark class methods

- (void)pushNextStepController
{
    FasTStepViewController *nextStepController;
    @try {
        nextStepController = [stepControllers objectAtIndex:++currentStepIndex];     
    }
    @catch (NSException *exception) {
        nextStepController = [[[[stepControllerClasses objectAtIndex:currentStepIndex] alloc] init] autorelease];
        [nextStepController setOrderController:self];
        [stepControllers insertObject:nextStepController atIndex:currentStepIndex];
    }
    @finally {
        [nvc pushViewController:nextStepController animated:YES];
    }
}

- (void)updateEvent
{
    NSError *error = nil;
    NSString *url = @"https://fast.albisigns/api/events/current";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) NSLog(@"%@", error);
    
    NSDictionary *eventInfo = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if (error) NSLog(@"%@", error);
    
    [event release];
    event = [[FasTEvent alloc] initWithInfo:eventInfo];
    
    [self pushNextStepController];
}

#pragma mark actions

- (IBAction)nextTapped:(id)sender {
    [self pushNextStepController];
}

- (IBAction)prevTapped:(id)sender {
    if (currentStepIndex <= 0) return;
    currentStepIndex--;
	[nvc popViewControllerAnimated:YES];
}


@end
