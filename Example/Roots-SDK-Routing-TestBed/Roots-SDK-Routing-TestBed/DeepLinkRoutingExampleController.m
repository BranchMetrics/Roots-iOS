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

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {

}

- (void)configureView {
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureControlWithRoutingData:(NSDictionary *) routingParams {
    NSString *paramStr = @"";
    for(NSString *key in routingParams) {
        NSString *value = [routingParams objectForKey:key];
        paramStr = [paramStr stringByAppendingFormat:@"%@ :%@ \n", key, value];
    }
    _paramsLabel.text = paramStr;
}

@end
