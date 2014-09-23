#import "CodeaAddon.h"

@interface DisableScreenTimerAddOn : NSObject<CodeaAddon>

static int _disableScreenTimer(struct lua_State *state);

@end

