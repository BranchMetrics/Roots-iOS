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

+(void) connect:(NSString *)url userAgent:(NSString *) userAgent andWithDelegate:(id) callback {
    roots = [[Roots alloc]init];
    roots.rootsFinder = [[RootsFinder alloc] init];
    [roots.rootsFinder findAndFollowRoots:url withUserAgent:userAgent withDelegate:callback];
}

@end

