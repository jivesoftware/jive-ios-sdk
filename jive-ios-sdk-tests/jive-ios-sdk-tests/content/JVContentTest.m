//
//  JVContentTest.m
//  jive-ios-sdk-tests
//
//  Created by Orson Bushnell on 1/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"

@interface JVContentTest : JiveTestCase

@end

@implementation JVContentTest

- (void) testCreateAndDestroyABlogPost {
    JivePost *post = [[JivePost alloc] init];
    __block JiveContent *testBlogPost = nil;
    
    post.subject = @"Test blog 12345";
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"text/html";
    post.content.text = @"<body><p>This is a test of the emergency broadcast system.</p></body>";
    [self waitForTimeout:^(dispatch_block_t finishBlock) {
        [jive createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
            STAssertEqualObjects([newPost class], [JivePost class], @"Wrong content created");
            testBlogPost = newPost;
            finishBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock();
        }];
    }];
    
    STAssertEqualObjects(testBlogPost.subject, post.subject, @"Unexpected person: %@", [testBlogPost toJSONDictionary]);
    STAssertEqualObjects(testBlogPost.content.type, post.content.type, @"Unexpected person: %@", [testBlogPost toJSONDictionary]);
    STAssertNotNil(testBlogPost.published, @"Unexpected person: %@", [testBlogPost toJSONDictionary]);
    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive deleteContent:testBlogPost onComplete:^{
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    
    [searchOptions addSearchTerm:post.subject];
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive searchContents:searchOptions onComplete:^(NSArray *results) {
            STAssertEquals([results count], (NSUInteger)0, @"Post not deleted: %@", [[results objectAtIndex:0] toJSONDictionary]);
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
}

@end
