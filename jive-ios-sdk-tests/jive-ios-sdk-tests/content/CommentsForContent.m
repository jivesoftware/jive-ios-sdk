//
//  CommentsForContent.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/23/13.
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



#import "QEDocumentTests.h"
#import "JVUtilities.h"

@interface CommentsForContent : QEDocumentTests

@end

@implementation CommentsForContent


- (void) testCommentsForContent {
    
    __block NSArray *returnedCommentsListFromSDK = nil;
    NSString* contentURL = [self.testContent.selfRef absoluteString];
    
    // Make API call
    // get the comment count for the doc
        
    NSString* commentsForContentAPIURL = [contentURL stringByAppendingString:@"/comments"];
   
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:commentsForContentAPIURL];
    NSArray* returnedCommentsListFromAPI= [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger commentsCountFromAPI = [returnedCommentsListFromAPI count];
    
    
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    [options addField: @"author"];
    
    waitForTimeout(^(dispatch_block_t finishBlock2) {
        [jive1 commentsForContent:self.testContent withOptions:options onComplete:^(NSArray *results) {
            returnedCommentsListFromSDK = results;
            
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    });
    
     STAssertEquals([returnedCommentsListFromSDK count], commentsCountFromAPI , @"Expecting comments count from SDK and API to match!");
        
}

@end
