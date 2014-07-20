//
//  BeaconViewController.m
//  roaming
//
//  Created by Romi Phadte on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "BeaconViewController.h"
#import "APLDefaults.h"
@import CoreLocation;

@interface BeaconViewController () <CBPeripheralManagerDelegate,CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *uidlabel;
@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@end

@implementation BeaconViewController
CBPeripheralManager *aperipheralManager = nil;
CLBeaconRegion *aregion = nil;
NSNumber *apower = nil;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.uuid = [APLDefaults sharedDefaults].defaultProximityUUID;
    self.major = [NSNumber numberWithShort:1];
    self.minor = [NSNumber numberWithShort:34];
    
    if(!apower)
    {
        apower = [APLDefaults sharedDefaults].defaultPower;
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!aperipheralManager)
    {
        aperipheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    else
    {
        aperipheralManager.delegate = self;
    }
    
    // Refresh the enabled switch.
    self.enabled = aperipheralManager.isAdvertising;
    self.enabled = true;
    
    self.uidlabel.text=[self.uuid UUIDString];

}

-(void)viewDidAppear:(BOOL)animated{
    [self updateAdvertisedRegion];
    
    [super viewDidAppear:animated];
    
    // Start ranging when the view appears.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}

- (IBAction)update:(id)sender {
    [self updateAdvertisedRegion];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    aperipheralManager.delegate = nil;
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

#pragma mark - Text editing


- (void)updateAdvertisedRegion
{
    
    if(aperipheralManager.state < CBPeripheralManagerStatePoweredOn)
    {
        NSString *title = NSLocalizedString(@"Bluetooth must be enabled", @"");
        NSString *message = NSLocalizedString(@"To configure your device as a beacon", @"");
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title in configuration Save Changes");
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [errorAlert show];
        
        return;
    }
    
	[aperipheralManager stopAdvertising];
    
    if(self.enabled)
    {
        // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
        NSDictionary *peripheralData = nil;
        
        aregion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:[self.major shortValue] minor:[self.minor shortValue] identifier:BeaconIdentifier];
        peripheralData = [aregion peripheralDataWithMeasuredPower:apower];
        
        // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
        if(peripheralData)
        {
            [aperipheralManager startAdvertising:peripheralData];
        }
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Stop ranging when the view goes away.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
    //    [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"yo");
    
    if(beacons.count>0){
        NSLog(@"more than one");
        CLBeacon *b=beacons[0];
        NSLog(@"%@",b.minor);
    }
}

@end