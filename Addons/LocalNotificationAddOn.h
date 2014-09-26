#import "CodeaAddon.h"

@interface LocalNotificationAddOn : NSObject<CodeaAddon>

static void _createLocalNotification(int numberOfMinutes);
static void _clearAllLocalNotifications();


@end

