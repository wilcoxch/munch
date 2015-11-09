//
//  ViewController.m
//  MUNCH
//
//  Created by student on 10/16/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#import "ViewController.h"
#import "YPAPISample.h"
#import <Foundation/Foundation.h>


@interface ViewController ()

@property (strong, nonatomic) NSDictionary *APIdata;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self YelpCall];
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
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_APIdata count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    NSLog(@"Table view stuff: %@", [_APIdata objectForKey:@"name"]);
    cell.textLabel.text = [_APIdata objectForKey:@"name"];

    
    
    return cell;
}

- (void)YelpCall{
        NSString *defaultTerm = @"pho";
        NSString *defaultLocation = @"Rohnert Park, CA";
        
        //Get the term and location from the command line if there were any, otherwise assign default values.
        NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
        NSString *location = [[NSUserDefaults standardUserDefaults] valueForKey:@"location"] ?: defaultLocation;
        
        YPAPISample *APISample = [[YPAPISample alloc] init];
        
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
        [APISample queryTopBusinessInfoForTerm:term location:location completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
            
            if (error) {
                NSLog(@"An error happened during the request: %@", error);
            } else if (topBusinessJSON) {
                NSLog(@"Top business info: \n %@", topBusinessJSON);
                //NSLog(@"More stuff %@\n", [topBusinessJSON objectForKey:@"categories"]);
                //NSLog(@"More stuff %lu\n", (unsigned long)[topBusinessJSON count]);
                //_APIdata = [NSDictionary dictionaryWithDictionary:topBusinessJSON];
                //NSLog(@"Top business info: \n %@", _APIdata);
                _APIdata = topBusinessJSON;
                [_APIdata retain];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                NSLog(@"No business was found");
            }
            
            dispatch_group_leave(requestGroup);
        }];
        
        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
}

@end
