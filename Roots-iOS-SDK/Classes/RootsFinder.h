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

@interface RootsFinder : NSObject <UIWebViewDelegate>

//-- Methods--------------------//
/**
 Captures the appLaunchConfiguration for url specified.
 */
- (void) findAndFollowRoots:(NSString *)url withUserAgent:(NSString *) userAgent withDelegate:(id)callback;

@end