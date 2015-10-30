//
//  ViewController.m
//  MUNCH
//
//  Created by student on 10/16/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
