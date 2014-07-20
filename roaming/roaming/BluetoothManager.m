//
//  BeaconViewController.m
//  roaming
//
//  Created by Romi Phadte on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import <Parse/Parse.h>

#import "BluetoothManager.h"
@import CoreLocation;

@interface BluetoothManager() <CBPeripheralManagerDelegate,CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@end

@implementation BluetoothManager

CBPeripheralManager *peripheralManager = nil;
CLBeaconRegion *region = nil;
NSNumber *power = nil;

int lastID=-1;


- (id)initWith:(int)value
{
    NSLog(@"yee");
    if (self) {
        self.uuid = [APLDefaults sharedDefaults].defaultProximityUUID;
        self.major = [NSNumber numberWithShort:1];
        self.minor = [NSNumber numberWithShort:value];
        
        if(!power)
        {
            power = [APLDefaults sharedDefaults].defaultPower;
        }
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        self.beacons = [[NSMutableDictionary alloc] init];
        
        // This location manager will be used to demonstrate how to range beacons.
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        self.rangedRegions = [[NSMutableDictionary alloc] init];
        
        for (NSUUID *uuid in [APLDefaults sharedDefaults].supportedProximityUUIDs)
        {
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
            self.rangedRegions[region] = [NSArray array];
        }
    }
    return self;
}


- (void) whenWillAppear
{
    if (!peripheralManager)
    {
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    else
    {
        peripheralManager.delegate = self;
    }
    
    // Refresh the enabled switch.
    self.enabled = peripheralManager.isAdvertising;
    self.enabled = true;
    
    NSLog([self.uuid UUIDString]);
    
}

-(void)whenDidAppear{
    [self updateAdvertisedRegion];
    
    // Start ranging when the view appears.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}

-(void)whenWillDisappear
{
    peripheralManager.delegate = nil;
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"yo updated state");
}

#pragma mark - Text editing

- (void)updateAdvertisedRegion
{
    if(peripheralManager.state < CBPeripheralManagerStatePoweredOn)
    {
        NSString *title = NSLocalizedString(@"Bluetooth must be enabled", @"");
        NSString *message = NSLocalizedString(@"To configure your device as a beacon", @"");
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title in configuration Save Changes");
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [errorAlert show];
        
        return;
    }
    
	[peripheralManager stopAdvertising];
    
    if(self.enabled)
    {
        // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
        NSDictionary *peripheralData = nil;
        
        region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:[self.major shortValue] minor:[self.minor shortValue] identifier:BeaconIdentifier];
        peripheralData = [region peripheralDataWithMeasuredPower:power];
        
        // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
        if(peripheralData)
        {
            [peripheralManager startAdvertising:peripheralData];
        }
    }
}


- (void)whenDidDisappear
{
    // Stop ranging when the view goes away.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
            [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSString *closest=@"";
    CLLocationAccuracy distance=999999999;
    
    for (CLBeacon* aBeacon in beacons){
        NSLog(@"Can see these ids");
        NSLog(@"%@",aBeacon.minor);
        NSLog(@"Acc: %.2fm",aBeacon.accuracy);
        if(aBeacon.accuracy<distance){
            closest=[aBeacon.minor stringValue];
            distance=aBeacon.accuracy;
        }
    }
    
    NSLog(@"Closest ID is %@",closest);
    NSLog(@"Shortest distance is %.2fm", distance );
    PFPush *push = [PFPush push];
    [push setChannel:[NSString stringWithFormat:@"glass%@", [[PFUser currentUser] objectForKey:@"username"]]];
    if(closest.length>0){
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:closest];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (((PFFile *)[object objectForKey:@"profile_picture"]).url){
                [push setData:@{@"action": @"com.github.barcodeeye.UPDATE_STATUS",
                                @"user":[object objectForKey:@"username"],
                                @"name":[object objectForKey:@"name"],
                                @"email":[object objectForKey:@"email_address"],
                                @"phone_number":[object objectForKey:@"phone_number"],
                                @"profile_picture_url":((PFFile *)[object objectForKey:@"profile_picture"]).url}];
            }
            else{
               [push setData:@{@"action": @"com.github.barcodeeye.UPDATE_STATUS",
                               @"user":[object objectForKey:@"username"],
                                @"name":[object objectForKey:@"name"],
                                @"email":[object objectForKey:@"email_address"],
                               @"phone_number":[object objectForKey:@"phone_number"]}];
            }
            [push sendPushInBackground];
        }];
    }
}

@end
