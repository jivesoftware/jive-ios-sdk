//
//  JVPlacesTest.m
//  jive-ios-sdk-tests
//
//  Created by Heath Borders on 1/17/13.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface JVPlacesTest : JiveTestCase

@end

@implementation JVPlacesTest

- (void)test_search_places_with_term_ios {
    JivePlacesRequestOptions *placesRequestOptions = [JivePlacesRequestOptions new];
    [placesRequestOptions addSearchTerm:@"ios"];
    
    __block NSArray *returnedPlaces = nil;
    [self waitForTimeout:^(JiveTestCaseAsyncFinishBlock finishBlock) {
        [jive1 places:placesRequestOptions
          onComplete:^(NSArray *places) {
              returnedPlaces = places;
              finishBlock();
          }
             onError:^(NSError *error) {
                 [self unexpectedErrorInWaitForTimeOut:error
                                           finishBlock:finishBlock];
             }];
    }];
    
    NSMutableArray *returnedPlacesNames = [NSMutableArray new];
    for (JivePlace *place in returnedPlaces) {
        [returnedPlacesNames addObject:place.name];
    }
    
    
    /*
    NSString* recentPlacesAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/places?filter=search(ios)";    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:recentPlacesAPIURL];
    */
    
    NSString* recentPlacesAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/places?filter=search(ios)"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPlacesAPIURL];
    
    NSArray* returnedtPlacesListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    
    
    //verify the number returned rows between API and SDK
    STAssertEquals([returnedPlaces count], [returnedtPlacesListFromAPI count], @"The number returned rows of SDK and API are not matched.  SDK = %i and API = %i", [returnedPlaces count], [returnedtPlacesListFromAPI count]);
    
    NSUInteger i = 0;
    
    for (JivePlace* jivePlaceFromSDK in returnedPlaces) {
        
        id jivePlaceFromAPI = [returnedtPlacesListFromAPI objectAtIndex:i];
        
        NSString* aPlaceNameFromAPI = [JVUtilities get_Place_description:jivePlaceFromAPI];
        
        STAssertEqualObjects( jivePlaceFromSDK.jiveDescription, aPlaceNameFromAPI , @"Expecting same results from SDK and v3 API for recent places for this user, sdk = '%@' , api = '%@' !",  jivePlaceFromSDK.jiveDescription, aPlaceNameFromAPI);
        
        i++;
        
    }
    

}

@end
