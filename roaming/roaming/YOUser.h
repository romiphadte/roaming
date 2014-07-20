//
//  YOUser.h
//  roaming
//
//  Created by Neeraj Baid on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YOUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *titleAndCompany;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) UIImage *profilePicture;

@end
