//
//  FrequentContentWithOptions.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 2/15/13.
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


@interface FrequentContentWithOptions : JiveTestCase

@end

@implementation FrequentContentWithOptions

- (void) testGetFrequentContentWithOptions {
    
    JiveCountRequestOptions* jiveCountRequestOptions = [[JiveCountRequestOptions alloc] init];
    jiveCountRequestOptions.count = 15;
    
    __block NSArray *frequentContentList = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 frequentContentWithOptions:jiveCountRequestOptions onComplete:^(NSArray *content) {
            
            frequentContentList = content;
            
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
        
    // Make API call
    // Get the Frequent content count for the user
    
   /* NSString* frequentContentAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/activities/frequent/content?count=15";
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:frequentContentAPIURL];
    */
    
    NSString* frequentContentAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/activities/frequent/content?count=15"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:frequentContentAPIURL];
    
    NSArray* returnedFrequentContentListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger returnedFrequentContentCountFromAPI = [returnedFrequentContentListFromAPI count];
    
    STAssertEquals(returnedFrequentContentCountFromAPI, [frequentContentList count], @"Expecting same results from SDK and v3 API for Frequent Content count on this document!");
        
}
@end

