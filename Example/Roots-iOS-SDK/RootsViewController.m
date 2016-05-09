//
//  RootsViewController.m
//  Roots-iOS-SDK
//
//  Created by sojan on 05/02/2016.
//  Copyright (c) 2016 sojan. All rights reserved.
//

#import "RootsViewController.h"
#import "Roots.h"


@interface RootsViewController ()

@end

@implementation RootsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)navigateBtn:(id)sender {
    [self.navUrlTxt text];
    
    NSString *url = @"https://soundcloud.com/tacobell";
    NSString * userAgentStr = @"Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53";
   [Roots connect:url userAgent:userAgentStr andWithDelegate:self];
    
}

- (void)applicationLaunched:(NSString *)appName appStoreID:(NSString *)appStoreID {
    NSLog(@"Roots_AppLinker: applicationLaunched %@  %@", appName, appStoreID);
}

- (void)fallbackUrlOpened:(NSString *)fallbackUrl {
     NSLog(@"Roots_AppLinker: fallbackUrlOpened %@", fallbackUrl);
}

- (void)appStoreOpened:(NSString *)appName appStoreID:(NSString *)appStoreID {
    NSLog(@"Roots_AppLinker: appStoreOpened %@  %@", appName, appStoreID);
}




@end
