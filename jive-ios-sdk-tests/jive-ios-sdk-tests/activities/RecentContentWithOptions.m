//
//  RecentContentWithOptions.m
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

@interface RecentContentWithOptions : JiveTestCase

@end

@implementation RecentContentWithOptions


- (void) testGetRecentContentWithOptions {
    
    JiveCountRequestOptions* jiveCountRequestOptions = [[JiveCountRequestOptions alloc] init];
    jiveCountRequestOptions.count = 20;
    
    __block NSArray *recentContentList = nil;
    
    waitForTimeout(^(dispatch_block_t finishBlock3) {
        [jive1 recentContentWithOptions:jiveCountRequestOptions onComplete:^(NSArray *contents) {
            
            recentContentList = contents;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    });
    
    
    // Make API call
    // Get the recent content count for the user
    
    /*
    NSString* recentContentAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/activities/recent/content?count=20";    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentContentAPIURL];
    */
    
    NSString* recentContentAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/activities/recent/content?count=20"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:recentContentAPIURL];
    
    NSArray* returnedRecentContentListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger returnedRecentContentCountFromAPI = [returnedRecentContentListFromAPI count];
    
    STAssertEquals(returnedRecentContentCountFromAPI, [recentContentList count], @"Expecting same results from SDK and v3 API for recent Content count on this document!");
 
    
    NSUInteger i = 0;
    
    for (JiveContent* jiveContentFromSDK in recentContentList) {
        
        NSString* aContentSubjectFromSDK = jiveContentFromSDK.subject;
        
        id jiveContentFromAPI = [returnedRecentContentListFromAPI objectAtIndex:i];
        
        NSString* aContentSubjectFromAPI = [JVUtilities get_Content_subject:jiveContentFromAPI];
        
        STAssertEqualObjects(aContentSubjectFromSDK, aContentSubjectFromAPI, @"Expecting same results from SDK and v3 API for recent content for this user!");
        
        i++;
        
    }

}

@end
