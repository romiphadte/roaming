//
//  ViewController.m
//  roaming
//
//  Created by Ash Bhat on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+MDQRCode.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
