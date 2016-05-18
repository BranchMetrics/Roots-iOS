//
//  AppDelegate.m
//  Roots-SDK-Routing-TestBed
//
//  Created by Sojan P.R. on 5/12/16.
//  Copyright © 2016 Branch. All rights reserved.
//

#import "AppDelegate.h"
#import "RootsDeepLinkRouter.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Configure controller for deeplinking
    [RootsDeepLinkRouter registerForRouting:@"DeepLinkRoutingExampleController" forAppLinkKey:@"al:ios:url" withValueFormat:@"myscheme://*/user/{User_ID}/{Name}"];
    [RootsDeepLinkRouter registerForRouting:@"DeepLinkRoutingExampleController" forAppLinkKey:@"al:web:url" withValueFormat:@"https://my_awesome_site.com/*/{user_id}"];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [RootsDeepLinkRouter handleDeeplinkRouting:url];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    
    // V2 will need to add support for Universal Links
    
    return YES;
}


@end
