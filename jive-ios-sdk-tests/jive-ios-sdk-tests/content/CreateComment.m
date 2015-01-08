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

@property (strong, nonatomic) JiveComment *comment;
@property (strong, nonatomic) JiveDocument *testDoc;
@property (strong, nonatomic) NSString *commentsForContentAPIURL;

@end

@implementation CreateComment

- (void)setUp {
    [super setUp];
    self.comment = [[JiveComment alloc] init];
    
    self.comment.content = [[JiveContentBody alloc] init];
    self.comment.content.type = @"text/html";
    self.comment.subject = @"Test Comment Subject from SDK";
    
    JiveDocument *document = [[JiveDocument alloc] init];
    
    NSString* docSubj = [NSString stringWithFormat:@"Test Document for comments testing, From SDK- %d", (arc4random() % 1500000)];
    
    document.subject = docSubj;
    document.content = [[JiveContentBody alloc] init];
    document.content.type = @"text/html";
    document.content.text = @"<body><p>This is a test doc from iPad SDK.</p></body>";
    
    waitForTimeout(^(dispatch_block_t finishBlock) {
        [jive3 createContent:document withOptions:nil onComplete:^(JiveContent *newDocument) {
            STAssertEqualObjects([newDocument class], [JiveDocument class], @"Wrong content created");
            
            self.testDoc = (JiveDocument *)newDocument;
            
            finishBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock();
        }];
    });
    
    STAssertEqualObjects(self.testDoc.subject, document.subject, @"Unexpected document: %@", [self.testDoc toJSONDictionary]);
    
    NSString* contentURL = [self.testDoc.selfRef absoluteString];
    
    self.comment.parent = contentURL;
    
    self.commentsForContentAPIURL = [contentURL stringByAppendingString:@"/comments"];
    
    NSLog(@"comments API URL=%@", self.commentsForContentAPIURL);
}

- (void)tearDown {
    self.testDoc = nil;
    self.comment = nil;
    [super tearDown];
}

- (NSUInteger)getCommentCountFromAPI {
    // get the comment count for the doc through v3 API and Verify
    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid3 pw:pw3 URL:self.commentsForContentAPIURL];
    NSArray*  returnedCommentsListFromAPIAfter= [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger commentsCountFromAPIAfterCommenting = [returnedCommentsListFromAPIAfter count];
    
    return commentsCountFromAPIAfterCommenting;
}

- (void) testCreateCommentAsNonAuthor {
    NSUInteger commentsCountFromAPIBeforeCommenting = [self getCommentCountFromAPI];
    
    __block JiveContent* commentedContent = nil;
    
    JiveAuthorCommentRequestOptions* j = [[JiveAuthorCommentRequestOptions alloc] init];
    j.author = false;
    
    self.comment.content.text = @"<body><p>This is a test comment text from the SDK by a non-Author</p></body>";
    waitForTimeout(^(dispatch_block_t finishBlock4) {
        [jive2 createComment:self.comment withOptions:j onComplete:^(JiveContent *results) {
            
            commentedContent = results;
            finishBlock4();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock4();
        }];
    });
    
    // Give the server time to process the comment.
    [NSThread sleepForTimeInterval:0.5];
    
    NSUInteger commentsCountFromAPIAfterCommenting = [self getCommentCountFromAPI];
    
    STAssertEquals(commentsCountFromAPIAfterCommenting, commentsCountFromAPIBeforeCommenting + 1, @"Expecting a successful comment to increase the comment count on this document by one!");
}



- (void) testCreateCommentAsAuthor {
    NSUInteger commentsCountFromAPIBeforeCommenting = [self getCommentCountFromAPI];
    
    __block JiveContent* commentedContent = nil;
    
    self.comment.content.text = @"<body><p>This is a test comment text from the SDK by the Author</p></body>";
    waitForTimeout(^(dispatch_block_t finishBlock4) {
        [jive3 createComment:self.comment withOptions:nil onComplete:^(JiveContent *results) {
            
            commentedContent = results;
            finishBlock4();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock4();
        }];
    });
    
    // Give the server time to process the comment.
    [NSThread sleepForTimeInterval:0.5];
    
    NSUInteger commentsCountFromAPIAfterCommenting = [self getCommentCountFromAPI];
    
    STAssertEquals(commentsCountFromAPIAfterCommenting, commentsCountFromAPIBeforeCommenting + 1, @"Expecting a successful comment to increase the comment count on this document by one!");
    
}


@end
