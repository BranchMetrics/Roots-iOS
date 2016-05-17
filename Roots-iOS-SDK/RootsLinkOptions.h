//
//  RootsLinkOptions.h
//  Pods
//
//  Created by Sojan P.R. on 5/10/16.
//
//

#ifndef RootsLinkOptions_h
#define RootsLinkOptions_h


#endif /* RootsLinkOptions_h */

@interface RootsLinkOptions : NSObject
- (void) setUserAgent:(NSString *)userAgent;
- (void) setAlwaysFallbackToAppStore:(BOOL)alwaysFallbackToAppStore;
- (NSString *) getUserAgent;
- (BOOL) getAlwaysFallbackToAppStore;
- (BOOL) isUserOverridingFallbackRule;
@end