//
//  ContentLike_Unlike.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"

@interface ContentLike_Unlike : JiveTestCase

@end
 
@implementation ContentLike_Unlike


/*
 
- (void) testContentLike_Unlike {
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    
  //  JiveContent *returnedContent = nil;
    __block NSArray *returnedContentsList = nil;
    
    [searchOptions addSearchTerm:@"Document For LikeContent Test Automation"];
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive2 searchContents:searchOptions onComplete:^(NSArray *results) {
            
            returnedContentsList = results;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
    JiveContent *testContent = nil;
    for (JiveContent *aContent in returnedContentsList) {
        if ([aContent.subject isEqualToString:@"Document For LikeContent Test Automation"]) {
            testContent = aContent;
        }
    }
        
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 content:testContent likes:FALSE onComplete:^{
            finishBlock2();
        } onError:^(NSError *error) {
            // If content was not already liked, then ignore this error
            // STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    
    JivePagedRequestOptions* options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 0;
    
    __block NSArray *returnedLikesListFromSDK = nil;
    __block NSArray *returnedLikesListFromSDK2 = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive2 contentLikedBy:testContent withOptions:options onComplete:^(NSArray *results) {
            returnedLikesListFromSDK = results;
            
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    
    NSUInteger likeCountBefore = [returnedLikesListFromSDK count];
    
    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
      [jive1 content:testContent likes:TRUE onComplete:^{
            finishBlock2();
      } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
      }];
    }];
    
        
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive2 contentLikedBy:testContent withOptions:options onComplete:^(NSArray *results) {
            returnedLikesListFromSDK2 = results;
            
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    
    NSUInteger likeCountAfter = [returnedLikesListFromSDK2 count];
         
    STAssertEquals(likeCountAfter, likeCountBefore + 1, @"Expecting same results from SDK and v3 API for likes count on this document!");
    
}

*/

@end
