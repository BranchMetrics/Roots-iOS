//
//  DeepLinkRoutingExampleControiler.m
//  Roots-SDK-Routing-TestBed
//
//  Created by Sojan P.R. on 5/13/16.
//  Copyright © 2016 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeepLinkRoutingExampleController.h"

@interface DeepLinkRoutingExampleController()

@end

@implementation DeepLinkRoutingExampleController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
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

@end
