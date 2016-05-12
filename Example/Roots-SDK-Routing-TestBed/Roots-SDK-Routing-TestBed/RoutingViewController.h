//
//  DetailViewController.h
//  Roots-SDK-Routing-TestBed
//
//  Created by Sojan P.R. on 5/12/16.
//  Copyright © 2016 Branch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

