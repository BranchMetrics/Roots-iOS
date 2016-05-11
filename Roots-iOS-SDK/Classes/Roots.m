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
 * Root finder instnece for finding and following app roots for the given url.
 */
@property (nonatomic, strong) RootsFinder *rootsFinder;
@property (nonatomic, strong) NSMutableArray *rootsFinderArray;

@end

@implementation Roots

static Roots *roots;

//TODO: PRS need to add an array of RootFinderObject here and make Roots Singelton inorder to allow concurrent connect calls

+ (void) connect:(NSString *)url withDelegate:(id)callback andWithOptions:(RootsLinkOptions *)options {
    RootsFinder *rootsFinder = [[RootsFinder alloc] init];
    [[Roots getInstance].rootsFinderArray addObject:rootsFinder];
    [rootsFinder findAndFollowRoots:url withDelegate:callback withStateDelegate:[Roots getInstance] andOptions:options];
}

+ (void) connect:(NSString *)url withDelegate:(id)callback {
    RootsLinkOptions *options = [[RootsLinkOptions alloc] init];
    [self connect:url withDelegate:callback andWithOptions:options];
}

+ (void) debugConnect:(NSString *)url applinkMetadataJsonArray:(NSString *)applinkData andCallback:(id)callback {
    NSError *error = nil;
    NSArray *appLinkMetadataArray = [NSJSONSerialization JSONObjectWithData:[applinkData dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:0
                                                                      error:&error];
    AppLaunchConfig *appLaunchConfig = [AppLaunchConfig initialize:appLinkMetadataArray withUrl:url];
    [AppRouter handleAppRouting:appLaunchConfig withDelegate:callback];
}

+ (Roots *) getInstance {
    if (!roots) {
        roots = [[Roots alloc]init];
    }
    return roots;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rootsFinderArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void) onRootFinderFinished:(RootsFinder *)rootFinder {
    [[Roots getInstance].rootsFinderArray removeObject:rootFinder];
}


@end

