//
//  YOCurrentUserManager.m
//  roaming
//
//  Created by Neeraj Baid on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <Parse/Parse.h>

#import "SFHFKeychainUtils.h"
#import "YOCurrentUserManager.h"
#import "YOUser.h"

@implementation YOCurrentUserManager

+ (instancetype)sharedCurrentUserManager {
    __strong static YOCurrentUserManager *sharedObject = nil;
	static dispatch_once_t pred;
	dispatch_once(&pred, ^{
		sharedObject = [[self alloc] init];
	});
	return sharedObject;
}

- (void)login {
    NSString *login = [self loginID];
    if (!login) {
        NSString *userID = [self buildUserID];
        PFUser *user = [PFUser user];
        user.username = userID;
        user.password = userID;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SFHFKeychainUtils storeUsername:@"username" andPassword:userID
                                  forServiceName:@"username" updateExisting:YES error:nil];
                [PFUser logInWithUsernameInBackground:userID password:userID block:^(PFUser *user, NSError *error) {
                    if (user) {
                        [[PFInstallation currentInstallation] setValue:user forKey:@"user"];
                        [[PFInstallation currentInstallation] saveInBackground];
                    }
                    NSLog(@"register: %@", userID);
                }];
            }
        }];
    } else {
        [PFUser logInWithUsernameInBackground:login password:login block:^(PFUser *user, NSError *error) {
            if (user) {
                [[PFInstallation currentInstallation] setValue:user forKey:@"user"];
                [[PFInstallation currentInstallation] saveInBackground];
            }
            NSLog(@"login: %@", login);
        }];
    }
}

- (NSString *)buildUserID {
    return [[NSUUID UUID] UUIDString];
}

- (NSString *)loginID {
    return [SFHFKeychainUtils getPasswordForUsername:@"username"
                                      andServiceName:@"username" error:nil];
}

- (void)saveDataToParseWithYOUser:(YOUser *)user {
    PFFile *imageFile = [PFFile fileWithData:UIImageJPEGRepresentation(user.profilePicture, 0.5)];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFUser *currentUser = [PFUser currentUser];
        [currentUser setObject:user.name forKey:@"name"];
        [currentUser setObject:user.titleAndCompany forKey:@"title_and_company"];
        [currentUser setObject:user.email forKey:@"email"];
        [currentUser setObject:user.phoneNumber forKey:@"phone_number"];
        [currentUser setObject:imageFile forKey:@"profile_picture"];
        [currentUser saveInBackground];
    }];
}

@end