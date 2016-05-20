//
//  RootsAppLaunchConfig.m
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/4/16.
//
//

#import <Foundation/Foundation.h>
#import "RootsAppLaunchConfig.h"

@implementation RootsAppLaunchConfig

//--- Keys for FB app link properties ---------//
NSString * const PROPERTY_KEY = @"property";
NSString * const CONTENT_KEY = @"content";
NSString * const PROPERTY_APP_NAME_KEY = @"al:ios:app_name";
NSString * const PROPERTY_IOS_URL_KEY = @"al:ios:url";
NSString * const PROPERTY_APPSTORE_ID_KEY = @"al:ios:app_store_id";
NSString * const PROPERTY_WEB_URL_KEY = @"al:web:url";
NSString * const PROPERTY_ALWAYS_WEB_FALLBACK_KEY = @"al:web:should_fallback";
NSInteger const PORT_UNDEFINED = -1;

+ (RootsAppLaunchConfig *)initialize:(NSArray *)applinkMetadataArray withUrl:(NSString *)url {
    RootsAppLaunchConfig *rootsAppLaunchConfig = [[RootsAppLaunchConfig alloc] init];
    rootsAppLaunchConfig.actualUri = url;
    rootsAppLaunchConfig.targetAppFallbackUrl = url;
    
    for (NSDictionary *tag in applinkMetadataArray) {
        NSString *name = tag[PROPERTY_KEY];
        NSString *value = tag[CONTENT_KEY];
        
        if ([name isEqualToString:PROPERTY_APP_NAME_KEY]) {
            rootsAppLaunchConfig.targetAppName = value;
        }
        else if ([name isEqualToString:PROPERTY_APPSTORE_ID_KEY]) {
            rootsAppLaunchConfig.targetAppStoreID = value;
        }
        else if ([name isEqualToString:PROPERTY_WEB_URL_KEY]) {
            rootsAppLaunchConfig.targetAppFallbackUrl = value;
        }
        else if ([name isEqualToString:PROPERTY_ALWAYS_WEB_FALLBACK_KEY]) {
            rootsAppLaunchConfig.alwaysOpenAppStore = [value boolValue];
        }
        else if ([name isEqualToString:PROPERTY_IOS_URL_KEY]) {
            NSURLComponents * targetUrl = [NSURLComponents componentsWithString:value];
            if (targetUrl) {
                rootsAppLaunchConfig.targetAppLaunchScheme = targetUrl.scheme;
                rootsAppLaunchConfig.targetAppLaunchHost = targetUrl.host;
                rootsAppLaunchConfig.targetAppLaunchPath = targetUrl.path;
                rootsAppLaunchConfig.targetAppLaunchPort = [targetUrl.port integerValue];
                rootsAppLaunchConfig.targetAppLaunchParams = targetUrl.query;
            }
        }
    }
    return rootsAppLaunchConfig;
}

- (BOOL)isLaunchSchemeAvailable {
    return !([self.targetAppLaunchScheme isKindOfClass: [NSNull class]] || self.targetAppLaunchScheme.length == 0);
}

@end
