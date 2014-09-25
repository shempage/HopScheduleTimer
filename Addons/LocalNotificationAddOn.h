#import "CodeaAddon.h"

@interface LocalNotificationAddOn : NSObject<CodeaAddon>

static void _createLocalNotification();
static void _clearAllLocalNotifications();


@end

