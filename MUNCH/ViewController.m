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

//@property (strong, nonatomic) NSDictionary *APIdata;

@end

@implementation ViewController {

    NSArray *APIdata;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self YelpCall];
    NSLog(@"APIdata: %lu", (unsigned long)[APIdata count]);

    
//    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:draggableBackground];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonNo:(UIButton *)sender {
    NSLog(@"You clicked the no button");
}
- (IBAction)Info:(UIButton *)sender {
    NSLog(@"You want more info");
}


- (IBAction)Settings:(UIButton *)sender {
    NSLog(@"You clicked Settings");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [APIdata release];
    // Dispose of any resources that can be recreated.
}


- (void)YelpCall{
        NSString *defaultTerm = @"mexican";
        NSString *defaultll = @"38.3433588,-122.739119";
        NSString *defaultRadius_filter = @"30000";
        NSString *defaultOffset = @"0";
    
       // NSString *defaultLocation = @"Rohnert Park, CA";
        
        //Get the term and location from the command line if there were any, otherwise assign default values.
        NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
        NSString *ll = [[NSUserDefaults standardUserDefaults] valueForKey:@"ll"] ?: defaultll;
        NSString *radius_filter = [[NSUserDefaults standardUserDefaults] valueForKey:@"radius_filter"] ?: defaultRadius_filter;
        NSString *offset = [[NSUserDefaults standardUserDefaults] valueForKey:@"offset"] ?: defaultOffset;

    
        YPAPISample *APISample = [[YPAPISample alloc] init];
        
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
    [APISample queryTopBusinessInfoForTerm:term ll:ll radius_filter:radius_filter offset:offset completionHandler:^(NSArray *topBusinessJSON, NSError *error) {
            
            if (error) {
                NSLog(@"An error happened during the request: %@", error);
            } else if (topBusinessJSON) {
                //NSLog(@"Top business info: \n %@", topBusinessJSON);
                //NSLog(@"More stuff %@\n", [topBusinessJSON objectForKey:@"categories"]);
                //NSLog(@"More stuff %lu\n", (unsigned long)[topBusinessJSON count]);
                //_APIdata = [NSDictionary dictionaryWithDictionary:topBusinessJSON];
                //NSLog(@"Top business info: \n %@", _APIdata);
                APIdata = topBusinessJSON;
                [APIdata retain];
                for (int i = 0; i < [APIdata count]; ++i) {
                    NSLog(@"%@", [APIdata[i] objectForKey:@"id"]);
                }
            } else {
                NSLog(@"No business was found");
            }
            
            dispatch_group_leave(requestGroup);
        }];
        
        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
}



@end
