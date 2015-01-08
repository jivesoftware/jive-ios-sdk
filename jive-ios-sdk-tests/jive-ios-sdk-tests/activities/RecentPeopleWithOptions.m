//
//  RecentPeopleWithOptions.m
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

@interface RecentPeopleWithOptions : JiveTestCase

@end

@implementation RecentPeopleWithOptions


- (void) testGetRecentPeopleWithOptions {
    
    JiveCountRequestOptions* jiveCountRequestOptions = [[JiveCountRequestOptions alloc] init];
    jiveCountRequestOptions.count = 20;
    
    __block NSArray *recentPeopleList = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock3) {
        [jive1 recentPeopleWithOptions:jiveCountRequestOptions onComplete:^(NSArray *persons) {
            
            recentPeopleList = persons;
            
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    });
    
    // Make API call
    // Get the recent people count for the user
    
    /*
     NSString* recentPeopleAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/activities/recent/people?count=20";
     id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPeopleAPIURL];
     */
    
    NSString* recentPeopleAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/activities/recent/people?count=20"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentPeopleAPIURL];
    
    NSArray* returnedRecentPeopleListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger returnedRecentPeopleCountFromAPI = [returnedRecentPeopleListFromAPI count];
    
    STAssertEquals(returnedRecentPeopleCountFromAPI, [recentPeopleList count], @"Expecting same results from SDK and v3 API for recent people count on this document!");
    
    
    
    NSUInteger i = 0;
    
    for (JivePerson* jivePersonFromSDK in recentPeopleList) {
        
        NSString* aPersonNameFromSDK = jivePersonFromSDK.displayName;
        
        id jivePersonFromAPI = [returnedRecentPeopleListFromAPI objectAtIndex:i];
        
        NSString* aPersonNameFromAPI = [JVUtilities get_Person_DisplayName:jivePersonFromAPI];
        
        STAssertEqualObjects(aPersonNameFromSDK, aPersonNameFromAPI, @"Expecting same results from SDK and v3 API for recent Persons for this user!");
        
        i++;
        
    }
    
}

@end
