//
//  ViewController.h
//  MUNCH
//
//  Created by student on 10/16/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <
    UITableViewDataSource, UITableViewDelegate>

- (IBAction)buttonNo:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISlider *DistanceSlider;
@property (strong, nonatomic) IBOutlet UISlider *PriceSlider;


@end

