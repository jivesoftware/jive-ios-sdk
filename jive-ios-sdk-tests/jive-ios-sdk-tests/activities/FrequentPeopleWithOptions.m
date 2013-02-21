//
//  FrequentPeopleWithOptions.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 2/14/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"


@interface FrequentPeopleWithOptions : JiveTestCase

@end

@implementation FrequentPeopleWithOptions


- (void) testGetFrequentPeopleWithOptions {

    JiveCountRequestOptions* jiveCountRequestOptions = [[JiveCountRequestOptions alloc] init];
    jiveCountRequestOptions.count = 20;
    
    __block NSArray *frequentPeopleList = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 frequentPeopleWithOptions:jiveCountRequestOptions onComplete:^(NSArray *persons) {
            frequentPeopleList = persons;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
    // Make API call
    // Get the frequent People count for the user
    
    NSString* frequentPeopleAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/activities/frequent/people?count=20";
    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:frequentPeopleAPIURL];
    NSArray* returnedFrequentPeopleListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger returnedFrequentPeopleCountFromAPI = [returnedFrequentPeopleListFromAPI count];
    
    STAssertEquals(returnedFrequentPeopleCountFromAPI, [frequentPeopleList count], @"Expecting same results from SDK and v3 API for frequent People count on this document!");
    
}

@end
