//
//  AppDelegate.h
//  Hop Schedule Timer
//
//  Created by starter4ten on Friday, 19 September 2014
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
