//
//  YOBeaconViewController.m
//  roaming
//
//  Created by Romi Phadte on 7/20/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "YOBeaconViewController.h"
#import "UIImage+MDQRCode.h"
#import "BluetoothManager.h"

@interface YOBeaconViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (strong, nonatomic) NSString *username;
@property BluetoothManager *manager;

@end

@implementation YOBeaconViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil username:(NSString *)username
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.username = username;
        _manager=[[BluetoothManager alloc] initWith:[self.username intValue]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.qrCodeImageView.image = [UIImage mdQRCodeForString:self.username size:60];
    self.qrCodeView.alpha = 1;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_manager whenWillAppear];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [_manager whenDidAppear];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewDidAppear:YES];
    [_manager whenWillDisappear];
}
- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [_manager whenDidDisappear];
}

@end
