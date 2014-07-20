//
//  YOTestViewController.m
//  roaming
//
//  Created by Romi Phadte on 7/20/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "YOTestViewController.h"
#import "BluetoothManager.h"

@interface YOTestViewController ()

@property BluetoothManager *manager;

@end

@implementation YOTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"hey");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _manager=[[BluetoothManager alloc] initWith:31];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
