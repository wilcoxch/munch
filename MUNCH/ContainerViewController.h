//
//  ContainerViewController.h
//  MUNCH
//
//  Created by student on 11/10/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "DraggableViewBackground.h"

@interface ContainerViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSString *stringLat;
@property (nonatomic, retain) NSString *stringLong;
@property bool initialCreate;
@property (nonatomic, strong) DraggableViewBackground *draggableBackground;

@end
