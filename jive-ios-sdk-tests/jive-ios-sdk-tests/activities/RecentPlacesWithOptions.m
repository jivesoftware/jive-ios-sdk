//
//  RecentPlacesWithOptions.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 2/19/13.
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

@interface RecentPlacesWithOptions : JiveTestCase

@end

@implementation RecentPlacesWithOptions


- (void) testGetRecentPlacesWithOptions {
    
    JiveCountRequestOptions* jiveCountRequestOptions = [[JiveCountRequestOptions alloc] init];
    jiveCountRequestOptions.count = 15;
    
    __block NSArray *recentPlacesList = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 recentPlacesWithOptions:jiveCountRequestOptions onComplete:^(NSArray *places) {
            
            recentPlacesList = places;
            // NSLog(@"recent places list=%i", [recentPlacesList count]);
            
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    // Make API call
    // Get the recent places count for the user
    
    /*
    NSString* recentPlacesAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/activities/recent/places?count=15";        
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:recentPlacesAPIURL];
    */
    
    NSString* recentPlacesAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/activities/recent/places?count=15"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPlacesAPIURL];
    
    NSArray* returnedRecentPlacesListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger returnedRecentPlacesCountFromAPI = [returnedRecentPlacesListFromAPI count];
    
    STAssertEquals(returnedRecentPlacesCountFromAPI, [recentPlacesList count], @"Expecting same results from SDK and v3 API for recent places count on this document!");
   
    NSUInteger i = 0;
    
    for (JivePlace* jivePlaceFromSDK in recentPlacesList) {
        
      NSString* aPlaceNameFromSDK = jivePlaceFromSDK.displayName;
     
      id jivePlaceFromAPI = [returnedRecentPlacesListFromAPI objectAtIndex:i];
        
      NSString* aPlaceNameFromAPI = [JVUtilities get_Place_displayName:jivePlaceFromAPI];
   
      STAssertEqualObjects(aPlaceNameFromSDK, aPlaceNameFromAPI, @"Expecting same results from SDK and v3 API for recent places for this user!");
        
      i++;
        
    }
    
}

@end
