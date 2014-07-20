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

@interface YoCardViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    
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
    if (self.facebookLogin){
        [self.profileImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small&width=640&height=640",self.result[@"id"]]]]]];
        [self.email setText:self.result[@"email_address"]];
        [self.name setText:self.result[@"name"]];
    }
    YOUser *currentUsr = [YOUser userWithPFUser:[PFUser currentUser]];
    if (currentUsr.name) [self.name setText:currentUsr.name];
    if (currentUsr.titleAndCompany) [self.company setText:currentUsr.titleAndCompany];
    if (currentUsr.email) [self.email setText:currentUsr.email];
    if (currentUsr.phoneNumber) [self.number setText:currentUsr.phoneNumber];
    [self.name setDelegate:self];
    [self.company setDelegate:self];
    [self.email setDelegate:self];
    [self.number setDelegate:self];
    [self.navigationController setNavigationBarHidden:NO];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(IBAction)choosePictureSource:(id)sender{
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Choose Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Library",@"Camera", nil];
    
    [actionSheet showInView:self.view];
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:.5 animations:^{
        [self.greyLabelView setFrame:CGRectMake(0, 0, 320, 640)];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self selectPhoto];
    } else if (buttonIndex == 1) {
        [self takePhoto];
    }
    
}

-(IBAction)saveButtonPressed:(id)sender{
    YOUser *currentUsr = [YOUser userWithPFUser:[PFUser currentUser]];
    if (self.name.text.length > 0 && self.company.text.length > 0 && self.number.text.length > 0 && self.email.text.length > 0) {
        currentUsr.name = self.name.text;
        currentUsr.fbid = self.result[@"id"];
        currentUsr.titleAndCompany = self.company.text;
        currentUsr.email = self.email.text;
        currentUsr.profilePicture = self.profileImage.image;
        currentUsr.phoneNumber = self.number.text;
        [[YOCurrentUserManager sharedCurrentUserManager] saveDataToParseWithYOUser:currentUsr];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fill out information" message:@"The information you've provided is incomplete." delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
