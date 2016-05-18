//
//  RootsLinkOptions.h
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/10/16.
//
//

@interface RootsLinkOptions : NSObject

- (void)setUserAgent:(NSString *)userAgent;
- (void)setAlwaysFallbackToAppStore:(BOOL)alwaysFallbackToAppStore;
- (NSString *)getUserAgent;
- (BOOL)getAlwaysFallbackToAppStore;
- (BOOL)isUserOverridingFallbackRule;

@end