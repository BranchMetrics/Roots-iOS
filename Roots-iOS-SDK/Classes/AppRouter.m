#import <Foundation/Foundation.h>
#import "AppLaunchConfig.h"
#import "AppRouter.h"
#import <UIKit/UIKit.h>
#import "Roots.h"

@implementation AppRouter

+ (BOOL) handleAppRouting:(AppLaunchConfig *)appLaunchConfig withDelegate:(id<RootsEventsDelegate>)callback  {
    BOOL routingHandled = YES;
    if ([appLaunchConfig isLaunchSchemeAvailable]) {
        [self openAppWithUriScheme:appLaunchConfig withDelegate:callback];
    }
    else {
        [self openFallbackUrl:appLaunchConfig withDelegate:callback];
    }
    return routingHandled;
}

+ (void) openAppWithUriScheme:(AppLaunchConfig *)appLaunchConfig withDelegate:(id<RootsEventsDelegate>)callback {
    NSString *uriString = [appLaunchConfig.targetAppLaunchScheme stringByAppendingString:@"://"];
    if (appLaunchConfig.targetAppLaunchHost) {
        uriString = [uriString stringByAppendingString:appLaunchConfig.targetAppLaunchHost];
    }
    if (appLaunchConfig.targetAppLaunchPort != appLaunchConfig.PORT_UNDEFINED) {
        uriString = [uriString stringByAppendingFormat:@":%ld",(long)appLaunchConfig.targetAppLaunchPort];
    }
    if (appLaunchConfig.targetAppLaunchPath) {
        uriString = [uriString stringByAppendingString:appLaunchConfig.targetAppLaunchPath];
    }
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString: uriString]]) {
        if (appLaunchConfig.alwaysOpenAppStore) {
            [self openAppstore:appLaunchConfig withDelegate:callback];
        }
        else {
            [self openFallbackUrl:appLaunchConfig withDelegate:callback];
        }
    }
    else {
        if (callback) {
            [callback applicationLaunched:appLaunchConfig.targetAppName appStoreID:appLaunchConfig.targetAppStoreID];
        }
    }
}

+ (void) openAppstore:(AppLaunchConfig *)appLaunchConfig withDelegate:(id<RootsEventsDelegate>)callback {
    NSString *appStoreUri = @"itms-apps://itunes.apple.com/app/id";
    appStoreUri = [appStoreUri stringByAppendingString: appLaunchConfig.targetAppStoreID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:appStoreUri]];
    if (callback) {
        [callback appStoreOpened:appLaunchConfig.targetAppName appStoreID:appLaunchConfig.targetAppStoreID];
    }
    
}

+ (void) openFallbackUrl:(AppLaunchConfig *)appLaunchConfig withDelegate:(id<RootsEventsDelegate>)callback {
    NSURL *url = [NSURL URLWithString:appLaunchConfig.targetAppFallbackUrl];
    [[UIApplication sharedApplication] openURL:url];
    if (callback) {
        [callback fallbackUrlOpened:appLaunchConfig.targetAppFallbackUrl];
    }
}

@end
