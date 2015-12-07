//
//  ViewController.m
//  MUNCH
//
//  Created by student on 10/16/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import "ViewController.h"
#import "YPAPISample.h"
#import "DraggableViewBackground.h"



@interface ViewController ()


@end

@implementation ViewController {
    double distance;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    distance = 1609.34;
}


//- (IBAction)Settings:(UIButton *)sender {
//    NSLog(@"You clicked Settings");
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)distanceChange:(id)sender {
    // NSLog(@"%@", [NSString stringWithFormat:@"%f", self.DistanceSlider.value]);
    distance = (self.DistanceSlider.value)*1609.34;
    NSLog(@"%f", distance);
}

- (double)getDistance{
     NSLog(@"%f", distance);
    return distance;
}


@end
