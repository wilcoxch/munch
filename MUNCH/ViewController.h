//
//  ViewController.h
//  MUNCH
//
//  Created by student on 10/16/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController //<CLLocationManagerDelegate>

//-(double)getDistance;

//- (IBAction)buttonNo:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UISlider *DistanceSlider;
@property (strong, nonatomic) IBOutlet UITextField *DistanceLabel;
@property (strong, nonatomic) IBOutlet UISlider *PriceSlider;
@property (strong, nonatomic) IBOutlet UITextField *PriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;


@end
double distance;

//CLLocationManager *locationManager;
NSString *latitude;
NSString *longitude;