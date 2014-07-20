//
//  LoginViewController.m
//  roaming
//
//  Created by Ash Bhat on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "YOAppDelegate.h"
#import "YOUser.h"
#import "UIImage+MDQRCode.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (weak, nonatomic) IBOutlet UIView *loginButtonView;

@end

@implementation LoginViewController

- (void)grantFacebookPermission {
    [self.view setUserInteractionEnabled:NO];
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self.view setUserInteractionEnabled:YES];
         if (!error) {
             YOAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             [appDelegate sessionStateChanged:session state:state error:error];
             [self permissionGranted];
         } else {
             [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                 if (!error) {
                     YOAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                     [appDelegate sessionStateChanged:session state:state error:error];
                     [self permissionGranted];
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Required" message:@"Roaming requires Facebook permissions to sign up." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                     [alert show];
                     alert = nil;
                 }
             }];
         }
     }];
}

- (IBAction)login:(id)sender {
    [self grantFacebookPermission];
}

-(IBAction)loginManually:(id)sender{
    YoCardViewController *yoCard = [[YoCardViewController alloc]initWithNibName:@"YoCardViewController" bundle:nil];
    [yoCard setFacebookLogin:NO];
    [self.navigationController presentViewController:yoCard animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    NSString *name = [[PFUser currentUser] objectForKey:@"name"];
    NSString *username = [[PFUser currentUser] objectForKey:@"username"];
    if (name) {
        self.qrCodeImageView.image = [UIImage mdQRCodeForString:username size:60];
        self.loginButtonView.alpha = 0;
        self.qrCodeView.alpha = 1;
    }
}

- (void)permissionGranted {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (result) {
            YoCardViewController *yoCard = [[YoCardViewController alloc] initWithNibName:@"YoCardViewController"
                                                                                  bundle:nil];
            [yoCard setResult:result];
            [yoCard setFacebookLogin:YES];
            [self.navigationController pushViewController:yoCard animated:YES];
        } else {
            NSLog(@"error! Some problem occured: %@", [error description]);
            if (error.code == 400) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Woops" message:@"We failed to authenticate. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"EnteredInfo" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self viewWillAppear:YES];
    }];
}

@end
