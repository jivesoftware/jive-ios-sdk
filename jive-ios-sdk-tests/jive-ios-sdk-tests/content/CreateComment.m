//
//  CreateComment.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 2/1/13.
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

@interface CreateComment : JiveTestCase

@end

@implementation CreateComment

- (void) testCreateCommentAsNonAuthor {
  
    JiveComment *comment = [[JiveComment alloc] init];
    
    comment.content = [[JiveContentBody alloc] init];
    comment.content.type = @"text/html";
    comment.content.text = @"<body><p>This is a test comment text from the SDK by an non-Author</p></body>";
    comment.subject = @"Test Comment Subject from SDK by non-author";
    
    JiveAuthorCommentRequestOptions* j = [[JiveAuthorCommentRequestOptions alloc] init];
    j.author = false;
    
    
    JiveDocument *post = [[JiveDocument alloc] init];
    __block JiveContent *testDoc = nil;
    
    NSString* docSubj = [NSString stringWithFormat:@"Test Document for comments testing, From SDK- %d", (arc4random() % 1500000)];
    
    post.subject = docSubj;
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"text/html";
    post.content.text = @"<body><p>This is a test doc from iPad SDK.</p></body>";
    
    [self waitForTimeout:^(dispatch_block_t finishBlock) {
        [jive3 createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
            STAssertEqualObjects([newPost class], [JiveDocument class], @"Wrong content created");
            
            testDoc = newPost;
            
            finishBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock();
        }];
    }];
    
    STAssertEqualObjects(testDoc.subject, post.subject, @"Unexpected person: %@", [testDoc toJSONDictionary]);
    
    
    NSString* contentURL = [testDoc.selfRef absoluteString];
    
    comment.parent = contentURL;
    
    
    NSString* commentsForContentAPIURL = [contentURL stringByAppendingString:@"/comments"];
    
    NSLog(@"comments API URL=%@", commentsForContentAPIURL);
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser3" pw:@"test123" URL:commentsForContentAPIURL];
    NSArray* returnedCommentsListFromAPI= [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger commentsCountFromAPIBeforeCommenting = [returnedCommentsListFromAPI count];
    NSLog(@"Before comment=%@", [@(commentsCountFromAPIBeforeCommenting) stringValue]);
    
    __block JiveContent* commentedContent = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock4) {
        [jive2 createComment:comment withOptions:j onComplete:^(JiveContent *results) {
            
            commentedContent = results;
            finishBlock4();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock4();
        }];
    }];
        
    // get the comment count for the doc through v3 API and Verify
    
    jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser3" pw:@"test123" URL:commentsForContentAPIURL];
    NSArray*  returnedCommentsListFromAPIAfter= [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger commentsCountFromAPIAfterCommenting = [returnedCommentsListFromAPIAfter count];
    
    NSLog(@"After comment=%@", [@(commentsCountFromAPIAfterCommenting) stringValue]);
    
    
    STAssertEquals(commentsCountFromAPIAfterCommenting, commentsCountFromAPIBeforeCommenting + 1, @"Expecting a successful comment to increase the comment count on this document by one!");
    
}



- (void) testCreateCommentAsAuthor {
    
    JiveComment *comment = [[JiveComment alloc] init];
    
    comment.content = [[JiveContentBody alloc] init];
    comment.content.type = @"text/html";
    comment.content.text = @"<body><p>This is a test comment text from the SDK by an non-Author</p></body>";
    comment.subject = @"Test Comment Subject from SDK by doc author";
    
    JiveDocument *post = [[JiveDocument alloc] init];
    __block JiveContent *testDoc = nil;
    
    NSString* docSubj = [NSString stringWithFormat:@"Test Document for comments testing, From SDK- %d", (arc4random() % 1500000)];
    
    post.subject = docSubj;
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"text/html";
    post.content.text = @"<body><p>This is a test doc from iPad SDK.</p></body>";
    
    [self waitForTimeout:^(dispatch_block_t finishBlock) {
        [jive3 createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
            STAssertEqualObjects([newPost class], [JiveDocument class], @"Wrong content created");
            
            testDoc = newPost;
            
            finishBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock();
        }];
    }];
    
    STAssertEqualObjects(testDoc.subject, post.subject, @"Unexpected person: %@", [testDoc toJSONDictionary]);
    
    
    NSString* contentURL = [testDoc.selfRef absoluteString];
    
    comment.parent = contentURL;
    
    
    NSString* commentsForContentAPIURL = [contentURL stringByAppendingString:@"/comments"];
    
    NSLog(@"comments API URL=%@", commentsForContentAPIURL);
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser3" pw:@"test123" URL:commentsForContentAPIURL];
    NSArray* returnedCommentsListFromAPI= [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger commentsCountFromAPIBeforeCommenting = [returnedCommentsListFromAPI count];
    NSLog(@"Before comment=%@", [@(commentsCountFromAPIBeforeCommenting) stringValue]);
    
    __block JiveContent* commentedContent = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock4) {
        [jive3 createComment:comment withOptions:nil onComplete:^(JiveContent *results) {
            
            commentedContent = results;
            finishBlock4();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock4();
        }];
    }];
    
    // get the comment count for the doc through v3 API and Verify
    
    jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser3" pw:@"test123" URL:commentsForContentAPIURL];
    NSArray*  returnedCommentsListFromAPIAfter= [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger commentsCountFromAPIAfterCommenting = [returnedCommentsListFromAPIAfter count];
    
    NSLog(@"After comment=%@", [@(commentsCountFromAPIAfterCommenting) stringValue]);
    
    
    STAssertEquals(commentsCountFromAPIAfterCommenting, commentsCountFromAPIBeforeCommenting + 1, @"Expecting a successful comment to increase the comment count on this document by one!");
    
}


@end
