//
//  YPAPISample.h
//  YelpAPI
//

#import <Foundation/Foundation.h>
#import "NSURLRequest+OAuth.h"


/**
 Sample class for accessing the Yelp API V2.

 This class demonstrates the capability of the Yelp API version 2.0 by using the Search API to
 query for businesses by a search term and location, and the Business API to query additional
 information about the top result from the search query.

 See the Yelp Documentation http://www.yelp.com/developers/documentation for more info.
 */
@interface YPAPISample : NSObject

@property (nonatomic, strong) NSString *defaultTerm;
@property (nonatomic, strong) NSString *defaultll;
@property (nonatomic, strong) NSString *defaultRadius_filter;
@property (nonatomic, strong) NSString *defaultOffset;

/**
 Query the Yelp API with a given term and location and displays the progress in the log
 
 @param term: The term of the search, e.g: dinner
 @param location: The location in which the term should be searched for, e.g: San Francisco, CA
 */
- (void)queryTopBusinessInfoForTerm:(NSString *)term ll:(NSString *)ll radius_filter:(NSString *)radius_filter offset:(NSString *)offset completionHandler:(void (^)(NSArray *businessArray, NSError *error))completionHandler;

- ( NSArray* )YelpCall:(NSString *)offsetNum;
@end
