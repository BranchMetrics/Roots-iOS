//
//  RootsDeepLinkRouter.h
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/12/16.
//
//


@interface RootsDeepLinkRouter : NSObject

+ (void)registerForRouting:(NSString *) controllerId forAppLinkKey:(NSString *) alKey withValueFormat:(NSString *) valueFormat;
+ (void)openUrl:(NSURL *)url;
+ (void)continueUserActivity:(NSUserActivity *)userActivity;

@end