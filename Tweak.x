#import <Foundation/Foundation.h>

@interface NSUserDefaults (Tweak_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (BOOL)isBatteryCharging;
@end

static NSString * nsDomainString = @"systems.shorty.customlockscreendurationprefs";
static NSString * nsNotificationString = @"systems.shorty.customlockscreenduration/preferences.changed";
static BOOL enabled;
static long long duration;
static BOOL chargeMode;
static long long chargingDuration;

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber * enabledValue = (NSNumber *)[defaults objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue) ? [enabledValue boolValue] : NO;

	NSNumber * durationValue = (NSNumber *)[defaults objectForKey:@"duration" inDomain:nsDomainString];
	duration = (durationValue)? [durationValue integerValue] : 1;

	NSNumber * chargeModeValue = (NSNumber *)[defaults objectForKey:@"chargeMode" inDomain:nsDomainString];
	chargeMode = (chargeModeValue) ? [chargeModeValue boolValue] : NO;

	NSNumber * chargingDurationValue = (NSNumber *)[defaults objectForKey:@"chargingDuration" inDomain:nsDomainString];
	chargingDuration = (chargingDurationValue)? [chargingDurationValue integerValue] : 1;

}

%ctor {
        // Set variables on start up
        notificationCallback(NULL, NULL, NULL, NULL, NULL);

        // Register for 'PostNotification' notifications
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
}

%hook CSBehavior

- (void)setIdleTimerDuration:(NSInteger)arg {
    if (enabled) {
        BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
        return %orig((chargeMode && charging) ? chargingDuration : duration);
    }
    
    %orig(arg);
}

%end

%hook SBDashBoardIdleTimerProvider

- (BOOL)isIdleTimerEnabled {
    if(!enabled) return %orig;
    if(!chargeMode) {
        if(duration == 0) return NO;
        return %orig;
    }
    BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
    if(!charging) {
        if(duration == 0) return NO;
        return %orig;
    }
    if(chargingDuration == 0) return NO;
    return %orig;   
}

%end
