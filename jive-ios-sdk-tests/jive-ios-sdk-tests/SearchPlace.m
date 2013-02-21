//
//  SearchPlace.m
//  jive-ios-sdk-tests
//
//  Created by Linh Tran on 2/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"

#define  SHOW_TEST_LOGS 0

@interface SearchPlace : JiveTestCase

@end

@implementation SearchPlace

-(void) test_SearchPlace_withIos
{
    JiveSearchPlacesRequestOptions* options = [[JiveSearchPlacesRequestOptions alloc]init];
    
    [options addSearchTerm:@"ios"];
    
    __block NSArray *returnedSDKPlaces = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 searchPlaces:options onComplete:^(NSArray *results) {
            returnedSDKPlaces = results;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
    
    //get the jsons response from API
    NSString* apiUrl = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/search/places?filter=search(ios)";
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:apiUrl];
    NSArray* returnedAPIPlace = [jsonResponseFromAPI objectForKey:@"list"];
    
    //verify the 1st of returned row from API and SDK;
    JivePlace *placeSDK = returnedSDKPlaces[0];
    id placeAPI = [returnedAPIPlace objectAtIndex:0];
      
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedSDKPlaces count], [returnedAPIPlace count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedSDKPlaces count], [returnedAPIPlace count]);
    
    STAssertEqualObjects([placeSDK description], [JVUtilities get_Place_description:placeAPI ], @"The 'description of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK description], [JVUtilities get_Place_description:placeAPI ] );
    
    STAssertEqualObjects([placeSDK jiveId], [JVUtilities get_Place_id:placeAPI ], @"The 'id' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK jiveId], [JVUtilities get_Place_id:placeAPI ] );
 
    STAssertEquals([placeSDK viewCount], [JVUtilities get_Place_viewCount:placeAPI ], @"The 'viewCount' of SDK and API are not matched.  SDK = %i and API = %i", [placeSDK viewCount], [JVUtilities get_Place_viewCount:placeAPI ] );

    STAssertEqualObjects([placeSDK displayName], [JVUtilities get_Place_displayName:placeAPI ], @"The 'displayName' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK displayName], [JVUtilities get_Place_displayName:placeAPI ] );
    
    STAssertEqualObjects([placeSDK published], [JVUtilities get_Place_published:placeAPI ], @"The 'published' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK published], [JVUtilities get_Place_published:placeAPI ] );
    
    STAssertEqualObjects([placeSDK type], [JVUtilities get_Place_type:placeAPI ], @"The 'type' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK type], [JVUtilities get_Place_type:placeAPI ]);
    
    STAssertEqualObjects([[placeSDK parentPlace] uri], [JVUtilities get_Place_ParentPlace_uri:placeAPI ], @"The 'uri of parent placee' of SDK and API are not matched.  SDK = %@ and API = %@", [[placeSDK parentPlace] uri], [JVUtilities get_Place_ParentPlace_uri:placeAPI ] );
    
    STAssertEqualObjects([[placeSDK parentPlace] jiveId], [JVUtilities get_Place_ParentPlace_id:placeAPI ], @"The 'jiveId of parent placee' of SDK and API are not matched.  SDK = %@ and API = %@", [[placeSDK parentPlace] jiveId], [JVUtilities get_Place_ParentPlace_id:placeAPI ] );
    
}


-(void) test_SearchPlace_withIos_JiveSortOrderUpdatedAsc
{
    JiveSearchPlacesRequestOptions* options = [[JiveSearchPlacesRequestOptions alloc]init];    

    NSArray* filter = [[NSArray alloc] initWithObjects:@"ios", @"open", nil];
    
    options.search = filter;
    options.sort = JiveSortOrderUpdatedAsc;
    
    __block NSArray *returnedSDKPlaces = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 searchPlaces:options onComplete:^(NSArray *results) {
            returnedSDKPlaces = results;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
    
    //get the jsons response from API
    NSString* apiUrl = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/search/places?sort=updatedAsc&filter=search(ios,open)";
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:apiUrl];
    NSArray* returnedAPIPlace = [jsonResponseFromAPI objectForKey:@"list"];
    
    //verify the 1st of returned row from API and SDK;
    JivePlace *placeSDK = returnedSDKPlaces[0];
    id placeAPI = [returnedAPIPlace objectAtIndex:0];
     
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedSDKPlaces count], [returnedAPIPlace count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedSDKPlaces count], [returnedAPIPlace count]);
    
    STAssertEqualObjects([placeSDK description], [JVUtilities get_Place_description:placeAPI ], @"The 'description of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK description], [JVUtilities get_Place_description:placeAPI ] );
    
    STAssertEqualObjects([placeSDK jiveId], [JVUtilities get_Place_id:placeAPI ], @"The 'id' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK jiveId], [JVUtilities get_Place_id:placeAPI ] );
    
    STAssertEquals([placeSDK viewCount], [JVUtilities get_Place_viewCount:placeAPI ], @"The 'viewCount' of SDK and API are not matched.  SDK = %i and API = %i", [placeSDK viewCount], [JVUtilities get_Place_viewCount:placeAPI ] );
    
    STAssertEqualObjects([placeSDK displayName], [JVUtilities get_Place_displayName:placeAPI ], @"The 'displayName' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK displayName], [JVUtilities get_Place_displayName:placeAPI ] );
    
    STAssertEqualObjects([placeSDK published], [JVUtilities get_Place_published:placeAPI ], @"The 'published' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK published], [JVUtilities get_Place_published:placeAPI ] );
    
    STAssertEqualObjects([placeSDK type], [JVUtilities get_Place_type:placeAPI ], @"The 'type' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK type], [JVUtilities get_Place_type:placeAPI ]);
    
    STAssertEqualObjects([[placeSDK parentPlace] uri], [JVUtilities get_Place_ParentPlace_uri:placeAPI ], @"The 'uri of parent placee' of SDK and API are not matched.  SDK = %@ and API = %@", [[placeSDK parentPlace] uri], [JVUtilities get_Place_ParentPlace_uri:placeAPI ] );
    
    STAssertEqualObjects([[placeSDK parentPlace] jiveId], [JVUtilities get_Place_ParentPlace_id:placeAPI ], @"The 'jiveId of parent placee' of SDK and API are not matched.  SDK = %@ and API = %@", [[placeSDK parentPlace] jiveId], [JVUtilities get_Place_ParentPlace_id:placeAPI ] );
    
}





-(void) test_SearchPlace_withIos_GroupSpaceType_JiveSortOrderRelevanceDesc
{
    JiveSearchPlacesRequestOptions* options = [[JiveSearchPlacesRequestOptions alloc]init];
    
    NSArray* filter = [[NSArray alloc] initWithObjects:@"group", @"space", nil];
    
    [options addSearchTerm:@"ios"];
    options.types = filter;
    options.sort = JiveSortOrderRelevanceDesc;
    
    __block NSArray *returnedSDKPlaces = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 searchPlaces:options onComplete:^(NSArray *results) {
            returnedSDKPlaces = results;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
    
    //get the jsons response from API
    NSString* apiUrl = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/search/places?filter=type(group,space)&filter=search(ios)&sort=relevanceDesc";
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:apiUrl];
    NSArray* returnedAPIPlace = [jsonResponseFromAPI objectForKey:@"list"];
    
    //verify the 1st of returned row from API and SDK;
    JivePlace *placeSDK = returnedSDKPlaces[0];
    id placeAPI = [returnedAPIPlace objectAtIndex:0];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedSDKPlaces count], [returnedAPIPlace count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedSDKPlaces count], [returnedAPIPlace count]);
    
    STAssertEqualObjects([placeSDK description], [JVUtilities get_Place_description:placeAPI ], @"The 'description of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK description], [JVUtilities get_Place_description:placeAPI ] );
    
    STAssertEqualObjects([placeSDK jiveId], [JVUtilities get_Place_id:placeAPI ], @"The 'id' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK jiveId], [JVUtilities get_Place_id:placeAPI ] );
    
    STAssertEquals([placeSDK viewCount], [JVUtilities get_Place_viewCount:placeAPI ], @"The 'viewCount' of SDK and API are not matched.  SDK = %i and API = %i", [placeSDK viewCount], [JVUtilities get_Place_viewCount:placeAPI ] );
    
    STAssertEqualObjects([placeSDK displayName], [JVUtilities get_Place_displayName:placeAPI ], @"The 'displayName' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK displayName], [JVUtilities get_Place_displayName:placeAPI ] );
    
    STAssertEqualObjects([placeSDK published], [JVUtilities get_Place_published:placeAPI ], @"The 'published' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK published], [JVUtilities get_Place_published:placeAPI ] );
    
    STAssertEqualObjects([placeSDK type], [JVUtilities get_Place_type:placeAPI ], @"The 'type' of SDK and API are not matched.  SDK = %@ and API = %@", [placeSDK type], [JVUtilities get_Place_type:placeAPI ]);
    
    STAssertEqualObjects([[placeSDK parentPlace] uri], [JVUtilities get_Place_ParentPlace_uri:placeAPI ], @"The 'uri of parent placee' of SDK and API are not matched.  SDK = %@ and API = %@", [[placeSDK parentPlace] uri], [JVUtilities get_Place_ParentPlace_uri:placeAPI ] );
    
    STAssertEqualObjects([[placeSDK parentPlace] jiveId], [JVUtilities get_Place_ParentPlace_id:placeAPI ], @"The 'jiveId of parent placee' of SDK and API are not matched.  SDK = %@ and API = %@", [[placeSDK parentPlace] jiveId], [JVUtilities get_Place_ParentPlace_id:placeAPI ] );
    
}
@end
