//
//  CommentsForContent.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/23/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
