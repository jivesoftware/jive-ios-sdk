//
//  RecentContentWithOptions.m
//  jive-ios-sdk-tests
//
//  Created by Shivkumar Krishnan on 2/19/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface RecentContentWithOptions : JiveTestCase

@end

@implementation RecentContentWithOptions


- (void) testGetRecentContentWithOptions {
    
    JiveCountRequestOptions* jiveCountRequestOptions = [[JiveCountRequestOptions alloc] init];
    jiveCountRequestOptions.count = 20;
    
    __block NSArray *recentContentList = nil;
    
    [self waitForTimeout:^(dispatch_block_t finishBlock3) {
        [jive1 recentContentWithOptions:jiveCountRequestOptions onComplete:^(NSArray *contents) {
            
            recentContentList = contents;
            finishBlock3();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishBlock3();
        }];
    }];
    
    
    // Make API call
    // Get the recent content count for the user
    
    NSString* recentContentAPIURL = @"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/activities/recent/content?count=20";
    
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:@"ios-sdk-testuser1" pw:@"test123" URL:recentContentAPIURL];
    NSArray* returnedRecentContentListFromAPI = [jsonResponseFromAPI objectForKey:@"list"];
    NSUInteger returnedRecentContentCountFromAPI = [returnedRecentContentListFromAPI count];
    
    STAssertEquals(returnedRecentContentCountFromAPI, [recentContentList count], @"Expecting same results from SDK and v3 API for recent Content count on this document!");
 
    
    NSUInteger i = 0;
    
    for (JiveContent* jiveContentFromSDK in recentContentList) {
        
        NSString* aContentSubjectFromSDK = jiveContentFromSDK.subject;
        
        id jiveContentFromAPI = [returnedRecentContentListFromAPI objectAtIndex:i];
        
        NSString* aContentSubjectFromAPI = [JVUtilities get_Content_subject:jiveContentFromAPI];
        
        STAssertEqualObjects(aContentSubjectFromSDK, aContentSubjectFromAPI, @"Expecting same results from SDK and v3 API for recent content for this user!");
        
        i++;
        
    }

}

@end
