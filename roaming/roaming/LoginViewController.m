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
#import "YOBeaconViewController.h"
#import "YOTestViewController.h"
#import "UIImage+animatedGIF.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *loginButtonView;

@end

@implementation LoginViewController

- (void)grantFacebookPermission {
    [self.view setUserInteractionEnabled:NO];
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email"]
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
- (IBAction)example:(id)sender {
    YOTestViewController* new=[[YOTestViewController alloc] initWithNibName:@"YOTestViewController" bundle:nil];
    [self presentViewController:new animated:YES completion:^{
        NSLog(@"Showing test Controller");
    }];
}

- (IBAction)login:(id)sender {
    [self grantFacebookPermission];
}
- (IBAction)goToBeacon:(id)sender {
}

-(IBAction)loginManually:(id)sender{
    YoCardViewController *yoCard = [[YoCardViewController alloc]initWithNibName:@"YoCardViewController" bundle:nil];
    [yoCard setFacebookLogin:NO];
    [self.navigationController pushViewController:yoCard animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    NSString *name = [[PFUser currentUser] objectForKey:@"name"];
    NSString *username = [[PFUser currentUser] objectForKey:@"username"];
    if (name) {
        YOBeaconViewController *beaconVC = [[YOBeaconViewController alloc] initWithNibName:@"YOBeaconViewController" bundle:[NSBundle mainBundle] username:username];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:beaconVC];
        [self presentViewController:nav animated:YES completion:nil];
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
    [self loadBackground];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"EnteredInfo" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        YOBeaconViewController *beaconVC = [[YOBeaconViewController alloc] initWithNibName:@"YOBeaconViewController" bundle:[NSBundle mainBundle] username:note.object];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:beaconVC];
        [self presentViewController:nav animated:YES completion:nil];
    }];
}
- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(void)loadBackground{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"newyork" withExtension:@"gif"];
    self.backgroundImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
}

@end
