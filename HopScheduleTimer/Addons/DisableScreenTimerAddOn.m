#import "lua.h"
#import "DisableScreenTimerAddOn.h"

@implementation DisableScreenTimerAddOn

#pragma mark - CodeaAddon Delegate

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{

    lua_register(L, "disableScreenTimer", disableScreenTimer);
  
    self.codeaViewController = controller;
}

static int disableScreenTimer() {
    
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	[UIApplication sharedApplication].idleTimerDisabled = YES;
    
    return 1;
}

