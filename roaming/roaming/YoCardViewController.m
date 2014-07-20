//
//  YoCardViewController.m
//  roaming
//
//  Created by Ash Bhat on 7/20/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "YoCardViewController.h"
#import "YOUser.h"
#import "YOCurrentUserManager.h"
#import "cardTableViewController.h"
@interface YoCardViewController ()<UITextFieldDelegate>{
    
}

@end

@implementation YoCardViewController

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
    [self.profileImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small&width=640&height=640",self.result[@"id"]]]]]];
    YOUser *currentUsr = [YOUser userWithPFUser:[PFUser currentUser]];
    if (currentUsr.name) [self.name setText:currentUsr.name];
    if (currentUsr.titleAndCompany) [self.company setText:currentUsr.titleAndCompany];
    if (currentUsr.email) [self.email setText:currentUsr.email];
    if (currentUsr.phoneNumber) [self.number setText:currentUsr.phoneNumber];
    [self.name setDelegate:self];
    [self.company setDelegate:self];
    [self.email setDelegate:self];
    [self.number setDelegate:self];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:.5 animations:^{
        [self.greyLabelView setFrame:CGRectMake(0, 0, 320, 400)];
    }];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [UIView animateWithDuration:.5 animations:^{
        [self.greyLabelView setFrame:CGRectMake(0, 318, 320, 191)];
    }];
    return YES;
}
-(IBAction)saveButtonPressed:(id)sender{
    YOUser *currentUsr = [YOUser userWithPFUser:[PFUser currentUser]];
    currentUsr.name = self.name.text;
    currentUsr.fbid = self.result[@"id"];
    currentUsr.titleAndCompany = self.company.text;
    currentUsr.email = self.email.text;
    currentUsr.phoneNumber = self.number.text;
    if (!currentUsr.roamingId){
        PFQuery *userCount =[PFQuery queryWithClassName:@"User"];
        currentUsr.roamingId = [userCount countObjects]+1;
    }
    [[YOCurrentUserManager sharedCurrentUserManager]saveDataToParseWithYOUser:currentUsr];
    cardTableViewController *cardVC = [[cardTableViewController alloc]initWithNibName:@"cardTableViewController" bundle:nil];
    [self presentViewController:cardVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
