//
//  RootsViewController.h
//  Roots-iOS-SDK
//
//  Created by sojan on 05/02/2016.
//  Copyright (c) 2016 sojan. All rights reserved.
//

@import UIKit;
#import "Roots.h"

@interface RootsViewController : UIViewController <RootsEventsDelegate> {
    NSMutableData *_responseData;
}
@property (weak, nonatomic) IBOutlet UITextField *navUrlTxt;
@property (weak, nonatomic) IBOutlet UISwitch *AppStoreSwitch;

@end
