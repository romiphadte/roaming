//
//  cardTableViewController.m
//  roaming
//
//  Created by Ash Bhat on 7/20/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "cardTableViewController.h"
#import "UIImage+MDQRCode.h"
#import "YOUser.h"
@interface cardTableViewController ()

@end

@implementation cardTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(IBAction)launchQrCode:(id)sender{
    self.qrcode.image = [UIImage mdQRCodeForString:[NSString stringWithFormat:@"%i",[YOUser userWithPFUser:[PFUser currentUser]].roamingId] size:60];
}
@end
