//
//  DeepLinkRoutingExampleController.h
//  Roots-SDK-Routing-TestBed
//
//  Created by Sojan P.R. on 5/13/16.
//  Copyright © 2016 Branch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roots.h"

@interface DeepLinkRoutingExampleController : UIViewController <RootsRoutingDelegate>

@property (weak, nonatomic) IBOutlet UILabel *paramsTxt;

@end