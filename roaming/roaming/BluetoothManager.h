//
//  BluetoothManager.h
//  roaming
//
//  Created by Romi Phadte on 7/20/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APLDefaults.h"

@import CoreLocation;
@import CoreBluetooth;


@interface BluetoothManager: NSObject <CBPeripheralManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property NSUUID *uuid;
@property NSNumber *major;
@property BOOL enabled;
@property NSNumber *minor;

@property NSNumberFormatter *numberFormatter;

- (id)initWith:(int)value;
- (void)updateAdvertisedRegion;
- (void)whenWillAppear;
- (void)whenDidAppear;
- (void)whenWillDisappear;
- (void)whenDidDisappear;


@end

