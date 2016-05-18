//
//  RootsLinkOptions.m
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/10/16.
//
//

#import <Foundation/Foundation.h>
#import "RootsLinkOptions.h"

@interface RootsLinkOptions()

@property (strong, nonatomic) NSString *userAgent;
@property (nonatomic) BOOL alwaysFallbackToAppStore;
@property (nonatomic) BOOL isUserOverridingFallbackRule;

@end

@implementation RootsLinkOptions

- (void)setUserAgent:(NSString *)userAgent {
    _userAgent = userAgent;
}

- (void)setAlwaysFallbackToAppStore:(BOOL)alwaysFallbackToAppStore {
    _alwaysFallbackToAppStore = alwaysFallbackToAppStore;
    _isUserOverridingFallbackRule = YES;
}

- (NSString *)getUserAgent {
    return _userAgent;
}

- (BOOL)getAlwaysFallbackToAppStore {
    return _alwaysFallbackToAppStore;
}

- (BOOL)isUserOverridingFallbackRule {
    return _isUserOverridingFallbackRule;
}

@end