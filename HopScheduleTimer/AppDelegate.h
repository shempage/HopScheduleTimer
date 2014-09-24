//
//  AppDelegate.h
//  Hop Schedule Timer
//
//  Edited by hand, don't replace with the one from codea export
//  Copyright (c) starter4ten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisableScreenTimerAddOn.h"
#import "LocalNotificationAddOn.h"


@class CodeaViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DisableScreenTimerAddOn  *disableScreenTimerAddOn;

@property (strong, nonatomic) LocalNotificationAddOn  *localNotificationAddOn;

@property (strong, nonatomic) CodeaViewController *viewController;

@end
