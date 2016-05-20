//
//  RootsAppRouter.h
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/6/16.
//
//

@interface RootsAppRouter : NSObject

/*
 * Method for handling routing to app or to fallback options based on the app launch configuration
 */
+ (BOOL)handleAppRouting:(RootsAppLaunchConfig *)rootsAppLaunchConfig withDelegate:(id)callback;

@end
