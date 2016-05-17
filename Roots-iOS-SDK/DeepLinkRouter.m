//
//  DeepLinkRouter.m
//  Pods
//
//  Created by Sojan P.R. on 5/12/16.
//
//

#import <Foundation/Foundation.h>
#import "DeepLinkRouter.h"
#import "Roots.h"

@interface DeepLinkRouter ()

@property (nonatomic, strong) NSMutableDictionary *deepLinkRoutingMap;

@end

@implementation DeepLinkRouter

static DeepLinkRouter *deepLinkRouter;

+ (DeepLinkRouter *)getInstance {
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

+ (void)registerForRouting:(NSString *) controllerId forAppLinkKey:(NSString *) alKey withValueFormat:(NSString *) valueFormat {
    DeepLinkRouter *deepLinRouter = [DeepLinkRouter getInstance];
    NSMutableDictionary *alTypeDictionary = [deepLinRouter.deepLinkRoutingMap objectForKey:alKey];
    if( !alTypeDictionary) {
        alTypeDictionary = [[NSMutableDictionary alloc] init];
        [deepLinRouter.deepLinkRoutingMap setObject:alTypeDictionary forKey:alKey];
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

+ (void)handleDeeplinkRouting:(NSURL *)url {
    NSString *urlStr = [url absoluteString];
    DeepLinkRouter *deepLinRouter = [DeepLinkRouter getInstance];
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc]init];
    // First look for an ios url Strong match
    NSString *strongMatchControllerName = [deepLinRouter getMatchingViewControllerForUrl:urlStr andALtype:@"al:ios:url" withParamDict:&paramsDict];
    if (strongMatchControllerName) {
        [deepLinRouter launchViewController:strongMatchControllerName withParamsDict:paramsDict];
    }
    // if a strong ios url match not found check for a  web url match
    else {
        NSString *weakMatchControllerName = [deepLinRouter getMatchingViewControllerForUrl:urlStr andALtype:@"al:web:url" withParamDict:&paramsDict];
        if (weakMatchControllerName) {
            [deepLinRouter launchViewController:weakMatchControllerName withParamsDict:paramsDict];
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
        NSLog(@"conffimes");
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
            NSLog(@"Captured a param %@", [urlFormat substringWithRange: [paramCheckingResult rangeAtIndex:i]]);
            if ( i < [valueCheckingResult numberOfRanges]) {
                [paramValDict setObject:[url substringWithRange: [valueCheckingResult rangeAtIndex:i]] forKey:[urlFormat substringWithRange: [paramCheckingResult rangeAtIndex:i]]];
            }
        }
    }
    return paramValDict;
}

@end