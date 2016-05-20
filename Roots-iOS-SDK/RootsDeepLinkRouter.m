//
//  RootsDeepLinkRouter.m
//  Roots-SDK
//
//  Created by Sojan P.R. on 5/12/16.
//
//

#import <Foundation/Foundation.h>
#import "RootsDeepLinkRouter.h"
#import "Roots.h"

@interface RootsDeepLinkRouter ()

@property (nonatomic, strong) NSMutableDictionary *deepLinkRoutingMap;

@end

@implementation RootsDeepLinkRouter

static RootsDeepLinkRouter *rootsDeepLinkRouter;

+ (RootsDeepLinkRouter *)getInstance {
    if(!rootsDeepLinkRouter) {
        rootsDeepLinkRouter = [[RootsDeepLinkRouter alloc]init];
    }
    return rootsDeepLinkRouter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.deepLinkRoutingMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (void)registerForRouting:(NSString *) controllerId forAppLinkKey:(NSString *) alKey withValueFormat:(NSString *) valueFormat {
    RootsDeepLinkRouter *rootsDeepLinRouter = [RootsDeepLinkRouter getInstance];
    NSMutableDictionary *alTypeDictionary = [rootsDeepLinRouter.deepLinkRoutingMap objectForKey:alKey];
    if( !alTypeDictionary) {
        alTypeDictionary = [[NSMutableDictionary alloc] init];
        [rootsDeepLinRouter.deepLinkRoutingMap setObject:alTypeDictionary forKey:alKey];
    }
    
    [alTypeDictionary setObject:controllerId forKey:valueFormat];
}

- (NSString *)getMatchingViewControllerForUrl:(NSString *) url andALtype:(NSString *) alKey withParamDict:(NSMutableDictionary **) paramDict {
    NSString *matchedUIViewControllerName = nil;
    NSString *matchedURLFormat;
    NSMutableDictionary *alTypeDictionary = [self.deepLinkRoutingMap objectForKey:alKey];
    if (alTypeDictionary) {
        for (NSString * key in alTypeDictionary){
            if ( [self checkForMatch:url format:key]){
                matchedUIViewControllerName = [alTypeDictionary objectForKey:key];
                matchedURLFormat = key;
                break;
            }
        }
    }
    if (matchedUIViewControllerName) {
        *paramDict = [self getParamValueMap:url withFormat:matchedURLFormat];
    }
    return matchedUIViewControllerName;
}

- (BOOL)checkForMatch:(NSString *)url format:(NSString *) urlFormat {
    BOOL isMatch = NO;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\{[^}]*\\})" options:0 error:nil];
    NSString *valueExpressionStr = [regex stringByReplacingMatchesInString:urlFormat options:0 range:NSMakeRange(0, [urlFormat length]) withTemplate:@"(.+)"];
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\*" options:0 error:nil];
    valueExpressionStr = [regex stringByReplacingMatchesInString:valueExpressionStr options:0 range:NSMakeRange(0, [valueExpressionStr length]) withTemplate:@".+"];
    
    NSRegularExpression *valueExpression = [NSRegularExpression regularExpressionWithPattern: valueExpressionStr options:0 error:nil];
    
    if([valueExpression numberOfMatchesInString:url options:0 range:NSMakeRange(0,[url length])] > 0){
        isMatch =  YES;
    }
    return isMatch;
}

+ (void)openUrl:(NSURL *)url {
    [self routeToAppropriateViewController:[url absoluteString]];
}

+ (void)continueUserActivity:(NSUserActivity *)userActivity {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        [self routeToAppropriateViewController:[userActivity.webpageURL absoluteString]];
    }
}

