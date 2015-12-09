//
//  DraggableView.h
//  testing swiping
//


#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@end

@interface DraggableView : UIView

@property (weak) id <DraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)OverlayView* overlayView;
@property (nonatomic,strong)UILabel* information; //%%% a placeholder for any card-specific information
@property (nonatomic,strong)UILabel* review_text;
//@property (nonatomic,strong)UITextView* phone_number;
@property (nonatomic,strong)NSString* phone_number;
@property (nonatomic,strong)UIImageView* review_image;
@property (nonatomic,strong)UIImageView* picture;
@property (nonatomic,strong)UIImageView* rating;
@property (nonatomic,strong)MKMapView* mapView;
@property (nonatomic,strong)UILabel* location;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,retain)NSString* longitude;
@property (nonatomic,retain)NSString* latitude;
@property (nonatomic,strong)NSURL* callPhone;
@property (nonatomic,strong)UIButton* phoneButton;

//@property (nonatomic,assign)CLLocationDegrees mapLat;
//@property (nonatomic,assign)CLLocationDegrees mapLong;



-(void)leftClickAction;
-(void)rightClickAction;
-(IBAction)setMap:(id)sender;
-(IBAction)openBrowser;

@end
