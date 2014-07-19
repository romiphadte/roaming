//
//  ViewController.m
//  roaming
//
//  Created by Ash Bhat on 7/19/14.
//  Copyright (c) 2014 Romi Phadte. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Firebase* myRootRef = [[Firebase alloc] initWithUrl:@"http://greylocku.firebaseIO.com"];
    
    // Write data to Firebase
    [myRootRef setValue:@"set-value-here"];
    
    // Read data and react to changes
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@ -> %@", snapshot.name, snapshot.value);
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
