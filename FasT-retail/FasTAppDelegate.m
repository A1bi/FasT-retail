//
//  FasTAppDelegate.m
//  FasT-retail
//
//  Created by Albrecht Oster on 09.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTAppDelegate.h"
#import "FasTOrderViewController.h"
#import "FasTApi.h"
#import "MBProgressHUD.h"

@implementation FasTAppDelegate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [hud release];
	[_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window makeKeyAndVisible];
    
    [[FasTApi defaultApi] initWithClientType:@"retail"];
	
	FasTOrderViewController *ovc = [[[FasTOrderViewController alloc] init] autorelease];
	self.window.rootViewController = ovc;
    
    hud = [[MBProgressHUD showHUDAddedTo:self.window animated:YES] retain];
    [hud setLabelFont:[UIFont systemFontOfSize:28]];
    [hud setDetailsLabelFont:[UIFont systemFontOfSize:23]];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:FasTApiIsReadyNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [hud hide:YES];
    }];
    [center addObserverForName:FasTApiCannotConnectNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:NSLocalizedStringByKey(@"outOfOrder")];
        [hud setDetailsLabelText:NSLocalizedStringByKey(@"outOfOrderDetails")];
        [hud show:YES];
    }];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setLabelText:NSLocalizedStringByKey(@"connecting")];
    [hud show:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
