//
//  Roots.h
//  Pods
//
//  Created by Sojan P.R. on 5/3/16.
//
//

#ifndef Roots_h
#define Roots_h


#endif /* Roots_h */
#import "RootsFinder.h"
#import "RootsLinkOptions.h"

@protocol RootsEventsDelegate <NSObject>

- (void)applicationLaunched:(NSString *)appName appStoreID:(NSString *)appStoreID;
- (void)fallbackUrlOpened:(NSString *)fallbackUrl;
- (void)appStoreOpened:(NSString *)appName appStoreID:(NSString *)appStoreID;

@end

@interface Roots : NSObject

+ (void) connect:(NSString *)url withCallback:(id)callback;
+ (void) connect:(NSString *)url withCallback:(id)callback andWithOptions:(RootsLinkOptions *)options;
+ (void) debugConnect:(NSString *)url applinkMetadataJsonArray:(NSString *)applinkData andCallback:(id)callback;

@end
