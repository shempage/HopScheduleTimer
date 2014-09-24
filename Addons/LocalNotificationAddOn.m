
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
    
    lua_register(L, "_localNotification", _localNotification);
}

static int _localNotification(struct lua_State *state)
{
	 // Schedule the notification
    NSLog(@"Schedule notification");

	UILocalNotification* localNotification = [[UILocalNotification alloc] init]; 
	localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
	localNotification.alertBody = @"Shem alert message";
	localNotification.timeZone = [NSTimeZone defaultTimeZone];
	localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;

	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
   
    return 1;
}

@end
