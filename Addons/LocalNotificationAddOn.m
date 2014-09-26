
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

static void _createLocalNotification(struct lua_State *state)
{
	 // Schedule the notification
    NSLog(@"Schedule notification");
	int numberOfMinutes = lua_tointeger(state, 1);
	int numberOfSeconds = numberOfMinutes * 60;
	UILocalNotification* localNotification = [[UILocalNotification alloc] init]; 
	localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:numberOfSeconds];
	localNotification.alertBody = @"Time to add hops";
	localNotification.timeZone = [NSTimeZone defaultTimeZone];
	localNotification.soundName = UILocalNotificationDefaultSoundName;
	//localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;

	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

static void _clearAllLocalNotifications(struct lua_State *state)
{

	// cancel all existing notifications
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
	
}

@end
