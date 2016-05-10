//
//  RootsFinder.h
//  Pods
//
//  Created by Sojan P.R. on 5/4/16.
//
//

#ifndef RootsFinder_h
#define RootsFinder_h


#endif /* RootsFinder_h */
#import "AppLaunchConfig.h"
#import "Roots.h"
#import "RootsLinkOptions.h"


@interface RootsFinder : NSObject <UIWebViewDelegate>

//-- Methods--------------------//
/**
 Captures the appLaunchConfiguration for url specified.
 */
- (void) findAndFollowRoots:(NSString *)url withDelegate:(id)callback andOptions:(RootsLinkOptions *)options;

@end