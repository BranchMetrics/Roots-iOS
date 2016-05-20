//
//  DeepLinkRoutingExampleControiler.m
//  Roots-SDK-Routing-TestBed
//
//  Created by Sojan P.R. on 5/13/16.
//  Copyright © 2016 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeepLinkRoutingExampleController.h"

@implementation DeepLinkRoutingExampleController

- (void) configureControlWithRoutingData:(NSDictionary *) routingParams {
    NSString *paramStr = @"";
    for(NSString *key in routingParams) {
        NSString *value = [routingParams objectForKey:key];
        paramStr = [paramStr stringByAppendingFormat:@"%@ : %@\n", key, value];
    }
    _paramsTxt.text = paramStr;
}

@end
