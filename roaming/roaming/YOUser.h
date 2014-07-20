//
//  YOUser.h
//  roaming
//
//  Created by Neeraj Baid on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface YOUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *titleAndCompany;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
// If uploading user
@property (strong, nonatomic) UIImage *profilePicture;
// If retrieving user
@property (strong, nonatomic) PFFile *imageFile;

+ (YOUser *)userWithPFUser:(PFUser *)user;

@end
