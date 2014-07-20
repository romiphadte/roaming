//
//  YOUser.m
//  roaming
//
//  Created by Neeraj Baid on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <Parse/Parse.h>
#import "YOUser.h"

@implementation YOUser

+ (YOUser *)userWithPFUser:(PFUser *)user {
    YOUser *yoUser = [[self alloc] init];
    yoUser.name = [user objectForKey:@"name"];
    yoUser.fbid = [user objectForKey:@"fbid"];
    yoUser.titleAndCompany = [user objectForKey:@"title_and_company"];
    yoUser.email = [user objectForKey:@"email_address"];
    yoUser.phoneNumber = [user objectForKey:@"phone_number"];
    PFFile *imageFile = [user objectForKey:@"profile_picture"];
    yoUser.imageFile = imageFile;
    return yoUser;
}

@end
