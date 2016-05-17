//
//  RootsFinder.h
//  Pods
//
//  Created by Sojan P.R. on 5/4/16.
//
//
#import "AppLaunchConfig.h"
#import "Roots.h"
#import "RootsLinkOptions.h"


@interface RootsFinder : NSObject <UIWebViewDelegate>

/**
 * Captures the appLaunchConfiguration for url specified and routes according to the launch config
 */
- (void)findAndFollowRoots:(NSString *)url withDelegate:(id)callback withStateDelegate:(id)stateCallback andOptions:(RootsLinkOptions *)options;

@end


@protocol RootFinderStateDelegate <NSObject>

- (void)onRootFinderFinished:(RootsFinder *)rootFinder;

@end