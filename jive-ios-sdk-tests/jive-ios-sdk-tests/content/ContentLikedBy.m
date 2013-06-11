//
//  ContentLikedBy.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/23/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
       
    
    NSString* contentURL = [testContent.selfRef absoluteString];
    
    
    // Make API call
    // Get the likes count for the doc
    
    NSString* likesForContentAPIURL = [contentURL stringByAppendingString:@"/likes"];
    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:likesForContentAPIURL];
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
