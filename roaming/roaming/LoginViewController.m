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

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *loggedInUserView;
@property (weak, nonatomic) IBOutlet UIImageView *loggedInUserProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *loggedInUserName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.loggedInUserProfilePicture.layer.cornerRadius = CGRectGetHeight(self.loggedInUserProfilePicture.frame)/2.0;
    self.loggedInUserProfilePicture.layer.masksToBounds = YES;
}

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

- (void)permissionGranted {
    [UIView animateWithDuration:0.2 animations:^{
        self.loginButton.alpha = 0;
        self.loggedInUserView.alpha = 1;
    } completion:^(BOOL finished) {

    }];
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (result) {
            NSString *fbID = result[@"id"];
            NSString *profilePictureURLString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", fbID];
            self.loggedInUserName.text = result[@"name"];
            [self.imageLoadingIndicator startAnimating];
            [self.loggedInUserProfilePicture sd_setImageWithURL:[NSURL URLWithString:profilePictureURLString]
                                               placeholderImage:nil options:SDWebImageCacheMemoryOnly
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           if (receivedSize == expectedSize) {
                                                               [self.imageLoadingIndicator stopAnimating];
                                                           }
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                           [UIView animateWithDuration:0.2 animations:^{
                                                               self.loggedInUserProfilePicture.alpha = 1;
                                                               self.imageLoadingIndicator.alpha = 0;
                                                           } completion:^(BOOL finished) {
                                                               YOUser *user = [YOUser userWithPFUser:[PFUser currentUser]];
                                                               if (!user.name) {
                                                                   YoCardViewController *yoCard = [[YoCardViewController alloc]initWithNibName:@"YoCardViewController" bundle:nil];
                                                                   [yoCard setResult:result];
                                                                   [self.navigationController presentViewController:yoCard animated:YES completion:nil];
                                                               }
                                                               else{
                                                                   cardTableViewController *cardVC = [[cardTableViewController alloc]initWithNibName:@"cardTableViewController" bundle:nil];
                                                                   [self.navigationController presentViewController:cardVC animated:YES completion:nil];
                                                               }

                                                               [self.imageLoadingIndicator stopAnimating];
                                                           }];
                                                       }];
        } else {
            NSLog(@"error! Some problem occured: %@", [error description]);
            if (error.code == 400) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Woops" message:@"We failed to authenticate. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

@end
