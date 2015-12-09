//
//  DraggableView.m
//  testing swiping
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle


#import "DraggableView.h"

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
    MKMapView *mapView;
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

//delegate is instance of ViewController
@synthesize delegate;
@synthesize picture;
@synthesize rating;
@synthesize panGestureRecognizer;
@synthesize information;
@synthesize review_text;
@synthesize phone_number;
@synthesize overlayView;
@synthesize review_image;
@synthesize mapView;
@synthesize latitude;
@synthesize longitude;
@synthesize phoneButton;
@synthesize callPhone;

//@synthesize callPhone;
//@synthesize locationManager;
//@synthesize mapLat;
//@synthesize mapLong;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
#warning placeholder stuff, replace with card-specific information {
        information = [[UILabel alloc]initWithFrame:CGRectMake(5, 120, self.frame.size.width -10, 50)];
        information.text = @"no info given";
        [information setTextAlignment:NSTextAlignmentCenter];
        information.textColor = [UIColor blackColor];
        [information setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:19]]; information.text=@"sagar";

        review_text = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 500)];
        review_text.text = @"no info given";
        [review_text setTextAlignment:NSTextAlignmentCenter];
        [review_text setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:16]]; information.text=@"sagar";
        review_text.textColor = [UIColor blackColor];

        picture = [[UIImageView alloc] initWithFrame:CGRectMake(0  , 0, 100, 100)];
        [picture setCenter: CGPointMake(self.frame.size.width/6, self.frame.size.height/8)];
        picture.tintColor = [UIColor grayColor];
        rating = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 200, 40)];
        [rating setCenter: CGPointMake(self.frame.size.width/1.5, 25)];
        review_image = [[UIImageView alloc] initWithFrame:CGRectMake(0  , self.frame.size.height, 80, 80)];
        [review_image setCenter: CGPointMake(self.frame.size.width/6, self.frame.size.height/8)];
        review_image.tintColor = [UIColor grayColor];
        double mapLati = [latitude doubleValue];
        double mapLongi = [longitude doubleValue];
        
        UIButton *callPress = [UIButton buttonWithType: UIButtonTypeCustom];
        [callPress setFrame:CGRectMake(120, 55, 60, 60)];
        UIImage *callPressNormalImage = [UIImage imageNamed:@"call-button.png"];
        [callPress setBackgroundImage:callPressNormalImage forState:UIControlStateNormal];
        [callPress addTarget:self action:@selector(openBrowser) forControlEvents:UIControlEventTouchUpInside];

        
        mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,(self.bounds.size.height)-155,(self.bounds.size.width),(self.bounds.size.height)/3)];
        mapView.showsUserLocation = YES;
        mapView.mapType = MKMapTypeStandard;
//        mapView.delegate = self;
        
// The map location is set here

//        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(35, -90);
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(mapLati, mapLongi); // pick desired values
        MKCoordinateSpan span = MKCoordinateSpanMake(100, 100); // pick desired values
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        region.center.latitude = 40.707184;
        region.center.longitude = -73.998392;
        region.center.latitude = mapLati;
        region.center.longitude = mapLongi;
        region.span.longitudeDelta = 1.0f;
        region.span.latitudeDelta = 1.0f;
        [mapView setRegion:region animated:YES];


        
        self.backgroundColor = [UIColor whiteColor];
#warning placeholder stuff, replace with card-specific information }
        
        
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
//        [self addSubview:phone_number];
        [self addGestureRecognizer:panGestureRecognizer];
        [self addSubview:information];
        [self addSubview:picture];
        [self addSubview:rating];
        [self addSubview:review_text];
        [self addSubview:callPress];
//        [self addSubview:phoneButton];
        
        [self addSubview:mapView];
//        [self addSubview:review_image];
        
        overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
    }
    return self;
}

-(void)setupView
{
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//%%% called when you move your finger across the screen.
// called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        overlayView.mode = GGOverlayViewModeRight;
    } else {
        overlayView.mode = GGOverlayViewModeLeft;
    }
    
    overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             overlayView.alpha = 0;
                         }];
    }
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

//-(IBAction)pushButton {
//    [[UIApplication sharedApplication] openURL: [NSURLWithString:"@http://www.youtube.com"]];
//}

-(void)openBrowser {
    NSLog(@"%@ sdgsd", callPhone);
    [[UIApplication sharedApplication] openURL:callPhone];
}


@end
