//
//  YOCurrentUserManager.h
//  roaming
//
//  Created by Neeraj Baid on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YOCurrentUserManager : NSObject

+ (instancetype)sharedCurrentUserManager;

- (void)login;

@end
