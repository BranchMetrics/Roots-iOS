//
//  RootsAppRouter.h
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/3/16.
//
//

#import <Foundation/Foundation.h>
#import "RootsAppLaunchConfig.h"
#import "RootsAppRouter.h"
#import <UIKit/UIKit.h>
#import "Roots.h"

@implementation RootsAppRouter

+ (BOOL)handleAppRouting:(RootsAppLaunchConfig *)rootsAppLaunchConfig withDelegate:(id<RootsEventsDelegate>)callback  {
    BOOL routingHandled = YES;
    if ([rootsAppLaunchConfig isLaunchSchemeAvailable]) {
        [self openAppWithUriScheme:rootsAppLaunchConfig withDelegate:callback];
    }
    else {
        [self openFallbackUrl:rootsAppLaunchConfig withDelegate:callback];
    }
    return routingHandled;
}

+ (void)openAppWithUriScheme:(RootsAppLaunchConfig *)rootsAppLaunchConfig withDelegate:(id<RootsEventsDelegate>)callback {
    NSString *uriString = [rootsAppLaunchConfig.targetAppLaunchScheme stringByAppendingString:@"://"];
    if (rootsAppLaunchConfig.targetAppLaunchHost) {
        uriString = [uriString stringByAppendingString:rootsAppLaunchConfig.targetAppLaunchHost];
    }
    if (rootsAppLaunchConfig.targetAppLaunchPort != rootsAppLaunchConfig.PORT_UNDEFINED) {
        uriString = [uriString stringByAppendingFormat:@":%ld",(long)rootsAppLaunchConfig.targetAppLaunchPort];
    }
    if (rootsAppLaunchConfig.targetAppLaunchPath) {
        uriString = [uriString stringByAppendingString:rootsAppLaunchConfig.targetAppLaunchPath];
    }
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString: uriString]]) {
        if (rootsAppLaunchConfig.alwaysOpenAppStore) {
            [self openAppstore:rootsAppLaunchConfig withDelegate:callback];
        }
        else {
            [self openFallbackUrl:rootsAppLaunchConfig withDelegate:callback];
        }
    }
    else {
        if (callback) {
            [callback applicationLaunched:rootsAppLaunchConfig.targetAppName appStoreID:rootsAppLaunchConfig.targetAppStoreID];
        }
    }
}

+ (void)openAppstore:(RootsAppLaunchConfig *)rootsAppLaunchConfig withDelegate:(id<RootsEventsDelegate>)callback {
    NSString *appStoreUri = @"itms-apps://itunes.apple.com/app/id";
    appStoreUri = [appStoreUri stringByAppendingString: rootsAppLaunchConfig.targetAppStoreID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:appStoreUri]];
    if (callback) {
        [callback appStoreOpened:rootsAppLaunchConfig.targetAppName appStoreID:rootsAppLaunchConfig.targetAppStoreID];
    }
    
}

+ (void)openFallbackUrl:(RootsAppLaunchConfig *)rootsAppLaunchConfig withDelegate:(id<RootsEventsDelegate>)callback {
    NSURL *url = [NSURL URLWithString:rootsAppLaunchConfig.targetAppFallbackUrl];
    [[UIApplication sharedApplication] openURL:url];
    if (callback) {
        [callback fallbackUrlOpened:rootsAppLaunchConfig.targetAppFallbackUrl];
    }
}

@end
