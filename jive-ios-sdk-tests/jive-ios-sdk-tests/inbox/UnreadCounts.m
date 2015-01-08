//
//  UnreadCounts.m
//  jive-ios-sdk-tests
//
//  Created by Sherry Zhou on 5/30/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveTestCase.h"
#import "JVUtilities.h"

@interface UnreadCounts : JiveTestCase

@end

@implementation UnreadCounts

- (void) testMarkInboxEntries {
   
    // Get unread counts from API
    NSString* inboxCountsAPIURL = [ NSString stringWithFormat:@"%@%@", server, @"/api/core/v3/inbox/counts"];
    id jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:inboxCountsAPIURL];
    NSNumber* inboxUnreadCountsFromAPI =   (NSNumber*) [jsonResponseFromAPI objectForKey:@"unread"];
    
    // Get unread counts from SDK
    __block NSArray *returnedInboxEntries = nil;
    __block NSNumber *unreadCountFromSDKBefore = nil;
    __block NSNumber *unreadCountFromSDKAfter = nil;
    JiveInboxOptions *inboxOptions = [JiveInboxOptions new];
    inboxOptions.unread = YES;
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [jive1 inboxWithUnreadCount:inboxOptions
                         onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                      NSDate *latestDate, NSNumber *unreadCount) {
                             returnedInboxEntries = inboxEntries;
                             unreadCountFromSDKBefore = unreadCount;
                             finishedBlock();
                         } onError:^(NSError *error) {
                             STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                         }];
    });
    
    //Verify unread counts from SDK should match core api's
    STAssertEquals([ unreadCountFromSDKBefore integerValue] , [inboxUnreadCountsFromAPI integerValue] , @"Expecting unread count match");
    
    //Mark first unread entry as read
    NSArray *markingInboxEntries = @[[returnedInboxEntries objectAtIndex:0]];
    
    __block BOOL completeBlockCalled = NO;
    waitForTimeout(^(void (^finishedBlock2)(void)) {
        [jive1 markInboxEntries:markingInboxEntries
                        asRead:YES
                    onComplete:^{
                        completeBlockCalled = YES;
                        finishedBlock2();
                    }
                    onError:^(NSError *error) {
                           STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                    }];
    });
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [jive1 inboxWithUnreadCount:nil
                         onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                      NSDate *latestDate, NSNumber *unreadCount) {
                             returnedInboxEntries = inboxEntries;
                             unreadCountFromSDKAfter = unreadCount;
                             finishedBlock();
                         } onError:^(NSError *error) {
                             STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                         }];
    });
    
    //Verify unread counts should be decreased by 1
    if ([unreadCountFromSDKAfter integerValue] <= 50 )
        STAssertEquals([unreadCountFromSDKAfter integerValue] , [unreadCountFromSDKBefore integerValue]-1 , @"Expecting unread count decreased by 1 after mark unread message to read ");
    
    // Get unread counts from API
    jsonResponseFromAPI = [JVUtilities getAPIJsonResponse:userid1 pw:pw1 URL:inboxCountsAPIURL];
    inboxUnreadCountsFromAPI =   (NSNumber*) [jsonResponseFromAPI objectForKey:@"unread"];

    NSLog(@"after API unread %@",inboxUnreadCountsFromAPI );
    STAssertEquals([unreadCountFromSDKAfter integerValue] , [inboxUnreadCountsFromAPI integerValue] , @"Expecting unread count from SDK matches api's ");
    
    //Mark the same inbox entry to unread
    waitForTimeout(^(void (^finishedBlock3)(void)) {
        [jive1 markInboxEntries:markingInboxEntries
                         asRead:NO
                     onComplete:^{
                         completeBlockCalled = YES;
                         finishedBlock3();
                     }
                        onError:^(NSError *error) {
                            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                        }];
    });
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [jive1 inboxWithUnreadCount:nil
                         onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                      NSDate *latestDate, NSNumber *unreadCount) {
                             returnedInboxEntries = inboxEntries;
                             unreadCountFromSDKAfter = unreadCount;
                             finishedBlock();
                         } onError:^(NSError *error) {
                             STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                         }];
    });
    
    //Verify unread counts increased by 1
    if ([unreadCountFromSDKAfter integerValue] <= 50 )
        STAssertEquals([unreadCountFromSDKAfter integerValue] , [unreadCountFromSDKBefore integerValue] , @"Expecting unread count increased by 1 after mark a read message to unread");

}


@end
