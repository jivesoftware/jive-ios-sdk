//
//  ContentMarkAsRead.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//


#import "JiveTestCase.h"


@interface ContentMarkAsRead : JiveTestCase

@end

@implementation ContentMarkAsRead

- (void) testContentMarkAsRead_Unread {
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    
    __block NSArray *returnedContentsList = nil;
    
    NSString* docSubject = @"Document For MarkAsRead Test Automation";
    
    [searchOptions addSearchTerm:docSubject];
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
        if ([aContent.subject isEqualToString:docSubject]) {
            testContent = aContent;
        }
    }

    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive2 content:testContent markAsRead:TRUE onComplete:^{
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive2 content:testContent markAsRead:FALSE onComplete:^{
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
}

@end
