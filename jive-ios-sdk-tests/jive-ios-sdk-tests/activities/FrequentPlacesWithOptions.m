//
//  FrequentPlacesWithOptions.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 2/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"


@interface FrequentPlacesWithOptions : JiveTestCase

@end

@implementation FrequentPlacesWithOptions


- (void) testGetFrequentPlacesWithOptions {
    
    JiveCountRequestOptions* jiveCountRequestOptions = [[JiveCountRequestOptions alloc] init];
    jiveCountRequestOptions.count = 20;
    
    __block NSArray *frequentPlacesList = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 frequentPlacesWithOptions:jiveCountRequestOptions onComplete:^(NSArray *persons) {
            
            frequentPlacesList = persons;
           
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    // Make API call
    // Get the frequent places count for the user
    
    /*
    NSString* frequentPlacesAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/activities/frequent/places?count=20";    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:frequentPlacesAPIURL];
    */
    
    NSString* frequentPlacesAPIURL =[ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/activities/frequent/places?count=20"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:frequentPlacesAPIURL];
    
    NSArray* returnedFrequentPlacesListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger returnedFrequentPlacesCountFromAPI = [returnedFrequentPlacesListFromAPI count];
    
    STAssertEquals(returnedFrequentPlacesCountFromAPI, [frequentPlacesList count], @"Expecting same results from SDK and v3 API for Frequent places count on this document!");
    
    
}

@end
