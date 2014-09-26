#import "CodeaAddon.h"

@interface LocalNotificationAddOn : NSObject<CodeaAddon>

static void _createLocalNotification(struct lua_State *state);
static void _clearAllLocalNotifications();


@end

