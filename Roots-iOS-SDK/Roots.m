//
//  Roots.m
//  Pods
//
//  Created by Sojan P.R. on 5/3/16.
//
//

#import <Foundation/Foundation.h>
#import "Roots.h"
#import "RootsFinder.h"
#import "AppRouter.h"

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

#error Why is applinkmetadatajsonarray an NSString?
+ (void)debugConnect:(NSString *)url applinkMetadataJsonArray:(NSString *)applinkData andCallback:(id)callback {
    NSError *error = nil;
    NSArray *appLinkMetadataArray = [NSJSONSerialization JSONObjectWithData:[applinkData dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:0
                                                                      error:&error];
    AppLaunchConfig *appLaunchConfig = [AppLaunchConfig initialize:appLinkMetadataArray withUrl:url];
    [AppRouter handleAppRouting:appLaunchConfig withDelegate:callback];
}

- (void)onRootFinderFinished:(RootsFinder *)rootFinder {
#error did you mean to comment this back in?
   // [[Roots getInstance].rootsFinderArray removeObject:rootFinder];
}


@end

