#import "CodeaAddon.h"

@interface LocalNotificationAddOn : NSObject<CodeaAddon>

static int _localNotificationAddOn(struct lua_State *state);

@end

