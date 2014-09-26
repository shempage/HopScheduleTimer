
#import "AppDelegate.h"
#import "CodeaViewController.h"
#import "LocalNotificationAddOn.h"
#import "lua.h"

static LocalNotificationAddOn *localNotificationAddOn;

@implementation LocalNotificationAddOn

+ (void) load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerAddOn:)
                                                 name:@"RegisterAddOns"
                                               object:nil];
}

+ (void) registerAddOn:(NSNotification *)notification
{
    localNotificationAddOn = [[LocalNotificationAddOn alloc] init];
    CodeaViewController *viewController = (CodeaViewController*)[(AppDelegate*)[[UIApplication sharedApplication]delegate] viewController];
    [viewController registerAddon:localNotificationAddOn];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization stuff
    }
    return self;
}

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{
    NSLog(@"LocalNotificationAddOn Registering Functions");
    
    //  Register the functions, defined below
    
    lua_register(L, "_createLocalNotification", _createLocalNotification);
	lua_register(L, "_clearAllLocalNotifications", _clearAllLocalNotifications);

}

static void _createLocalNotification(int numberOfMinutes)
{
	 // Schedule the notification
    NSLog(@"Schedule notification");

	UILocalNotification* localNotification = [[UILocalNotification alloc] init]; 
	localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:numberOfMinutes*60];
	localNotification.alertBody = @"Time to add hops";
	localNotification.timeZone = [NSTimeZone defaultTimeZone];
	localNotification.soundName = UILocalNotificationDefaultSoundName;
	//localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;

	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

static void _clearAllLocalNotifications()
{

	// cancel all existing notifications
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
	
}

@end
