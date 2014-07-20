//
//  BeaconViewController.h
//  roaming
//
//  Created by Romi Phadte on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconViewController.h"
#import "APLDefaults.h"
//#import "APLUUIDViewController.h"

@import CoreLocation;
@import CoreBluetooth;



@interface BeaconViewController : UIViewController <CBPeripheralManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property BOOL enabled;
@property NSUUID *uuid;
@property NSNumber *major;
@property NSNumber *minor;


@property NSNumberFormatter *numberFormatter;

- (void)updateAdvertisedRegion;

@end



