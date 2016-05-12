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
        deepLinkRouter = [DeepLinkRouter alloc]int]
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

- (void) registerForRouting:(UIViewController *) uiViewController forAppLinkKey:(NSString *) alKey withValueFormat:(NSString *) valueFormat {
    NSMutableDictionary *alTypeDictionary = [self.deepLinkRoutingMap objectForKey:alKey];
    if( !alTypeDictionary) {
        alTypeDictionary = [[NSMutableDictionary alloc] init];
        [self.deepLinkRoutingMap setObject:alTypeDictionary forKey:alKey];
    }
        
    [alTypeDictionary setObject:uiViewController forKey:valueFormat];
}


- (UIViewController *) getMatchingViewControllerForUrl:(NSString *) url andALtype:(NSString) alKey {
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

- (Bool) CheckForMatch:(NSString *)url format:(NSString *) urlFormat {
    BOOL isMatch = false;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"(\\{[^}]*\\})" options:0 error:nil];
    NSREgularExpression *valueExpression = [NSREgularExpression regularExpressionWithPattern [regex replaceMatchesInString:urlFormat options:0 range:NSMakeRange(0, [urlFormat length]) withTemplate:@".+"]];
    
    if([valueExpression numberOfMatchesInString:url options:0 range:[url length]] > 0){
        return true;
    }
    
    return false;
    
}

@end