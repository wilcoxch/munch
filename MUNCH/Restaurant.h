//
//  Restaurant.h
//  MUNCH
//
//  Created by student on 10/22/15.
//  Copyright (c) 2015 Greybeards. All rights reserved.
//

#ifndef MUNCH_Restaurant_h
#define MUNCH_Restaurant_h
#import <UIKit/UIKit.h>


@interface Restaurant : NSObject{
    
}


@property (weak,nonatomic) NSString *Name;
@property double *Distance;
@property NSInteger *Rating;
@property (weak,nonatomic) NSString *Description;
@property (weak,nonatomic) NSString *Address;
@property (weak,nonatomic) NSString *ImgUrl;

@end

#endif
