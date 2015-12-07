//
//  YPAPISample.m
//  YelpAPI

#import "YPAPISample.h"

/**
 Default paths and search terms used in this example
 */
static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"20";

@implementation YPAPISample
    @synthesize defaultTerm;
    @synthesize defaultll;
    @synthesize defaultRadius_filter;
    @synthesize defaultOffset;


#pragma mark - Public

- (void)queryTopBusinessInfoForTerm:(NSString *)term ll:(NSString *)ll radius_filter:(NSString *)radius_filter offset:(NSString *)offset completionHandler:(void (^)(NSArray *businessArray, NSError *error))completionHandler {

  NSLog(@"Querying the Search API with term \'%@\' and location \'%@'", term, ll);

  //Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term ll:ll radius_filter:radius_filter offset:offset];
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

    if (!error && httpResponse.statusCode == 200) {
        
        

      NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        //NSLog(@"%@", searchResponseJSON);
      NSArray *businessArray = searchResponseJSON[@"businesses"];
        //NSLog(@"Business array: %@", businessArray);
        
//        NSArray *keyArray =
//        NSDictionary *tempDictionary = [businessArray initWithObjects:businessArray forKeys: ];
//        NSLog(@"%@", tempDictionary);
//        
        
        
      if ([businessArray count] > 0) {
          
        //NSLog(@"%@", businessArray);
          
        //NSDictionary *firstBusiness = [businessArray firstObject];
        //NSString *firstBusinessID = firstBusiness[@"id"];
        NSLog(@"%lu businesses found, offset: %@", (unsigned long)[businessArray count], offset);
        //NSDictionary *allBusiness = [businessArray ];
        completionHandler( businessArray, error);

        //[self queryBusinessInfoForBusinessId:firstBusinessID completionHandler:completionHandler];
      } else {
        completionHandler(nil, error); // No business was found
      }
    } else {
      completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
    }
  }] resume];
}

//- (void)queryBusinessInfoForBusinessId:(NSString *)businessID completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler {
//
//  NSURLSession *session = [NSURLSession sharedSession];
//  NSURLRequest *businessInfoRequest = [self _businessInfoRequestForID:businessID];
//  [[session dataTaskWithRequest:businessInfoRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//    if (!error && httpResponse.statusCode == 200) {
//      NSDictionary *businessResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//
//      completionHandler(businessResponseJSON, error);
//    } else {
//      completionHandler(nil, error);
//    }
//  }] resume];
//
//}


#pragma mark - API Request Builders

/**
 Builds a request to hit the search endpoint with the given parameters.
 
 @param term The term of the search, e.g: dinner
 @param location The location request, e.g: San Francisco, CA

 @return The NSURLRequest needed to perform the search
 */
- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term ll:(NSString *)ll radius_filter:(NSString *)radius_filter offset:(NSString *)offset {
  NSDictionary *params = @{
                           @"term": term,
                           @"ll": ll,
                           @"radius_filter": radius_filter,
                           @"offset": offset,
                           @"limit": kSearchLimit
                           };

  return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

/**
 Builds a request to hit the business endpoint with the given business ID.
 
 @param businessID The id of the business for which we request informations

 @return The NSURLRequest needed to query the business info
 */
- (NSURLRequest *)_businessInfoRequestForID:(NSString *)businessID {

  NSString *businessPath = [NSString stringWithFormat:@"%@%@", kBusinessPath, businessID];
  return [NSURLRequest requestWithHost:kAPIHost path:businessPath];
}

- ( NSArray* )YelpCall:(NSString *)offsetNum {
//    defaultTerm = @"food";
//    defaultll = @"38.3433588,-122.739119";
//    defaultRadius_filter = @"30000";
//    defaultOffset = @"0";
    
    // NSString *defaultLocation = @"Rohnert Park, CA";
    
    //Get the term and location from the command line if there were any, otherwise assign default values.
//    NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
//    NSString *ll = [[NSUserDefaults standardUserDefaults] valueForKey:@"ll"] ?: defaultll;
//    NSString *radius_filter = [[NSUserDefaults standardUserDefaults] valueForKey:@"radius_filter"] ?: defaultRadius_filter;
//    NSString *offset = [[NSUserDefaults standardUserDefaults] valueForKey:@"offset"] ?: defaultOffset;
    //ViewController *viewC = [[ViewController alloc] init];
    
    NSString *term = @"food";
    NSString *ll = @"38.3433588,-122.739119";
    NSString *radius_filter = @"30000"; //[NSString stringWithFormat:@"%f", [ViewController getDistance]];
    NSString *offset = offsetNum;
    
    __block NSMutableArray *data;// = [[NSMutableArray alloc] init];
    YPAPISample *APISample = [[YPAPISample alloc] init];
    
    dispatch_group_t requestGroup = dispatch_group_create();
    
    dispatch_group_enter(requestGroup);
    [APISample queryTopBusinessInfoForTerm:term ll:ll radius_filter:radius_filter offset:offset completionHandler:^(NSArray *topBusinessJSON, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
        } else if (topBusinessJSON) {
            //NSLog(@"Top business info: \n %@", topBusinessJSON);
            //NSLog(@"More stuff %@\n", [topBusinessJSON :@"Name"]);
            //NSLog(@"More stuff %lu\n", (unsigned long)[topBusinessJSON count]);
            //_APIdata = [NSDictionary dictionaryWithDictionary:topBusinessJSON];
            //NSLog(@"Top business info: \n %@", _APIdata);
            data = [[NSMutableArray alloc] initWithArray:topBusinessJSON];
            //            [exampleCardLabels retain];
                        for (int i = 0; i < [data count]; ++i) {
                            NSLog(@"Draggable: %@", [data[i] objectForKey:@"name"]);
//                            NSLog(@"Draggable: %@", [data[i] objectForKey:@"name"]);
                        }
        } else {
            NSLog(@"No business was found");
        }
        
        dispatch_group_leave(requestGroup);
    }];
    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    return data;
}

@end
