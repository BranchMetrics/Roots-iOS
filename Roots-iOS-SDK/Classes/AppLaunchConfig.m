//
//  AppLaunchConfig.m
//  Pods
//
//  Created by Sojan P.R. on 5/4/16.
//
//

#import <Foundation/Foundation.h>
#import "AppLaunchConfig.h"

@implementation AppLaunchConfig

//--- Keys for FB app link properties ---------//
NSString * const PROPERTY_KEY = @"property";
NSString * const CONTENT_KEY = @"content";
NSString * const PROPERTY_APP_NAME_KEY = @"al:ios:app_name";
NSString * const PROPERTY_IOS_URL_KEY = @"al:ios:url";
NSString * const PROPERTY_APPSTORE_ID_KEY = @"al:ios:app_store_id";
NSString * const PROPERTY_WEB_URL_KEY = @"al:web:url";
NSString * const PROPERTY_ALWAYS_WEB_FALLBACK_KEY = @"al:web:should_fallback";
NSInteger const PORT_UNDEFINED = -1;

+ (AppLaunchConfig *) initialize:(NSArray *)applinkMetadataArray withUrl:(NSString *)url {
    AppLaunchConfig *appLaunchConfig = [[AppLaunchConfig alloc] init];
    appLaunchConfig.actualUri = url;
    appLaunchConfig.targetAppFallbackUrl = url;
    
    for (NSDictionary *tag in applinkMetadataArray) {
        NSString *name = tag[PROPERTY_KEY];
        NSString *value = tag[CONTENT_KEY];
        
        if ([name isEqualToString:PROPERTY_APP_NAME_KEY]) {
            appLaunchConfig.targetAppName = value;
        }
        else if ([name isEqualToString:PROPERTY_APPSTORE_ID_KEY]) {
            appLaunchConfig.targetAppStoreID = value;
        }
        else if ([name isEqualToString:PROPERTY_WEB_URL_KEY]) {
            appLaunchConfig.targetAppFallbackUrl = value;
        }
        else if ([name isEqualToString:PROPERTY_ALWAYS_WEB_FALLBACK_KEY]) {
            appLaunchConfig.alwaysOpenAppStore = [value boolValue];
        }
        else if ([name isEqualToString:PROPERTY_IOS_URL_KEY]) {
            NSURLComponents * targetUrl = [NSURLComponents componentsWithString:value];
            if (targetUrl) {
                appLaunchConfig.targetAppLaunchScheme = targetUrl.scheme;
                appLaunchConfig.targetAppLaunchHost = targetUrl.host;
                appLaunchConfig.targetAppLaunchPath = targetUrl.path;
                appLaunchConfig.targetAppLaunchPort = [targetUrl.port integerValue];
                appLaunchConfig.targetAppLaunchParams = targetUrl.query;
            }
        }
    }
    return appLaunchConfig;
}

- (BOOL) isLaunchSchemeAvailable {
    return !([self.targetAppLaunchScheme isKindOfClass: [NSNull class]] || self.targetAppLaunchScheme.length == 0);
}

@end
