//
//  DraggableViewBackground.m
//  testing swiping
//
//  Created by Richard Kim on 8/23/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "DraggableViewBackground.h"
#import <Foundation/Foundation.h>
#import "YPAPISample.h"

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
    UIImage* containerImage;
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 466; //%%% height of the draggable card
static const float CARD_WIDTH = 350; //%%% width of the draggable card
// H = 466
// W = 350

@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
//        [self YelpCall];
//        exampleCardLabels = [[NSArray alloc]initWithObjects:@"first",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
        exampleCardLabels = [[NSArray alloc] initWithArray:[self YelpCall]];
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
        [self loadCards];
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{
#warning customize all of this.  These are just place holders to make it look pretty
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors

//    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
//    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
//    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
//    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 515, 59, 59)]; // 485, 59
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 119, 515, 59, 59)]; // 515
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menuButton];
    [self addSubview:messageButton];
    [self addSubview:xButton];
    [self addSubview:checkButton];
}

#warning include own card customization here!
//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
#warning this is where we are populating with API info

    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height)/30, CARD_WIDTH, CARD_HEIGHT)];
    //draggableView.information.text = [exampleCardLabels objectAtIndex:index]; //%%% placeholder for card-specific information
    draggableView.information.text = [exampleCardLabels[index] objectForKey:@"name"];
    NSString *urlString = [exampleCardLabels[index] objectForKey:@"image_url"];
    NSString *urlRating = [exampleCardLabels[index] objectForKey:@"rating_img_url_large"];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    UIImage *rateimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlRating]]];
    draggableView.picture.image = img;
    draggableView.rating.image = rateimg;
    draggableView.delegate = self;
    
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([exampleCardLabels count] > 0) {
        NSInteger numLoadedCardsCap =(([exampleCardLabels count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[exampleCardLabels count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[exampleCardLabels count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }

}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- ( NSMutableArray* )YelpCall{
    NSString *defaultTerm = @"food";
    NSString *defaultll = @"38.3433588,-122.739119";
    NSString *defaultRadius_filter = @"30000";
    NSString *defaultOffset = @"20";
    
    // NSString *defaultLocation = @"Rohnert Park, CA";
    
    //Get the term and location from the command line if there were any, otherwise assign default values.
    NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
    NSString *ll = [[NSUserDefaults standardUserDefaults] valueForKey:@"ll"] ?: defaultll;
    NSString *radius_filter = [[NSUserDefaults standardUserDefaults] valueForKey:@"radius_filter"] ?: defaultRadius_filter;
    NSString *offset = [[NSUserDefaults standardUserDefaults] valueForKey:@"offset"] ?: defaultOffset;
    
    __block NSMutableArray *data;// = [[NSMutableArray alloc] init];
    YPAPISample *APISample = [[YPAPISample alloc] init];
    
    dispatch_group_t requestGroup = dispatch_group_create();
    
    dispatch_group_enter(requestGroup);
    [APISample queryTopBusinessInfoForTerm:term ll:ll radius_filter:radius_filter offset:offset completionHandler:^(NSArray *topBusinessJSON, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
        } else if (topBusinessJSON) {
            NSLog(@"Top business info: \n %@", topBusinessJSON);
            //NSLog(@"More stuff %@\n", [topBusinessJSON objectForKey:@"categories"]);
            //NSLog(@"More stuff %lu\n", (unsigned long)[topBusinessJSON count]);
            //_APIdata = [NSDictionary dictionaryWithDictionary:topBusinessJSON];
            //NSLog(@"Top business info: \n %@", _APIdata);
            data = [[NSMutableArray alloc] initWithArray:topBusinessJSON];
            //            [exampleCardLabels retain];
            //            for (int i = 0; i < [exampleCardLabels count]; ++i) {
            //                NSLog(@"Draggable: %@", [exampleCardLabels[i] objectForKey:@"id"]);
            //            }
        } else {
            NSLog(@"No business was found");
        }
        
        dispatch_group_leave(requestGroup);
    }];
    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    return data;
}

@end
