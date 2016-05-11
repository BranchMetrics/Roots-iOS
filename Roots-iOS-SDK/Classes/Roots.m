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

@interface Roots()
/**
 * Root finder instnece for finding and following app roots for the given url.
 */
@property (nonatomic, strong) RootsFinder *rootsFinder;

@end

@implementation Roots

static Roots *roots;

//TODO: PRS need to add an array of RootFinderObject here and make Roots Singelton inorder to allow concurrent connect calls

+ (void) connect:(NSString *)url withDelegate:(id)callback andWithOptions:(RootsLinkOptions *)options {
    roots = [[Roots alloc]init];
    roots.rootsFinder = [[RootsFinder alloc] init];
    [roots.rootsFinder findAndFollowRoots:url withDelegate:callback andOptions:options];
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


@end

