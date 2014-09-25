#import "CodeaAddon.h"

@interface LocalNotificationAddOn : NSObject<CodeaAddon>

static int _createLocalNotification(struct lua_State *state);
static void _clearAllLocalNotifications(struct lua_State *state);


@end

