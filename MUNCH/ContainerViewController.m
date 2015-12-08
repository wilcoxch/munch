//
//  ContainerViewController.m
//  MUNCH
//
//  Created by student on 11/10/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#import "ContainerViewController.h"
#import "YPAPISample.h"
#import <Foundation/Foundation.h>



@interface ContainerViewController ()

@end

@implementation ContainerViewController
@synthesize locationManager;
@synthesize currentLocation;
@synthesize stringLat;
@synthesize stringLong;
@synthesize initialCreate;
@synthesize draggableBackground;


- (void)viewDidLoad {
    [super viewDidLoad];
    initialCreate = false;
    [self CurrentLocationIdentifier];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    //------
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    stringLat = [NSString stringWithFormat: @"%lf", currentLocation.coordinate.latitude];
    stringLong = [NSString stringWithFormat: @"%lf", currentLocation.coordinate.longitude];
    if (!initialCreate){
        initialCreate = true;
        draggableBackground = [DraggableViewBackground alloc];
        draggableBackground.currentLat = stringLat;
        draggableBackground.currentLong = stringLong;
        [draggableBackground initWithFrame:self.view.frame];
        [self.view addSubview:draggableBackground];
        [locationManager stopUpdatingLocation];
    }
    else {
        draggableBackground.currentLat = stringLat;
        draggableBackground.currentLong = stringLong;
        [locationManager stopUpdatingLocation];

    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
