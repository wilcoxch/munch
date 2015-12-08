//
//  DraggableViewBackground.m
//  testing swiping
//
//  Created by Richard Kim on 8/23/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "DraggableViewBackground.h"
//#import <Foundation/Foundation.h>
#import "YPAPISample.h"



@implementation DraggableViewBackground{
    NSInteger offsetIndex;
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
@synthesize currentLat;
@synthesize currentLong;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
//        [self YelpCall];
//        exampleCardLabels = [[NSArray alloc]initWithObjects:@"first",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
        YPAPISample *dataArray = [[YPAPISample alloc] init];
        NSArray *apiArray = [dataArray YelpCall:@"0" lat:currentLat longi:currentLong];
        exampleCardLabels = [[NSArray alloc] initWithArray:apiArray];
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
    draggableView.review_text.text = [exampleCardLabels[index] objectForKey:@"snippet_text"];
    draggableView.phone_number.text = [exampleCardLabels[index] objectForKey:@"display_phone"];
    NSString *urlString = [exampleCardLabels[index] objectForKey:@"image_url"];
    NSString *urlReviewString = [exampleCardLabels[index] objectForKey:@"snippet_image_url"];
    NSString *urlRating = [exampleCardLabels[index] objectForKey:@"rating_img_url_large"];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    UIImage *ratingimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlReviewString]]];
    UIImage *rateimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlRating]]];
    draggableView.picture.image = img;
    draggableView.review_image.image = ratingimg;
    draggableView.rating.image = rateimg;
    
    double cardLat = [currentLat doubleValue];
    double cardLong = [currentLong doubleValue];
    
    double pinLat = [[[[exampleCardLabels[index] objectForKey:@"location"] objectForKey:@"coordinate" ] objectForKey:@"latitude"] doubleValue];
    double pinLong = [[[[exampleCardLabels[index] objectForKey:@"location"] objectForKey:@"coordinate" ] objectForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D cardCoord = CLLocationCoordinate2DMake(pinLat, pinLong);
    [[draggableView.placemark initWithCoordinate:cardCoord addressDictionary:nil] autorelease];
    [draggableView.mapView addAnnotation:draggableView.placemark];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(cardLat, cardLong);
    MKCoordinateSpan span = MKCoordinateSpanMake( ABS(MAX(cardLat, pinLat) - MIN(cardLat,pinLat)) + .15, ABS(MAX(cardLong, pinLong) - MIN(cardLong,pinLong)) + .15);
    MKCoordinateRegion reg = MKCoordinateRegionMake(center, span);
    [draggableView.mapView setRegion: reg animated: true];
    draggableView.mapView.centerCoordinate = center;

    draggableView.mapView.delegate = self;
    draggableView.delegate = self;
    
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([exampleCardLabels count] > 0) {
        NSInteger numLoadedCardsCap = (([exampleCardLabels count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[exampleCardLabels count]);
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
        if (cardsLoadedIndex >= [exampleCardLabels count]) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:cardsLoadedIndex%[exampleCardLabels count]];
            [allCards addObject:newCard];
        }
        
    }
    
    if ((cardsLoadedIndex) != 0 && (cardsLoadedIndex)%[exampleCardLabels count] == 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            exampleCardLabels = [[[YPAPISample alloc]init] YelpCall:[NSString stringWithFormat:@"%li",(long)cardsLoadedIndex+1] lat:currentLat longi:currentLong];
        });
        //dispatch_release(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    
//    if ([allCards count] > 25 ) {
//        for (int i = 0; i < [allCards count]-10; i++) {
//            [[allCards objectAtIndex:i] dealloc];
//            [allCards removeObjectAtIndex:i];
//            cardsLoadedIndex--;
//        }
//    }

}

#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    NSMutableArray *sendCard = [[NSMutableArray alloc]init];
    [sendCard addObject:[self.exampleCardLabels objectAtIndex:(cardsLoadedIndex-2)%[exampleCardLabels count]]];
    
    
    double pinLat = [[[[sendCard[0] objectForKey:@"location"] objectForKey:@"coordinate" ] objectForKey:@"latitude"] doubleValue];
    double pinLong = [[[[sendCard[0] objectForKey:@"location"] objectForKey:@"coordinate" ] objectForKey:@"longitude"] doubleValue];
    
    [self sendToMap:pinLat lon:pinLong name:[sendCard[0] objectForKey:@"name"] ];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
        if (cardsLoadedIndex >= [exampleCardLabels count]) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:cardsLoadedIndex%[exampleCardLabels count]];
            [allCards addObject:newCard];
        }
        
    }
    
    if ((cardsLoadedIndex) != 0 && (cardsLoadedIndex)%[exampleCardLabels count] == 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            exampleCardLabels = [[[YPAPISample alloc]init] YelpCall:[NSString stringWithFormat:@"%li",(long)cardsLoadedIndex+1] lat:currentLat longi:currentLong];
        });
        
    }
    
//    if ([allCards count] > 25 ) {
//        for (int i = 0; i < [allCards count]-10; i++) {
//            [[allCards objectAtIndex:i] dealloc];
//            [allCards removeObjectAtIndex:i];
//            cardsLoadedIndex--;
//        }
//    }
    
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

- (void)sendToMap:(double)lat lon:(double)lon name:(NSString*)name
{
    double destinationLatitude, destinationLongitude;
    destinationLatitude = lat;// Latitude of destination place.
    destinationLongitude = lon;// Longitude of destination place.
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(destinationLatitude,destinationLongitude);
        
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:name];
        
        
        
        // Set the directions mode to "Driving"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
    
}

@end
