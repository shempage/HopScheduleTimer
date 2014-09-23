
#import "AppDelegate.h"
#import "CodeaViewController.h"
#import "DisableScreenTimerAddOn.h"
#import "lua.h"

static DisableScreenTimerAddOn *disableScreenTimerAddOn;

@implementation DisableScreenTimerAddOn

+ (void) load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerAddOn:)
                                                 name:@"RegisterAddOns"
                                               object:nil];
}

+ (void) registerAddOn:(NSNotification *)notification
{
    disableScreenTimerAddOn = [[DisableScreenTimerAddOn alloc] init];
    CodeaViewController *viewController = (CodeaViewController*)[(AppDelegate*)[[UIApplication sharedApplication]delegate] viewController];
    [viewController registerAddon:disableScreenTimerAddOn];
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
    NSLog(@"DisableScreenTimerAddOn Registering Functions");
    
    //  Register the functions, defined below
    
    lua_register(L, "_disableScreenTimer", _disableScreenTimer);
}

static int _disableScreenTimer(struct lua_State *state)
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
	[UIApplication sharedApplication].idleTimerDisabled = YES;
    
    return 1;
}

@end
