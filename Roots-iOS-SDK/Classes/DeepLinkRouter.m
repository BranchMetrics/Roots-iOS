//
//  DeepLinkRouter.m
//  Pods
//
//  Created by Sojan P.R. on 5/12/16.
//
//

#import <Foundation/Foundation.h>
#import "DeepLinkRouter.h"

@interface DeepLinkRouter ()

@property (nonatomic, strong) NSMutableDictionary *deepLinkRoutingMap;

@end

@implementation DeepLinkRouter

static DeepLinkRouter *deepLinkRouter;

+ (DeepLinkRouter *) getInstance {
    if(!deepLinkRouter) {
        deepLinkRouter = [[DeepLinkRouter alloc]init];
    }
    return deepLinkRouter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.deepLinkRoutingMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (void) registerForRouting:(UIViewController *) uiViewController forAppLinkKey:(NSString *) alKey withValueFormat:(NSString *) valueFormat {
    DeepLinkRouter *deepLinRouter = [DeepLinkRouter getInstance];
    NSMutableDictionary *alTypeDictionary = [deepLinRouter.deepLinkRoutingMap objectForKey:alKey];
    if( !alTypeDictionary) {
        alTypeDictionary = [[NSMutableDictionary alloc] init];
        [deepLinRouter.deepLinkRoutingMap setObject:alTypeDictionary forKey:alKey];
    }
    
    [alTypeDictionary setObject:uiViewController forKey:valueFormat];
}


- (UIViewController *) getMatchingViewControllerForUrl:(NSString *) url andALtype:(NSString *) alKey {
    UIViewController *matchedUIViewController;
    NSMutableDictionary *alTypeDictionary = [self.deepLinkRoutingMap objectForKey:alKey];
    if (alTypeDictionary) {
        for (NSString * key in alTypeDictionary){
            if ( [self CheckForMatch:url format:key]){
                matchedUIViewController = [alTypeDictionary objectForKey:key];
                break;
            }
        }
    }
    return matchedUIViewController;
}

- (BOOL) CheckForMatch:(NSString *)url format:(NSString *) urlFormat {
    BOOL isMatch = NO;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"(\\{[^}]*\\})" options:0 error:nil];
    
    NSString *valueExpressionStr = [regex stringByReplacingMatchesInString:urlFormat options:0 range:NSMakeRange(0, [urlFormat length]) withTemplate:@".+"];
    NSRegularExpression *valueExpression = [NSRegularExpression regularExpressionWithPattern: valueExpressionStr options:0 error:nil];
    
    if([valueExpression numberOfMatchesInString:url options:0 range:NSMakeRange(0,[url length])] > 0){
        isMatch =  YES;
    }
    return isMatch;
}

+ (void) handleDeeplinkRouting:(NSURL *)url {
    NSString *urlStr = [url absoluteString];
    DeepLinkRouter *deepLinRouter = [DeepLinkRouter getInstance];
    // First look for an ios url Strong match
    UIViewController *strongMatchController = [deepLinRouter getMatchingViewControllerForUrl:urlStr andALtype:@"al:ios:url"];
    if (strongMatchController) {
        [deepLinRouter launchViewController:strongMatchController];
    }
    // if a strong ios url match not found check for a  web url match
    else {
        UIViewController *weakMatchController = [deepLinRouter getMatchingViewControllerForUrl:urlStr andALtype:@"al:web:url"];
        if (weakMatchController) {
            [deepLinRouter launchViewController:weakMatchController];
        }
    }
}

- (void) launchViewController:(UIViewController *) viewController {
    UIViewController *deepLinkPresentingController = [[[UIApplication sharedApplication].delegate window] rootViewController];
    [deepLinkPresentingController presentViewController:viewController animated:YES completion:NULL];
}

@end