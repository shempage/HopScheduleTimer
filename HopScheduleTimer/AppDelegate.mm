//
//  AppDelegate.mm
//  Hop Schedule Timer
//
//  Created by starter4ten on Friday, 19 September 2014
//  Copyright (c) starter4ten. All rights reserved.
//

#import "AppDelegate.h"
#import "CodeaViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	//registering for sending user various kinds of notifications
	if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
		[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[CodeaViewController alloc] init];
	
	self.disableScreenTimerAddOn = [[DisableScreenTimerAddOn alloc] init];
    [self.viewController registerAddon:self.disableScreenTimerAddOn];
	
	self.localNotificationAddOn = [[LocalNotificationAddOn alloc] init];
    [self.viewController registerAddon:self.localNotificationAddOn];
    
    NSString* projectPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"HopScheduleTimer.codea"];
    
    [self.viewController loadProjectAtPath:projectPath];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
	// Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        [alert show];
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

@end
