//
//  FasTAppDelegate.h
//  FasT-retail
//
//  Created by Albrecht Oster on 09.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface FasTAppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *hud;
}

@property (strong, nonatomic) UIWindow *window;

@end