+ (void)routeToAppropriateViewController:(NSString *)urlStr {
    RootsDeepLinkRouter *rootsDeepLinkRouter = [RootsDeepLinkRouter getInstance];
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    
    // First look for an ios url strong match
    NSString *strongMatchControllerName = [rootsDeepLinkRouter getMatchingViewControllerForUrl:urlStr andALtype:@"al:ios:url" withParamDict:&paramsDict];
    if (strongMatchControllerName) {
        [rootsDeepLinkRouter launchViewController:strongMatchControllerName withParamsDict:paramsDict];
    }
    // if a strong ios url match not found check for a  web url match
    else {
        NSString *weakMatchControllerName = [rootsDeepLinkRouter getMatchingViewControllerForUrl:urlStr andALtype:@"al:web:url" withParamDict:&paramsDict];
        if (weakMatchControllerName) {
            [rootsDeepLinkRouter launchViewController:weakMatchControllerName withParamsDict:paramsDict];
        }
    }

}

- (void)launchViewController:(NSString *) viewControllerName withParamsDict:(NSDictionary *)paramDict {
    UIViewController *deepLinkPresentingController = [[[UIApplication sharedApplication].delegate window] rootViewController];
    
    Class targetUIViewController = NSClassFromString(viewControllerName);
    targetUIViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:viewControllerName];
    
    // Launch the controller
    [deepLinkPresentingController presentViewController:targetUIViewController animated:YES completion:NULL];
    
    // Pass the roting params if controller is interested
    if ([targetUIViewController conformsToProtocol:@protocol(RootsRoutingDelegate)]) {
        UIViewController <RootsRoutingDelegate> *rootsRoutingDelegateInstance = (UIViewController <RootsRoutingDelegate> *) targetUIViewController;
        [rootsRoutingDelegateInstance configureControlWithRoutingData:paramDict];
    }
    
}

- (NSMutableDictionary *)getParamValueMap:(NSString *)url withFormat:(NSString *) urlFormat {
    NSMutableDictionary * paramValDict = [[NSMutableDictionary alloc] init];
    
    NSRegularExpression *valueRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\{[^}]*\\})" options:0 error:nil];
    NSString *valueExpressionStr = [valueRegex stringByReplacingMatchesInString:urlFormat options:0 range:NSMakeRange(0, [urlFormat length]) withTemplate:@"(.+)"];
    valueRegex = [NSRegularExpression regularExpressionWithPattern:@"\\*" options:0 error:nil];
    valueExpressionStr = [valueRegex stringByReplacingMatchesInString:valueExpressionStr options:0 range:NSMakeRange(0, [valueExpressionStr length]) withTemplate:@".+"];
    NSRegularExpression *valueExpression = [NSRegularExpression regularExpressionWithPattern: valueExpressionStr options:0 error:nil];
    
    NSRegularExpression *paramRegex = [NSRegularExpression regularExpressionWithPattern:@"\\*" options:0 error:nil];
    NSString *paramExpressionStr = [paramRegex stringByReplacingMatchesInString:urlFormat options:0 range:NSMakeRange(0, [urlFormat length]) withTemplate:@".+"];
    paramRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\{[^/]*\\})" options:0 error:nil];
    paramExpressionStr = [paramRegex stringByReplacingMatchesInString:paramExpressionStr options:0 range:NSMakeRange(0, [paramExpressionStr length]) withTemplate:@"\\\\{(.*?)\\\\}"];
    NSError *errorStr;
    NSRegularExpression *paramExpression = [NSRegularExpression regularExpressionWithPattern: paramExpressionStr options:0 error:&errorStr];
    
    NSTextCheckingResult *paramCheckingResult = [paramExpression firstMatchInString:urlFormat options:NSMatchingReportCompletion range:NSMakeRange(0, urlFormat.length)];
    NSTextCheckingResult *valueCheckingResult = [valueExpression firstMatchInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, url.length)];
    
    if ([paramCheckingResult numberOfRanges] > 1 ) {
        for (int i = 1; i < [paramCheckingResult numberOfRanges]; i++) {
            if ( i < [valueCheckingResult numberOfRanges]) {
                [paramValDict setObject:[url substringWithRange: [valueCheckingResult rangeAtIndex:i]] forKey:[urlFormat substringWithRange: [paramCheckingResult rangeAtIndex:i]]];
            }
        }
    }
    return paramValDict;
}

@end