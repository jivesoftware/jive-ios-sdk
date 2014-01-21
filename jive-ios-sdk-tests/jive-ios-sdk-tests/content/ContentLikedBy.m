//
//  ContentLikedBy.m
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


#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface ContentLikedBy : JiveTestCase

@end

@implementation ContentLikedBy

- (void) testContentLikedBy {
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    
    __block NSArray *returnedContentsList = nil;
    
    [searchOptions addSearchTerm:@"iOS-SDK-TestUser1 Document Subject1"];
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 searchContents:searchOptions onComplete:^(NSArray *results) {
           // STAssertEquals([results count], (NSUInteger)1, @"Expecting one document in result");
            returnedContentsList = results;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
    JiveContent *testContent = nil;
    for (JiveContent *aContent in returnedContentsList) {
        if ([aContent.subject isEqualToString:@"iOS-SDK-TestUser1 Document Subject1"]) {
            testContent = aContent;
        }
    }
    
    if (testContent == nil){
        JiveDocument *post = [[JiveDocument alloc] init];
        __block JiveContent *testDoc = nil;
        
        NSString* docSubj = [NSString stringWithFormat:@"iOS-SDK-TestUser1 Document Subject1"];
        
        post.subject = docSubj;
        post.content = [[JiveContentBody alloc] init];
        post.content.type = @"text/html";
        post.content.text = @"<body><p>This is a test of the new doc creation from iPad SDK.</p></body>";
        
        [self waitForTimeout:^(dispatch_block_t finishBlock) {
            [jive1 createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
                STAssertEqualObjects([newPost class], [JiveDocument class], @"Wrong content created");
                
                testDoc = newPost;
                
                finishBlock();
            } onError:^(NSError *error) {
                STFail([error localizedDescription]);
                finishBlock();
            }];
        }];
        
        STAssertEqualObjects(testDoc.subject, post.subject, @"Unexpected person: %@", [testDoc toJSONDictionary]);
        
        testContent = testDoc;
        
    }
    
    NSString* contentURL = [testContent.selfRef absoluteString];
    
    
    // Make API call
    // Get the likes count for the doc
    
    NSString* likesForContentAPIURL = [contentURL stringByAppendingString:@"/likes"];
    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:likesForContentAPIURL];
    NSArray* returnedLikesListFromAPI= [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger returnedLikesListCountFromAPI = [returnedLikesListFromAPI count];
    	
    JivePagedRequestOptions* options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 0;
    
    __block NSArray *returnedLikesListFromSDK = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 contentLikedBy:testContent withOptions:options onComplete:^(NSArray *results) {
            returnedLikesListFromSDK = results;
            
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    STAssertEquals([returnedLikesListFromSDK count], returnedLikesListCountFromAPI, @"Expecting same results from SDK and v3 API for likes count on this document!");    
}

@end
