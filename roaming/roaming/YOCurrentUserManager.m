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
        [self buildUserID];
    } else {
        [PFUser logInWithUsernameInBackground:login password:login block:^(PFUser *user, NSError *error) {
            NSLog(@"login: %@", login);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedIn" object:self userInfo:nil];
        }];
    }
}

- (void)buildUserID {
    PFQuery *query = [PFUser query];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        PFUser *user = [PFUser user];
        NSString *userID = [NSString stringWithFormat:@"%i", number + 1];
        user.username = userID;
        user.password = userID;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SFHFKeychainUtils storeUsername:@"username" andPassword:userID
                                  forServiceName:@"username" updateExisting:YES error:nil];
                [PFUser logInWithUsernameInBackground:userID password:userID block:^(PFUser *user, NSError *error) {
                    NSLog(@"register: %@", userID);
                }];
            }
        }];
    }];
}

- (NSString *)loginID {
    return [SFHFKeychainUtils getPasswordForUsername:@"username"
                                      andServiceName:@"username" error:nil];
}

- (void)saveDataToParseWithYOUser:(YOUser *)user {
    if (user.profilePicture) {
        PFFile *imageFile = [PFFile fileWithData:UIImageJPEGRepresentation(user.profilePicture, 0.5)];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self saveUserWithYOUser:user imageFile:imageFile];
        }];
    } else {
        [self saveUserWithYOUser:user imageFile:nil];
    }
}

- (void)saveUserWithYOUser:(YOUser *)user imageFile:(PFFile *)imageFile {
    PFUser *currentUser = [PFUser currentUser];
    if (user.name) {
        [currentUser setObject:user.name forKey:@"name"];
    }
    if (user.fbid) {
        [currentUser setObject:user.fbid forKey:@"fbid"];
    }
    if (user.titleAndCompany) {
        [currentUser setObject:user.titleAndCompany forKey:@"title_and_company"];
    }
    if (user.email) {
        [currentUser setObject:user.email forKey:@"email_address"];
    }
    if (user.phoneNumber) {
        [currentUser setObject:user.phoneNumber forKey:@"phone_number"];
    }
    if (imageFile) {
        [currentUser setObject:imageFile forKey:@"profile_picture"];
    }
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EnteredInfo" object:currentUser[@"username"]];
    }];
}

- (void)getYOUserWithID:(NSString *)userID completion:(void (^)(YOUser *user))completion {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString:userID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        completion([YOUser userWithPFUser:(PFUser *)object]);
    }];
}

@end