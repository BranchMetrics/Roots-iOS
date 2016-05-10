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
 Delegate for Roots events
 */
@property (nonatomic, strong) RootsFinder *rootsFinder;

@end



@implementation Roots

static Roots *roots;

+ (void) connect:(NSString *)url withCallback:(id)callback andWithOptions:(RootsLinkOptions *)options {
    roots = [[Roots alloc]init];
    roots.rootsFinder = [[RootsFinder alloc] init];
    [roots.rootsFinder findAndFollowRoots:url withDelegate:callback andOptions:options];
}

+ (void) connect:(NSString *)url withCallback:(id)callback {
    RootsLinkOptions *options = [[RootsLinkOptions alloc] init];
    [self connect:url withCallback:callback andWithOptions:options];
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

