//
//  YoCardViewController.h
//  roaming
//
//  Created by Ash Bhat on 7/20/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoCardViewController : UIViewController
@property IBOutlet UIImageView *profileImage;
@property NSDictionary *result;
@property BOOL facebookLogin;
@property IBOutlet UITextField *name;
@property IBOutlet UITextField *company;
@property IBOutlet UITextField *email;
@property IBOutlet UITextField *number;
@property IBOutlet UIView *greyLabelView;
@end
