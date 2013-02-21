//
//  SearchContents.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 1/29/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"

@interface SearchContents : JiveTestCase

@end


@implementation SearchContents

- (void) testSearchByKeywordOnly {
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    
    [searchOptions addSearchTerm:@"ios-sdk"];
    [self waitForTimeout:^(dispatch_block_t finishBlock) {
        [jive1 searchContents:searchOptions onComplete:^(NSArray *results) {
          finishBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock();
        }];
    }];
}


- (void) testSearchByKeywordAndCreatedAfter {
    
    JiveSearchContentsRequestOptions *searchOptions = [[JiveSearchContentsRequestOptions alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
 
    
    NSDate* dateSDK = [dateFormat dateFromString:@"2013-12-01T23:13:29.851+0000"];
    
    [searchOptions addSearchTerm:@"ios-sdk"];
    
    searchOptions.after = dateSDK;
    
    
    [self waitForTimeout:^(dispatch_block_t finishBlock2) {
        [jive1 searchContents:searchOptions onComplete:^(NSArray *results) {
            finishBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock2();
        }];
    }];
}


@end
