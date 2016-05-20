//
//  RootsAppLaunchConfig.h
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/3/16.
//
//

@interface RootsAppLaunchConfig : NSObject

@property (strong, nonatomic) NSString *actualUri;
@property (strong, nonatomic) NSString *targetUri;
@property (strong, nonatomic) NSString *targetAppName;
@property (strong, nonatomic) NSString *targetAppLaunchScheme;
@property (strong, nonatomic) NSString *targetAppLaunchHost;
@property (strong, nonatomic) NSString *targetAppLaunchPath;
@property (nonatomic) NSInteger targetAppLaunchPort;
@property (strong, nonatomic) NSString *targetAppLaunchParams;
@property (strong, nonatomic) NSString *targetAppStoreID;
@property (strong, nonatomic) NSString *targetAppFallbackUrl;
@property (nonatomic) BOOL alwaysOpenAppStore;
@property (nonatomic) NSInteger const PORT_UNDEFINED;

/*
 * Create and return an RootsAppLaunchConfig instace from the given App Link meta data
 */
+ (RootsAppLaunchConfig *)initialize:(NSArray *)applinkMetadataArray withUrl:(NSString *)url;

/*
 * Check if this Launch Config contains a scheme to launch the app.
 */
- (BOOL)isLaunchSchemeAvailable;

@end