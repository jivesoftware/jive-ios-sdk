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



#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface CommentsForContent : JiveTestCase

@end

@implementation CommentsForContent


- (void) testCommentsForContent {
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    
    
   
    __block NSArray *returnedContentsList = nil;
    
    
    __block NSArray *returnedCommentsListFromSDK = nil;
    
    [searchOptions addSearchTerm:@"iOS-SDK-TestUser1 Document Subject1"];
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 searchContents:searchOptions onComplete:^(NSArray *results) {
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
    // get the comment count for the doc
        
    NSString* commentsForContentAPIURL = [contentURL stringByAppendingString:@"/comments"];
   
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:commentsForContentAPIURL];
    NSArray* returnedCommentsListFromAPI= [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger commentsCountFromAPI = [returnedCommentsListFromAPI count];
    
    
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    [options addField: @"author"];
    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 commentsForContent:testContent withOptions:options onComplete:^(NSArray *results) {
            returnedCommentsListFromSDK = results;
            
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
     STAssertEquals([returnedCommentsListFromSDK count], commentsCountFromAPI , @"Expecting comments count from SDK and API to match!");
        
}

@end
