//
//  ViewController.h
//  MUNCH
//
//  Created by student on 10/16/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

- (IBAction)buttonNo:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UISlider *DistanceSlider;
@property (strong, nonatomic) IBOutlet UISlider *PriceSlider;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@end

CLLocationManager *locationManager;
NSString *latitude;
NSString *longitude;