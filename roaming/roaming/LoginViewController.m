//
//  LoginViewController.m
//  roaming
//
//  Created by Ash Bhat on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "LoginViewController.h"
#import "YOAppDelegate.h"
#import "BeaconViewController.h"
#import "YOTestViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)grantFacebookPermission{
    
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
                 }
                 else{
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Required" message:@"Fess requires Facebook permissions to sign up." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
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

-(IBAction)login:(id)sender{
    [self grantFacebookPermission];
}
- (IBAction)goToBeacon:(id)sender {
    BeaconViewController* new=[[BeaconViewController alloc]init]; //initWithNibName:@"YOTestViewController.h" bundle:nil ];
    [self presentViewController:new animated:YES completion:^{
        NSLog(@"Showing BeaconViewController");
    }];
}

-(void)permissionGranted{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (result) {
            NSLog(@"result = %@",result);
        
        }
        else{
            NSLog(@"error! Some problem occured");
            if (error.code == 400) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Woops" message:@"We failed to authenticate. Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
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

@end
