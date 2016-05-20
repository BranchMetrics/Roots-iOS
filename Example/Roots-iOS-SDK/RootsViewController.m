//
//  RootsViewController.m
//  Roots-SDK-TestBed
//
//  Created by sojan on 05/02/2016.
//  Copyright (c) 2016 sojan. All rights reserved.
//

#import "RootsViewController.h"
#import "Roots.h"
#import "RootsDeepLinkRouter.h"


@implementation RootsViewController

- (IBAction)navigateBtn:(id)sender {
    if (_navUrlTxt.text && _navUrlTxt.text.length > 0) {
        RootsLinkOptions *options = [[RootsLinkOptions alloc] init];
        [options setAlwaysFallbackToAppStore:self.AppStoreSwitch.isOn];
        [Roots connect:_navUrlTxt.text withDelegate:self andWithOptions:options];
    }
    else {
        NSString *debugAppLinkMetadataJson = @"[{\"property\":\"al:ios:app_name\",\"content\":\"RootsTestBed\"},{\"property\":\"al:ios:app_store_id\",\"content\":\"336353151\"},{\"property\":\"al:ios:url\",\"content\":\"myscheme://mypath/user/my_user_id1234/my_username\"},{\"property\":\"al:web:should_fallback\",\"content\":\"false\"}]";
        
        [Roots debugConnect:@"https://my_awesome_site.com/user/my_user_id123456"
                applinkMetadata:debugAppLinkMetadataJson
                andCallback:self];
    }
}

- (void)applicationLaunched:(NSString *)appName appStoreID:(NSString *)appStoreID {
    NSLog(@"Roots App Linker: applicationLaunched %@  %@", appName, appStoreID);
}

- (void)fallbackUrlOpened:(NSString *)fallbackUrl {
    NSLog(@"Roots App Linker: fallbackUrlOpened %@", fallbackUrl);
}

- (void)appStoreOpened:(NSString *)appName appStoreID:(NSString *)appStoreID {
    NSLog(@"Roots App Linker: appStoreOpened %@  %@", appName, appStoreID);
}

- (void) rootsError:(enum RootsError)error {
    if (error == invalid_url) {
        NSLog(@"Roots App Linker: rootsError invalid url");
    }
    else {
        NSLog(@"Roots App Linker: rootsError %d", error);
    }
}



@end
