//
//  Roots.m
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/3/16.
//
//

#import <Foundation/Foundation.h>
#import "Roots.h"
#import "RootsFinder.h"
#import "RootsAppRouter.h"

@interface Roots() <RootFinderStateDelegate>
/**
 * Root finder instance for finding and following app roots for the given url.
 */
@property (nonatomic, strong) RootsFinder *rootsFinder;
@property (nonatomic, strong) NSMutableArray *rootsFinderArray;

@end

@implementation Roots

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rootsFinderArray = [[NSMutableArray alloc] init];
    }
    return self;
}

static Roots *roots;


+ (Roots *)getInstance {
    if (!roots) {
        roots = [[Roots alloc] init];
    }
    return roots;
}

+ (void)connect:(NSString *)url withDelegate:(id)callback andWithOptions:(RootsLinkOptions *)options {
    RootsFinder *rootsFinder = [[RootsFinder alloc] init];
    [[Roots getInstance].rootsFinderArray addObject:rootsFinder];
    [rootsFinder findAndFollowRoots:url withDelegate:callback withStateDelegate:[Roots getInstance] andOptions:options];
}

+ (void)connect:(NSString *)url withDelegate:(id)callback {
    RootsLinkOptions *options = [[RootsLinkOptions alloc] init];
    [self connect:url withDelegate:callback andWithOptions:options];
}

+ (void)debugConnect:(NSString *)url applinkMetadata:(NSString *)applinkData andCallback:(id)callback {
    NSError *error = nil;
    NSArray *appLinkMetadataArray = [NSJSONSerialization JSONObjectWithData:[applinkData dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:0
                                                                      error:&error];
    RootsAppLaunchConfig *rootsAppLaunchConfig = [RootsAppLaunchConfig initialize:appLinkMetadataArray withUrl:url];
    [RootsAppRouter handleAppRouting:rootsAppLaunchConfig withDelegate:callback];
}

- (void)onRootFinderFinished:(RootsFinder *)rootFinder {
    if (roots && roots.rootsFinderArray && [roots.rootsFinderArray count]) {
        [roots.rootsFinderArray removeObject:rootFinder];
    }
}


@end

