//
//  jive_api_tests.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "jive_api_tests.h"

#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>

#import "JiveHTTPBasicAuthCredentials.h"
#import "JiveTargetList_internal.h"
#import "JiveAssociationTargetList_internal.h"
#import "JAPIRequestOperation.h"
#import "MockJiveURLProtocol.h"

#import "OCMockObject+MockJiveURLResponseDelegate.h"
#import "NSError+Jive.h"
#import "JiveMetadata_internal.h"
#import "Jive_internal.h"

@implementation jive_api_tests

- (void)tearDown {
    jive = nil;
    mockAuthDelegate = nil;
    mockJiveURLResponseDelegate = nil;
    mockJiveURLResponseDelegate2 = nil;
    
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:nil];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:nil];
    
    [super tearDown];
}

- (NSURL *)testURL {
    if (!_testURL) {
        _testURL = [NSURL URLWithString:@"https://brewspace.jiveland.com/"];
    }
    
    return _testURL;
}

// Create the Jive API object, using mock auth delegate
- (Jive *)createJiveAPIObjectWithResponse:(NSString *)resourceName andAuthDelegate:(id)authDelegate {
    // Reponse file containing data from JIVE My request
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:resourceName ofType:@"json"];
    
    // Mock response delegate
    mockJiveURLResponseDelegate = [self mockJiveURLDelegate:self.testURL returningContentsOfFile:contentPath];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    jive = [[Jive alloc] initWithJiveInstance:self.testURL authorizationDelegate:authDelegate];
    return jive;
}

// Create the Jive API object with a generic mock auth delegate
- (Jive *)createJiveAPIObjectWithResponse:(NSString *)resourceName {
    
    mockAuthDelegate = [self mockJiveAuthenticationDelegate];
    return [self createJiveAPIObjectWithResponse:resourceName andAuthDelegate:mockAuthDelegate];
}

- (Jive *)createJiveAPIObjectWithResponse:(NSString *)resourceName
                  andAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    JiveHTTPBasicAuthCredentials *authCredentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                                  password:@"foo"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:authCredentials] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:authCredentials] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    return [self createJiveAPIObjectWithResponse:resourceName andAuthDelegate:mockAuthDelegate];
}

- (void)createJiveAPIObjectWithErrorCode:(NSInteger)errorCode
                 andAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.testURL
                                                              statusCode:errorCode
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{@"Content-Type":@"application/json"}];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    [[[mockJiveURLResponseDelegate expect] andReturn:nil] responseBodyForRequest];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    jive = [[Jive alloc] initWithJiveInstance:self.testURL authorizationDelegate:mockAuthDelegate];
}

- (void)createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.testURL
                                                              statusCode:500
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{@"Content-Type":@"application/json",
                                                                           @"X-JIVE-TC":@"/api/core/v3/people/@me/termsAndConditions"}];
    NSString *responseText = @"<html><head><title>Apache Tomcat - Error report</title><style><!--H1 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:22px;} H2 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:16px;} H3 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:14px;} BODY {font-family:Tahoma,Arial,sans-serif;color:black;background-color:white;} B {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;} P {font-family:Tahoma,Arial,sans-serif;background:white;color:black;font-size:12px;}A {color : black;}A.name {color : black;}HR {color : #525D76;}--></style> </head><body><h1>HTTP Status 451 - Unavailable For Legal Reasons</h1><HR size=\"1\" noshade=\"noshade\"><p><b>type</b> Status report</p><p><b>message</b> <u>Unavailable For Legal Reasons</u></p><p><b>description</b> <u>No description available</u></p><HR size=\"1\" noshade=\"noshade\"><h3>Apache Tomcat</h3></body></html>";
    NSData *responseBody = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    [[[mockJiveURLResponseDelegate expect] andReturn:responseBody] responseBodyForRequest];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    jive = [[Jive alloc] initWithJiveInstance:self.testURL authorizationDelegate:mockAuthDelegate];
}

- (void) testJiveInstance {
    
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    
    NSString* originalJiveInstance = @"https://brewspace.jiveland.com";
    
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:originalJiveInstance]
                        authorizationDelegate:mockAuthDelegate];
    
    NSURL* configuredJiveInstance = [jive jiveInstanceURL];
    
    STAssertNotNil(configuredJiveInstance, @"jiveInstance URL should never be nil");
    STAssertEqualObjects([configuredJiveInstance absoluteString], originalJiveInstance,
                         @"Configured URL does not match original URL");
    STAssertNil(jive.platformVersion, @"Platform version should not exist");
}

- (void) testInbox {
    [self createJiveAPIObjectWithResponse:@"unread_inbox_response"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inboxWithUnreadCount:nil
                        onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                     NSDate *latestDate, NSNumber *unreadCount) {
                            NSUInteger expectedCount = 103;
                            STAssertNotNil(inboxEntries, @"InboxEntries where nil!");
                            STAssertEquals(inboxEntries.count, expectedCount, @"Incorrect number of inbox entries where returned");
                            STAssertEqualObjects(earliestDate.description, @"2013-09-10 15:04:49 +0000", @"Wrong earliest date.");
                            STAssertEqualObjects(latestDate.description, @"2013-11-27 19:18:27 +0000", @"Wrong latest date.");
                            STAssertEqualObjects(unreadCount, @49, @"Wrong number of unread items");
                            
                            // Check that delegates where actually called
                            [mockAuthDelegate verify];
                            [mockJiveURLResponseDelegate verify];
                            
                            finishedBlock();
                        } onError:^(NSError *error) {
                            finishedBlock();
                        }];
    }];
}

- (void) testInbox_clearsBadInstanceURL {
    self.testURL = [NSURL URLWithString:@"https://hopback.eng.jiveland.com/"];
    [self createJiveAPIObjectWithResponse:@"unread_inbox_response"];
    jive.badInstanceURL = @"brewspace";
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inboxWithUnreadCount:nil
                        onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                     NSDate *latestDate, NSNumber *unreadCount) {
                            NSUInteger expectedCount = 103;
                            STAssertNotNil(inboxEntries, @"InboxEntries where nil!");
                            STAssertEquals(inboxEntries.count, expectedCount, @"Incorrect number of inbox entries where returned");
                            STAssertEqualObjects(earliestDate.description, @"2013-09-10 15:04:49 +0000", @"Wrong earliest date.");
                            STAssertEqualObjects(latestDate.description, @"2013-11-27 19:18:27 +0000", @"Wrong latest date.");
                            STAssertEqualObjects(unreadCount, @49, @"Wrong number of unread items");
                            STAssertNil(jive.badInstanceURL, @"badInstanceURL was not cleared: %@", jive.badInstanceURL);
                            
                            // Check that delegates where actually called
                            [mockAuthDelegate verify];
                            [mockJiveURLResponseDelegate verify];
                            
                            finishedBlock();
                        } onError:^(NSError *error) {
                            finishedBlock();
                        }];
    }];
}

- (void) testInboxOperation {
    [self createJiveAPIObjectWithResponse:@"inbox_response"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        NSOperation *operation = [jive inboxWithUnreadCountOperation:nil
                                                          onComplete:^(NSArray *inboxEntries,
                                                                       NSDate *earliestDate,
                                                                       NSDate *latestDate,
                                                                       NSNumber *unreadCount) {
                                                              NSUInteger expectedCount = 28;
                                                              STAssertNotNil(inboxEntries, @"InboxEntries where nil!");
                                                              STAssertEquals(inboxEntries.count, expectedCount, @"Incorrect number of inbox entries where returned");
                                                              STAssertEqualObjects(earliestDate.description, @"2012-10-23 03:26:37 +0000", @"Wrong earliest date.");
                                                              STAssertEqualObjects(latestDate.description, @"2012-10-24 19:06:10 +0000", @"Wrong latest date.");
                                                              STAssertEqualObjects(unreadCount, @0, @"Wrong number of unread items");
                                                              
                                                              // Check that delegates where actually called
                                                              [mockAuthDelegate verify];
                                                              [mockJiveURLResponseDelegate verify];
                                                              
                                                              finishedBlock();
                                                          } onError:^(NSError *error) {
                                                              finishedBlock();
                                                          }];
        
        [operation start];
    }];
}

- (void) testInboxOperation_resetsBadInstanceURL {
    [self createJiveAPIObjectWithResponse:@"inbox_response"];
    
    NSString *badInstanceURL = @"bad instance url";
    NSString *reportedInstanceURL = self.testURL.absoluteString;
    
    jive.badInstanceURL = badInstanceURL;
    jive.jiveInstanceURL = [NSURL URLWithString:@"https://proxy.com"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        NSOperation *operation = [jive inboxWithUnreadCountOperation:nil
                                                          onComplete:^(NSArray *inboxEntries,
                                                                       NSDate *earliestDate,
                                                                       NSDate *latestDate,
                                                                       NSNumber *unreadCount) {
                                                              NSUInteger expectedCount = 28;
                                                              STAssertNotNil(inboxEntries, @"InboxEntries where nil!");
                                                              STAssertEquals(inboxEntries.count, expectedCount, @"Incorrect number of inbox entries where returned");
                                                              STAssertEqualObjects(earliestDate.description, @"2012-10-23 03:26:37 +0000", @"Wrong earliest date.");
                                                              STAssertEqualObjects(latestDate.description, @"2012-10-24 19:06:10 +0000", @"Wrong latest date.");
                                                              STAssertEqualObjects(unreadCount, @0, @"Wrong number of unread items");
                                                              STAssertEqualObjects(jive.badInstanceURL, reportedInstanceURL, @"badInstanceURL not updated.");
                                                              
                                                              // Check that delegates where actually called
                                                              [mockAuthDelegate verify];
                                                              [mockJiveURLResponseDelegate verify];
                                                              
                                                              finishedBlock();
                                                          } onError:^(NSError *error) {
                                                              finishedBlock();
                                                          }];
        
        [operation start];
    }];
}

- (void) testMarkAsReadWithTwoUnread {
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                        authorizationDelegate:mockAuthDelegate];
    mockJiveURLResponseDelegate2 = [OCMockObject mockJiveURLResponseDelegate2];
    [mockJiveURLResponseDelegate2 expectResponseWithContentsOfJSONFileNamed:@"inbox_mark_response"
                                                       bundledWithTestClass:[self class]
                                                          forRequestWithURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/inbox"]];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:mockJiveURLResponseDelegate2];
    
    __block NSArray *returnedInboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inboxWithUnreadCount:nil
                        onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                     NSDate *latestDate, NSNumber *unreadCount) {
                            returnedInboxEntries = inboxEntries;
                            finishedBlock();
                        } onError:^(NSError *error) {
                            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
                                     [returnedInboxEntries objectAtIndex:1],
                                     [returnedInboxEntries objectAtIndex:11],
                                     ];
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.POST
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/contents/370230/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.POST
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/contents/370293/read"]];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive markInboxEntries:markingInboxEntries
                        asRead:YES
                    onComplete:finishedBlock
                       onError:^(NSError *error) {
                           STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                       }];
    }];
    
    [mockJiveURLResponseDelegate2 verify];
}

- (void) testMarkAsReadWithOneReadOneUnread {
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                        authorizationDelegate:mockAuthDelegate];
    mockJiveURLResponseDelegate2 = [OCMockObject mockJiveURLResponseDelegate2];
    [mockJiveURLResponseDelegate2 expectResponseWithContentsOfJSONFileNamed:@"inbox_mark_response"
                                                       bundledWithTestClass:[self class]
                                                          forRequestWithURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/inbox"]];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:mockJiveURLResponseDelegate2];
    
    __block NSArray *returnedInboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inboxWithUnreadCount:nil
                        onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                     NSDate *latestDate, NSNumber *unreadCount) {
                            returnedInboxEntries = inboxEntries;
                            finishedBlock();
                        } onError:^(NSError *error) {
                            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
                                     [returnedInboxEntries objectAtIndex:0],
                                     [returnedInboxEntries objectAtIndex:1],
                                     ];
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.POST
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/dms/153160/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.POST
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/contents/370230/read"]];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive markInboxEntries:markingInboxEntries
                        asRead:YES
                    onComplete:finishedBlock
                       onError:^(NSError *error) {
                           STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                       }];
    }];
    
    [mockJiveURLResponseDelegate2 verify];
}

- (void) testMarkAsUnreadWithOneReadOneUnread {
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                        authorizationDelegate:mockAuthDelegate];
    mockJiveURLResponseDelegate2 = [OCMockObject mockJiveURLResponseDelegate2];
    [mockJiveURLResponseDelegate2 expectResponseWithContentsOfJSONFileNamed:@"inbox_mark_response"
                                                       bundledWithTestClass:[self class]
                                                          forRequestWithURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/inbox"]];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:mockJiveURLResponseDelegate2];
    
    __block NSArray *returnedInboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inboxWithUnreadCount:nil
                        onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                     NSDate *latestDate, NSNumber *unreadCount) {
                            returnedInboxEntries = inboxEntries;
                            finishedBlock();
                        } onError:^(NSError *error) {
                            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
                                     [returnedInboxEntries objectAtIndex:0],
                                     [returnedInboxEntries objectAtIndex:1],
                                     ];
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.DELETE
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/dms/153160/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.DELETE
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/contents/370230/read"]];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive markInboxEntries:markingInboxEntries
                        asRead:NO
                    onComplete:finishedBlock
                       onError:^(NSError *error) {
                           STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                       }];
    }];
    
    [mockJiveURLResponseDelegate2 verify];
}

- (void) testMarkAsUnreadWithTwoRead {
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                        authorizationDelegate:mockAuthDelegate];
    mockJiveURLResponseDelegate2 = [OCMockObject mockJiveURLResponseDelegate2];
    [mockJiveURLResponseDelegate2 expectResponseWithContentsOfJSONFileNamed:@"inbox_mark_response"
                                                       bundledWithTestClass:[self class]
                                                          forRequestWithURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/inbox"]];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:mockJiveURLResponseDelegate2];
    
    __block NSArray *returnedInboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inboxWithUnreadCount:nil
                        onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                     NSDate *latestDate, NSNumber *unreadCount) {
                            returnedInboxEntries = inboxEntries;
                            finishedBlock();
                        } onError:^(NSError *error) {
                            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
                                     [returnedInboxEntries objectAtIndex:0],
                                     [returnedInboxEntries objectAtIndex:8],
                                     ];
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.DELETE
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/dms/153160/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.DELETE
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/contents/370230/read"]];
    
    __block BOOL completeBlockCalled = NO;
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive markInboxEntries:markingInboxEntries
                        asRead:NO
                    onComplete:^{
                        completeBlockCalled = YES;
                        finishedBlock();
                    }
                       onError:^(NSError *error) {
                           STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                       }];
    }];
    
    STAssertTrue(completeBlockCalled, nil);
    
    [mockJiveURLResponseDelegate2 verify];
}

- (void)testMarkAsReadWithTwoEqualUnreadURLsOnlySendsOneRequest {
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                        authorizationDelegate:mockAuthDelegate];
    mockJiveURLResponseDelegate2 = [OCMockObject mockJiveURLResponseDelegate2];
    [mockJiveURLResponseDelegate2 expectResponseWithContentsOfJSONFileNamed:@"inbox_mark_response"
                                                       bundledWithTestClass:[self class]
                                                          forRequestWithURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/inbox"]];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:mockJiveURLResponseDelegate2];
    
    __block NSArray *returnedInboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inboxWithUnreadCount:nil
                        onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                     NSDate *latestDate, NSNumber *unreadCount) {
                            returnedInboxEntries = inboxEntries;
                            finishedBlock();
                        } onError:^(NSError *error) {
                            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
                                     [returnedInboxEntries objectAtIndex:1],
                                     [returnedInboxEntries objectAtIndex:2],
                                     ];
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.POST
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/contents/370230/read"]];
    
    __block BOOL completeBlockCalled = NO;
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive markInboxEntries:markingInboxEntries
                        asRead:YES
                    onComplete:^{
                        completeBlockCalled = YES;
                        finishedBlock();
                    }
                       onError:^(NSError *error) {
                           STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                       }];
    }];
    
    STAssertTrue(completeBlockCalled, nil);
    
    [mockJiveURLResponseDelegate2 verify];
}

- (void) testOneErrorAndOneSuccessWithTwoMarksCallsErrorCallback {
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                        authorizationDelegate:mockAuthDelegate];
    mockJiveURLResponseDelegate2 = [OCMockObject mockJiveURLResponseDelegate2];
    [mockJiveURLResponseDelegate2 expectResponseWithContentsOfJSONFileNamed:@"inbox_mark_response"
                                                       bundledWithTestClass:[self class]
                                                          forRequestWithURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/inbox"]];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:mockJiveURLResponseDelegate2];
    
    __block NSArray *returnedInboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inboxWithUnreadCount:nil
                        onComplete:^(NSArray *inboxEntries, NSDate *earliestDate,
                                     NSDate *latestDate, NSNumber *unreadCount) {
                            returnedInboxEntries = inboxEntries;
                            finishedBlock();
                        } onError:^(NSError *error) {
                            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
                        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
                                     [returnedInboxEntries objectAtIndex:0],
                                     [returnedInboxEntries objectAtIndex:8],
                                     ];
    
    NSError *fakeError = [NSError jive_errorWithMultipleErrors:@[]];
    [mockJiveURLResponseDelegate2 expectError:fakeError
                     forRequestWithHTTPMethod:JiveHTTPMethodTypes.DELETE
                                       forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/dms/153160/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:JiveHTTPMethodTypes.DELETE
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/contents/370230/read"]];
    
    __block BOOL errorBlockCalled = NO;
    __block NSError *errorBlockError = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive markInboxEntries:markingInboxEntries
                        asRead:NO
                    onComplete:^{
                        STFail(@"Unexpected onComplete");
                    }
                       onError:^(NSError *error) {
                           errorBlockCalled = YES;
                           errorBlockError = error;
                           finishedBlock();
                       }];
    }];
    
    STAssertTrue(errorBlockCalled, nil);
    STAssertNotNil(errorBlockError, nil);
    
    [mockJiveURLResponseDelegate2 verify];
}

- (void)checkObjectOperation:(NSOperation *(^)(JiveObjectCompleteBlock completionBlock,
                                               JiveErrorBlock errorBlock))createOperation
                withResponse:(NSString *)response
                         URL:(NSString *)url
               expectedClass:(Class)clazz
                    complete:(JiveArrayCompleteBlock)completeBlock {
    
    void (^createMockAuthDelegate)(NSString *expectedURL) = ^(NSString *expectedURL) {
        mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
        [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
            BOOL same = [expectedURL isEqualToString:[value absoluteString]];
            return same;
        }]];
        [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
            BOOL same = [expectedURL isEqualToString:[value absoluteString]];
            return same;
        }]];
    };
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        createMockAuthDelegate(url);
        [self createJiveAPIObjectWithResponse:response andAuthDelegate:mockAuthDelegate];
        AFURLConnectionOperation *operation = (AFURLConnectionOperation *)createOperation(^(id object) {
            completeBlock(object);
            finishedBlock();
        },
                                                                                          ^(NSError *error) {
                                                                                              STFail([error localizedDescription]);
                                                                                              finishedBlock();
                                                                                          });
        
        STAssertNotNil(operation, @"Missing operation object");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"X-JIVE-TC-SUPPORT"],
                             @"true",
                             @"Wrong terms and conditions flag");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        createMockAuthDelegate(url);
        [self createJiveAPIObjectWithResponse:response andAuthDelegate:mockAuthDelegate];
        jive.badInstanceURL = @"brewspace";
        NSOperation* operation = createOperation(^(id object) {
            STAssertNil(jive.badInstanceURL, @"badInstanceURL was not cleared: %@", jive.badInstanceURL);
            completeBlock(object);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing clear bad instance check operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSInteger error_code = 404;
        [self createJiveAPIObjectWithErrorCode:error_code andAuthDelegateURLCheck:url];
        NSOperation *operation = createOperation(^(id object) {
            STFail(@"404 errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STAssertEquals([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    error_code,
                                                                    @"Wrong error reported");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:url];
        NSOperation *operation = createOperation(^(id object) {
            STFail(@"Terms and Conditions errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STAssertEquals([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    0,
                                                                    @"Wrong error reported");
                                                     STAssertEqualObjects(error.userInfo[JiveErrorKeyTermsAndConditionsAPI],
                                                                          @"/api/core/v3/people/@me/termsAndConditions",
                                                                          @"Wrong terms and conditions api");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSString *proxyInstanceURL = ([self.testURL.absoluteString hasSuffix:@"/"] ?
                                      @"http://brewspace.com/" :
                                      @"http://brewspace.com");
        NSString *instanceURLString = [url stringByReplacingOccurrencesOfString:self.testURL.absoluteString
                                                                     withString:proxyInstanceURL];
        
        self.testURL = [NSURL URLWithString:proxyInstanceURL];
        createMockAuthDelegate(instanceURLString);
        [self createJiveAPIObjectWithResponse:response andAuthDelegate:mockAuthDelegate];
        STAssertNil(jive.badInstanceURL, @"PRECONDITION: badInstanceURL should be nil to start.");
        NSOperation* operation = createOperation(^(id object) {
            STAssertNotNil(jive.badInstanceURL, @"badInstanceURL not updated: %@", jive.badInstanceURL);
            completeBlock(object);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing bad instance check operation object");
        [operation start];
    }];
}

- (void)checkObjectOperation:(NSOperation *(^)(JiveObjectCompleteBlock completionBlock,
                                               JiveErrorBlock errorBlock))createOperation
                withResponse:(NSString *)response
                         URL:(NSString *)url
               expectedClass:(Class)clazz {
    [self checkObjectOperation:createOperation
                  withResponse:response
                           URL:url
                 expectedClass:clazz
                      complete:^(id object) {
                          STAssertTrue([[object class] isSubclassOfClass:clazz], @"Wrong item class");
                          
                          // Check that delegates where actually called
                          [mockAuthDelegate verify];
                          [mockJiveURLResponseDelegate verify];
                      }];
}

- (void)checkPersonObjectOperation:(NSOperation *(^)(JiveObjectCompleteBlock completionBlock,
                                                     JiveErrorBlock errorBlock))createOperation
                      withResponse:(NSString *)response
                               URL:(NSString *)url {
    Class clazz = [JivePerson class];
    [self checkObjectOperation:createOperation
                  withResponse:response
                           URL:url
                 expectedClass:clazz
                      complete:^(id object) {
                          STAssertEquals([object class], clazz, @"Wrong item class");
                          
                          JivePerson *person = (JivePerson *)object;
                          STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
                          
                          // Check that delegates where actually called
                          [mockAuthDelegate verify];
                          [mockJiveURLResponseDelegate verify];
                      }];
}

- (void) testMyOperation {
    [self checkPersonObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive meOperation:completionBlock onError:errorBlock];
    }
                        withResponse:@"my_response"
                                 URL:@"https://brewspace.jiveland.com/api/core/v3/people/@me"];
}

- (void) testMyServiceCall {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@me" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@me" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"my_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive me:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void)checkListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                             JiveErrorBlock errorBlock))createOperation
              withResponse:(NSString *)response
                       URL:(NSString *)url
             expectedCount:(NSUInteger)expectedCount
             expectedClass:(Class)clazz
                  complete:(JiveArrayCompleteBlock)completeBlock {
    
    void (^createMockAuthDelegate)(NSString *expectedURL) = ^(NSString *expectedURL) {
        mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
        [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
            BOOL same = [expectedURL isEqualToString:[value absoluteString]];
            return same;
        }]];
        [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
            BOOL same = [expectedURL isEqualToString:[value absoluteString]];
            return same;
        }]];
    };
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        createMockAuthDelegate(url);
        [self createJiveAPIObjectWithResponse:response andAuthDelegate:mockAuthDelegate];
        AFURLConnectionOperation *operation = (AFURLConnectionOperation *)createOperation(^(NSArray *streams) {
            completeBlock(streams);
            finishedBlock();
        },
                                                                                          ^(NSError *error) {
                                                                                              STFail([error localizedDescription]);
                                                                                              finishedBlock();
                                                                                          });
        
        STAssertNotNil(operation, @"Missing operation object");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"X-JIVE-TC-SUPPORT"],
                             @"true",
                             @"Wrong terms and conditions flag");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        createMockAuthDelegate(url);
        [self createJiveAPIObjectWithResponse:response andAuthDelegate:mockAuthDelegate];
        jive.badInstanceURL = @"brewspace";
        NSOperation* operation = createOperation(^(NSArray *streams) {
            STAssertNil(jive.badInstanceURL, @"badInstanceURL was not cleared: %@", jive.badInstanceURL);
            completeBlock(streams);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing clear bad instance check operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSInteger error_code = 404;
        [self createJiveAPIObjectWithErrorCode:error_code andAuthDelegateURLCheck:url];
        NSOperation *operation = createOperation(^(NSArray *streams) {
            STFail(@"404 errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STAssertEquals([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    error_code,
                                                                    @"Wrong error reported");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:url];
        NSOperation *operation = createOperation(^(NSArray *streams) {
            STFail(@"Terms and Conditions errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STAssertEquals([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    0,
                                                                    @"Wrong error reported");
                                                     STAssertEqualObjects(error.userInfo[JiveErrorKeyTermsAndConditionsAPI],
                                                                          @"/api/core/v3/people/@me/termsAndConditions",
                                                                          @"Wrong terms and conditions api");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSString *proxyInstanceURL = ([self.testURL.absoluteString hasSuffix:@"/"] ?
                                      @"http://brewspace.com/" :
                                      @"http://brewspace.com");
        NSString *instanceURLString = [url stringByReplacingOccurrencesOfString:self.testURL.absoluteString
                                                                     withString:proxyInstanceURL];
        
        self.testURL = [NSURL URLWithString:proxyInstanceURL];
        createMockAuthDelegate(instanceURLString);
        [self createJiveAPIObjectWithResponse:response andAuthDelegate:mockAuthDelegate];
        STAssertNil(jive.badInstanceURL, @"PRECONDITION: badInstanceURL should be nil to start.");
        NSOperation* operation = createOperation(^(NSArray *streams) {
            STAssertNotNil(jive.badInstanceURL, @"badInstanceURL not updated.");
            completeBlock(streams);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing bad instance check operation object");
        [operation start];
    }];
}

- (void)checkListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                             JiveErrorBlock errorBlock))createOperation
              withResponse:(NSString *)response
                       URL:(NSString *)url
             expectedCount:(NSUInteger)expectedCount
             expectedClass:(Class)clazz {
    [self checkListOperation:createOperation
                withResponse:response
                         URL:url
               expectedCount:expectedCount
               expectedClass:clazz
                    complete:^(NSArray *collection) {
                        STAssertEquals([collection count], expectedCount, @"Wrong number of items parsed");
                        for (id collectionObject in collection) {
                            STAssertTrue([collectionObject isKindOfClass:clazz], @"Item %@ is not of class %@",
                                         collectionObject, clazz);
                        }
                        
                        // Check that delegates where actually called
                        [mockAuthDelegate verify];
                        [mockJiveURLResponseDelegate verify];
                    }];
}

- (void)checkPersonListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                                   JiveErrorBlock errorBlock))createOperation
                    withResponse:(NSString *)response
                             URL:(NSString *)url
                   expectedCount:(NSUInteger)expectedCount  {
    Class clazz = [JivePerson class];
    [self checkListOperation:createOperation
                withResponse:response
                         URL:url
               expectedCount:expectedCount
               expectedClass:clazz
                    complete:^(NSArray *collection) {
                        STAssertEquals([collection count], expectedCount, @"Wrong number of items parsed");
                        for (JivePerson *person in collection) {
                            STAssertTrue([person isKindOfClass:clazz], @"Item %@ is not of class %@",
                                         person, clazz);
                            STAssertEqualObjects(person.jiveInstance,
                                                 jive,
                                                 @"The person.jiveInstance was not initialized correctly");
                        }
                        
                        // Check that delegates where actually called
                        [mockAuthDelegate verify];
                        [mockJiveURLResponseDelegate verify];
                    }];
}

- (void) testColleguesOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    
    options.startIndex = 5;
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive colleguesOperation:source
                            withOptions:options
                             onComplete:completionBlock
                                onError:errorBlock];
    }
                      withResponse:@"collegues_response"
                               URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/@colleagues?startIndex=5"
                     expectedCount:9];
}

- (void) testColleguesServiceCall {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@colleagues?startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@colleagues?startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive collegues:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)9, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testFollowersOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive followersOperation:source
                             onComplete:completionBlock
                                onError:errorBlock];
    }
                      withResponse:@"followers_response"
                               URL:@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers"
                     expectedCount:23];
}

- (void) testFollowersServiceCall {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive followers:source onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testFollowersServiceCallUsesPersonID {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@followers" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@followers" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
        [jive followers:source onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testFollowersOperationWithOptions {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    options.count = 10;
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive followersOperation:source
                            withOptions:options
                             onComplete:completionBlock
                                onError:errorBlock];
    }
                      withResponse:@"followers_response"
                               URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/@followers?count=10&startIndex=10"
                     expectedCount:23];
}

- (void) testFollowersServiceCallWithOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 0;
    options.count = 5;
    [options addField:@"dummy"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers?fields=dummy&count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers?fields=dummy&count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive followers:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testFollowersServiceCallWithDifferentOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 6;
    options.count = 3;
    [options addField:@"dummy"];
    [options addField:@"second"];
    [options addField:@"third"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers?fields=dummy,second,third&count=3&startIndex=6" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers?fields=dummy,second,third&count=3&startIndex=6" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive followers:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testSearchPeopleRequestOperation {
    
    JiveSearchPeopleRequestOptions *options = [[JiveSearchPeopleRequestOptions alloc] init];
    NSString *instanceString = @"http://gigi-eae03.eng.jiveland.com";
    
    self.testURL = [NSURL URLWithString:instanceString];
    options.sort = JiveSortOrderUpdatedDesc;
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive searchPeopleRequestOperation:options
                                       onComplete:completionBlock
                                          onError:errorBlock];
    }
                      withResponse:@"search_people_response"
                               URL:[instanceString stringByAppendingString:@"/api/core/v3/search/people?sort=updatedDesc"]
                     expectedCount:13];
}

- (void) testSearchPeopleServiceCall {
    JiveSearchPeopleRequestOptions *options = [[JiveSearchPeopleRequestOptions alloc] init];
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/people?sort=updatedAsc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/people?sort=updatedAsc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive searchPeople:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)13, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testSearchPlacesRequestOperation {
    JiveSearchPlacesRequestOptions *options = [[JiveSearchPlacesRequestOptions alloc] init];
    NSString *instanceString = @"http://gigi-eae03.eng.jiveland.com";
    
    self.testURL = [NSURL URLWithString:instanceString];
    options.sort = JiveSortOrderUpdatedDesc;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive searchPlacesRequestOperation:options
                                       onComplete:completionBlock
                                          onError:errorBlock];
    }
                withResponse:@"search_places_response"
                         URL:[instanceString stringByAppendingString:@"/api/core/v3/search/places?sort=updatedDesc"]
               expectedCount:10
               expectedClass:[JivePlace class]];
}

- (void) testSearchPlacesServiceCall {
    JiveSearchPlacesRequestOptions *options = [[JiveSearchPlacesRequestOptions alloc] init];
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/places?sort=updatedAsc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/places?sort=updatedAsc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_places_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive searchPlaces:options onComplete:^(NSArray *places) {
            // Called 3rd
            STAssertEquals([places count], (NSUInteger)10, @"Wrong number of items parsed");
            STAssertTrue([[places objectAtIndex:0] isKindOfClass:[JivePlace class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testSearchContentsRequestOperation {
    JiveSearchContentsRequestOptions *options = [[JiveSearchContentsRequestOptions alloc] init];
    NSString *instanceString = @"http://gigi-eae03.eng.jiveland.com";
    
    self.testURL = [NSURL URLWithString:instanceString];
    options.sort = JiveSortOrderUpdatedDesc;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive searchContentsRequestOperation:options
                                         onComplete:completionBlock
                                            onError:errorBlock];
    }
                withResponse:@"search_contents_response"
                         URL:[instanceString stringByAppendingString:@"/api/core/v3/search/contents?sort=updatedDesc"]
               expectedCount:7
               expectedClass:[JiveContent class]];
}

- (void) testSearchContentsServiceCall {
    JiveSearchContentsRequestOptions *options = [[JiveSearchContentsRequestOptions alloc] init];
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/contents?sort=updatedAsc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/contents?sort=updatedAsc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_contents_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive searchContents:options onComplete:^(NSArray *contents) {
            // Called 3rd
            STAssertEquals([contents count], (NSUInteger)7, @"Wrong number of items parsed");
            STAssertTrue([[contents objectAtIndex:0] isKindOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPeopleOperation {
    JivePeopleRequestOptions *options = [[JivePeopleRequestOptions alloc] init];
    NSString *instanceString = @"http://gigi-eae03.eng.jiveland.com";
    
    self.testURL = [NSURL URLWithString:instanceString];
    options.sort = JiveSortOrderDateJoinedAsc;
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive peopleOperation:options
                          onComplete:completionBlock
                             onError:errorBlock];
    }
                      withResponse:@"people_response"
                               URL:[instanceString stringByAppendingString:@"/api/core/v3/people?sort=dateJoinedAsc"]
                     expectedCount:20];
}

- (void) testPeopleServiceCall {
    JivePeopleRequestOptions *options = [[JivePeopleRequestOptions alloc] init];
    options.sort = JiveSortOrderDateJoinedDesc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people?sort=dateJoinedDesc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people?sort=dateJoinedDesc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive people:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPersonOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkPersonObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive personOperation:source
                         withOptions:options
                          onComplete:completionBlock
                             onError:errorBlock];
    }
                        withResponse:@"person_response"
                                 URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550?fields=id"];
}

- (void) testPersonServiceCall {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive person:source withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testFilterableFieldsOperation {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@filterableFields" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@filterableFields" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"filterable_fields" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive filterableFieldsOperation:^(NSArray *fields) {
            // Called 3rd
            CFStringRef referenceString = CFStringCreateWithCString(nil, "a", kCFStringEncodingMacRoman); // Make a real CFStringRef not a CFConstStringRef
            STAssertEquals([fields count], (NSUInteger)6, @"Wrong number of items parsed");
            STAssertEquals([[fields objectAtIndex:0] class], [(__bridge NSString *)referenceString class], @"Wrong item class");
            CFRelease(referenceString);
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        [operation start];
    }];
}

- (void) testFilterableFields {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@filterableFields" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@filterableFields" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"filterable_fields" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive filterableFields:^(NSArray *fields) {
            // Called 3rd
            CFStringRef referenceString = CFStringCreateWithCString(nil, "a", kCFStringEncodingMacRoman); // Make a real CFStringRef not a CFConstStringRef
            STAssertEquals([fields count], (NSUInteger)6, @"Wrong number of items parsed");
            STAssertEquals([[fields objectAtIndex:0] class], [(__bridge NSString *)referenceString class], @"Wrong item class");
            CFRelease(referenceString);
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testSupportedFieldsOperation {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@supportedFields" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@supportedFields" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"supported_fields" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive supportedFieldsOperation:^(NSArray *fields) {
            // Called 3rd
            CFStringRef referenceString = CFStringCreateWithCString(nil, "a", kCFStringEncodingMacRoman); // Make a real CFStringRef not a CFConstStringRef
            STAssertEquals([fields count], (NSUInteger)18, @"Wrong number of items parsed");
            STAssertEquals([[fields objectAtIndex:0] class], [(__bridge NSString *)referenceString class], @"Wrong item class");
            CFRelease(referenceString);
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        [operation start];
    }];
}

- (void) testSupportedFields {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@supportedFields" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@supportedFields" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"supported_fields" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive supportedFields:^(NSArray *fields) {
            // Called 3rd
            CFStringRef referenceString = CFStringCreateWithCString(nil, "a", kCFStringEncodingMacRoman); // Make a real CFStringRef not a CFConstStringRef
            STAssertEquals([fields count], (NSUInteger)18, @"Wrong number of items parsed");
            STAssertEquals([[fields objectAtIndex:0] class], [(__bridge NSString *)referenceString class], @"Wrong item class");
            CFRelease(referenceString);
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPersonByEmailOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkPersonObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive personByEmailOperation:@"email_test"
                                withOptions:options
                                 onComplete:completionBlock
                                    onError:errorBlock];
    }
                        withResponse:@"person_response"
                                 URL:@"https://brewspace.jiveland.com/api/core/v3/people/email/email_test?fields=id"];
}

- (void) testPersonByEmail {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/email/test_email?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/email/test_email?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive personByEmail:@"test_email" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPersonByUserNameOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkPersonObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive personByUserNameOperation:@"Name"
                                   withOptions:options
                                    onComplete:completionBlock
                                       onError:errorBlock];
    }
                        withResponse:@"person_response"
                                 URL:@"https://brewspace.jiveland.com/api/core/v3/people/username/Name?fields=id"];
}

- (void) testPersonByUserName {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/username/UserName?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/username/UserName?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive personByUserName:@"UserName" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testRecommendedPeopleOperation {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    NSString *instanceString = @"http://gigi-eae03.eng.jiveland.com";
    
    self.testURL = [NSURL URLWithString:instanceString];
    options.count = 10;
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive recommendedPeopleOperation:options
                                     onComplete:completionBlock
                                        onError:errorBlock];
    }
                      withResponse:@"recommended_people"
                               URL:[instanceString stringByAppendingString:@"/api/core/v3/people/recommended?count=10"]
                     expectedCount:1];
}

- (void) testRecommendedPeople {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/recommended?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/recommended?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_people" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive recommendedPeople:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)1, @"Wrong number of items parsed");
            JivePerson *person = [people objectAtIndex:0];
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testResourcesOperation {
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive resourcesOperation:completionBlock onError:errorBlock];
    }
                withResponse:@"resource_info"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/@resources"
               expectedCount:19
               expectedClass:[JiveResource class]];
}

- (void) testResources {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@resources" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@resources" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"resource_info" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive resources:^(NSArray *resources) {
            // Called 3rd
            STAssertEquals([resources count], (NSUInteger)19, @"Wrong number of items parsed");
            STAssertEquals([[resources objectAtIndex:0] class], [JiveResource class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testTrendingPeopleOperation {
    JiveTrendingPeopleRequestOptions *options = [[JiveTrendingPeopleRequestOptions alloc] init];
    options.url = [NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/places/1234"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        if (![self.testURL isEqual:[NSURL URLWithString:@"https://brewspace.jiveland.com/"]]) {
            options.url = [NSURL URLWithString:@"api/core/v3/places/1234"
                                 relativeToURL:self.testURL];
        }
        return [jive trendingOperation:options
                            onComplete:completionBlock
                               onError:errorBlock];
    }
                      withResponse:@"trending_people"
                               URL:@"https://brewspace.jiveland.com/api/core/v3/people/trending?filter=place(https://brewspace.jiveland.com/api/core/v3/places/1234)"
                     expectedCount:25];
}

- (void) testTrendingPeople {
    JiveTrendingPeopleRequestOptions *options = [[JiveTrendingPeopleRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/trending?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/trending?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"trending_people" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive trending:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)25, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPersonActivitiesOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive activitiesOperation:source
                             withOptions:options
                              onComplete:completionBlock
                                 onError:errorBlock];
    }
                withResponse:@"person_activities"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/activities?after=1970-01-01T00%3A00%3A00.123%2B0000"
               expectedCount:23
               expectedClass:[JiveActivity class]];
}

- (void) testPersonActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive activities:source withOptions:options onComplete:^(NSArray *activities) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetBlogOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive blogOperation:source
                       withOptions:options
                        onComplete:completionBlock
                           onError:errorBlock];
    }
                  withResponse:@"blog"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/blog?fields=id"
                 expectedClass:[JiveBlog class]];
}

- (void) testGetBlog {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/blog?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/blog?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"blog" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive blog:source withOptions:options onComplete:^(JiveBlog *blog) {
            // Called 3rd
            STAssertEquals([blog class], [JiveBlog class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetManagerOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkPersonObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive managerOperation:source
                          withOptions:options
                           onComplete:completionBlock
                              onError:errorBlock];
    }
                        withResponse:@"person_response"
                                 URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/@manager?fields=id"];
}

- (void) testGetManager {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@manager?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@manager?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive manager:source withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetReportsOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    NSString *instanceString = @"http://gigi-eae03.eng.jiveland.com";
    
    self.testURL = [NSURL URLWithString:instanceString];
    options.count = 10;
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive reportsOperation:source
                          withOptions:options
                           onComplete:completionBlock
                              onError:errorBlock];
    }
                      withResponse:@"people_response"
                               URL:[instanceString stringByAppendingString:@"/api/core/v3/people/3550/@reports?count=10"]
                     expectedCount:20];
}

- (void) testGetReports {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@reports?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@reports?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive reports:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetFollowingOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    NSString *instanceString = @"http://gigi-eae03.eng.jiveland.com";
    
    self.testURL = [NSURL URLWithString:instanceString];
    options.count = 10;
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive followingOperation:source
                            withOptions:options
                             onComplete:completionBlock
                                onError:errorBlock];
    }
                      withResponse:@"people_response"
                               URL:[instanceString stringByAppendingString:@"/api/core/v3/people/3550/@following?count=10"]
                     expectedCount:20];
}

- (void) testGetFollowing {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@following?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@following?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive following:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetReportsFromOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkPersonObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive person:@"8192"
           reportsOperation:@"1876"
                withOptions:options
                 onComplete:completionBlock
                    onError:errorBlock];
    }
                        withResponse:@"person_response"
                                 URL:@"https://brewspace.jiveland.com/api/core/v3/people/8192/@reports/1876?fields=id"];
}

- (void) testGetReportsFrom {
    
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@reports/5630?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@reports/5630?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive person:@"2918" reports:@"5630" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetContentsOperation {
    JiveContentRequestOptions *options = [[JiveContentRequestOptions alloc] init];
    [options addAuthor:[NSURL URLWithString:@"http://person.com/dummy"]];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive contentsOperation:options
                            onComplete:completionBlock
                               onError:errorBlock];
    }
                withResponse:@"contents"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/contents?filter=author(http://person.com/dummy)"
               expectedCount:25
               expectedClass:[JiveContent class]];
}

- (void) testGetContents {
    JiveContentRequestOptions *options = [[JiveContentRequestOptions alloc] init];
    [options addAuthor:[NSURL URLWithString:@"http://dummy.com/person"]];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents?filter=author(http://dummy.com/person)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents?filter=author(http://dummy.com/person)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"contents" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive contents:options onComplete:^(NSArray *contents) {
            // Called 3rd
            STAssertEquals([contents count], (NSUInteger)25, @"Wrong number of items parsed");
            STAssertTrue([[[contents objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetPopularContentsOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive popularContentsOperation:options
                                   onComplete:completionBlock
                                      onError:errorBlock];
    }
                withResponse:@"contents"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/contents/popular?fields=id"
               expectedCount:25
               expectedClass:[JiveContent class]];
}

- (void) testGetPopularContents {
    
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/popular?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/popular?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"contents" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive popularContents:options onComplete:^(NSArray *contents) {
            // Called 3rd
            STAssertEquals([contents count], (NSUInteger)25, @"Wrong number of items parsed");
            STAssertTrue([[[contents objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetRecommendedContentsOperation {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 10;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive recommendedContentsOperation:options
                                       onComplete:completionBlock
                                          onError:errorBlock];
    }
                withResponse:@"contents"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/contents/recommended?count=10"
               expectedCount:25
               expectedClass:[JiveContent class]];
}

- (void) testGetRecommendedContents {
    
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/recommended?count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/recommended?count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"contents" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive recommendedContents:options onComplete:^(NSArray *contents) {
            // Called 3rd
            STAssertEquals([contents count], (NSUInteger)25, @"Wrong number of items parsed");
            STAssertTrue([[[contents objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetTrendingContentsOperation {
    JiveTrendingContentRequestOptions *options = [[JiveTrendingContentRequestOptions alloc] init];
    [options addType:@"blog"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive trendingContentsOperation:options
                                    onComplete:completionBlock
                                       onError:errorBlock];
    }
                withResponse:@"contents"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/contents/trending?filter=type(blog)"
               expectedCount:25
               expectedClass:[JiveContent class]];
}

- (void) testGetTrendingContents {
    
    JiveTrendingContentRequestOptions *options = [[JiveTrendingContentRequestOptions alloc] init];
    [options addType:@"discussion"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/trending?filter=type(discussion)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/trending?filter=type(discussion)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"contents" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive trendingContents:options onComplete:^(NSArray *contents) {
            // Called 3rd
            STAssertEquals([contents count], (NSUInteger)25, @"Wrong number of items parsed");
            STAssertTrue([[[contents objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetContentsByIDOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive contentOperation:source
                          withOptions:options
                           onComplete:completionBlock
                              onError:errorBlock];
    }
                  withResponse:@"content_by_id"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/contents/372124?fields=id"
                 expectedClass:[JiveUpdate class]];
}

- (void) testGetContentsByID {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
        [jive content:source withOptions:options onComplete:^(JiveContent *content) {
            // Called 3rd
            STAssertEquals([content class], [JiveUpdate class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetCommentsForContentOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    options.excludeReplies = YES;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive commentsOperationForContent:source
                                     withOptions:options
                                      onComplete:completionBlock
                                         onError:errorBlock];
    }
                withResponse:@"content_comments"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/contents/372124/comments?excludeReplies=true"
               expectedCount:23
               expectedClass:[JiveContent class]];
}

- (void) testGetCommentsForContent {
    
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    options.hierarchical = YES;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/comments?hierarchical=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/comments?hierarchical=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_comments" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
        [jive commentsForContent:source withOptions:options onComplete:^(NSArray *comments) {
            // Called 3rd
            STAssertEquals([comments count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertTrue([[[comments objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetContentLikesOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    NSString *instanceString = @"http://gigi-eae03.eng.jiveland.com";
    
    self.testURL = [NSURL URLWithString:instanceString];
    options.startIndex = 10;
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive contentLikedByOperation:source
                                 withOptions:options
                                  onComplete:completionBlock
                                     onError:errorBlock];
    }
                      withResponse:@"people_response"
                               URL:[instanceString stringByAppendingString:@"/api/core/v3/contents/372124/likes?startIndex=10"]
                     expectedCount:20];
}

- (void) testGetContentLikes {
    
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/likes?startIndex=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/likes?startIndex=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
        [jive contentLikedBy:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            for (JivePerson *person in people) {
                STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            }
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetRecommendedPlacesOperation {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 10;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive recommendedPlacesOperation:options
                                     onComplete:completionBlock
                                        onError:errorBlock];
    }
                withResponse:@"recommended_places"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/places/recommended?count=10"
               expectedCount:7
               expectedClass:[JivePlace class]];
}

- (void) testGetRecommendedPlaces {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/recommended?count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/recommended?count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive recommendedPlaces:options onComplete:^(NSArray *places) {
            // Called 3rd
            STAssertEquals([places count], (NSUInteger)7, @"Wrong number of items parsed");
            STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetTrendingPlacesOperation {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 10;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive trendingPlacesOperation:options
                                  onComplete:completionBlock
                                     onError:errorBlock];
    }
                withResponse:@"recommended_places"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/places/trending?count=10"
               expectedCount:7
               expectedClass:[JivePlace class]];
}

- (void) testGetTrendingPlaces {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/trending?count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/trending?count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive trendingPlaces:options onComplete:^(NSArray *places) {
            // Called 3rd
            STAssertEquals([places count], (NSUInteger)7, @"Wrong number of items parsed");
            STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetPlacesOperation {
    JivePlacesRequestOptions *options = [[JivePlacesRequestOptions alloc] init];
    [options addEntityType:@"12" descriptor:@"4321"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive placesOperation:options
                          onComplete:completionBlock
                             onError:errorBlock];
    }
                withResponse:@"places"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/places?filter=entityDescriptor(12,4321)"
               expectedCount:25
               expectedClass:[JivePlace class]];
}

- (void) testGetPlaces {
    JivePlacesRequestOptions *options = [[JivePlacesRequestOptions alloc] init];
    [options addEntityType:@"37" descriptor:@"2345"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places?filter=entityDescriptor(37,2345)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places?filter=entityDescriptor(37,2345)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"places" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive places:options onComplete:^(NSArray *places) {
            // Called 3rd
            STAssertEquals([places count], (NSUInteger)25, @"Wrong number of items parsed");
            STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetPlacesPlacesOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    [options addType:@"question"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive placePlacesOperation:source
                              withOptions:options
                               onComplete:completionBlock
                                  onError:errorBlock];
    }
                withResponse:@"recommended_places"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/places/95191/places?filter=type(question)"
               expectedCount:7
               expectedClass:[JivePlace class]];
}

- (void) testGetPlacesPlaces {
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    [options addType:@"blog"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838/places?filter=type(blog)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838/places?filter=type(blog)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        [jive placePlaces:source withOptions:options onComplete:^(NSArray *places) {
            // Called 3rd
            STAssertEquals([places count], (NSUInteger)7, @"Wrong number of items parsed");
            STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetPlaceByIdOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive placeOperation:source
                        withOptions:options
                         onComplete:completionBlock
                            onError:errorBlock];
    }
                  withResponse:@"place"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/places/95191?fields=id"
                 expectedClass:[JivePlace class]];
}

- (void) testGetPlaceById {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        [jive place:source withOptions:options onComplete:^(JivePlace *place) {
            // Called 3rd
            STAssertTrue([[place class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetPlaceByURL {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive placeFromURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/places/301838"]
               withOptions:options
                onComplete:^(JivePlace *place) {
                    // Called 3rd
                    STAssertTrue([[place class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
                    
                    // Check that delegates where actually called
                    [mockAuthDelegate verify];
                    [mockJiveURLResponseDelegate verify];
                    finishedBlock();
                } onError:^(NSError *error) {
                    STFail([error localizedDescription]);
                    finishedBlock();
                }];
    }];
}

- (void)testGetPlaceByURLWithFilter {
    JivePlacesRequestOptions *options = [[JivePlacesRequestOptions alloc] init];
    [options addEntityType:@"37" descriptor:@"2345"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places?filter=entityDescriptor(37,2345)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places?filter=entityDescriptor(37,2345)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"places" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive placeFromURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/places?filter=entityDescriptor(37,2345)"]
               withOptions:options
                onComplete:^(JivePlace *place) {
                    // Called 3rd
                    STAssertTrue([[place class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
                    
                    // Check that delegates where actually called
                    [mockAuthDelegate verify];
                    [mockJiveURLResponseDelegate verify];
                    finishedBlock();
                } onError:^(NSError *error) {
                    STFail([error localizedDescription]);
                    finishedBlock();
                }];
    }];
}

- (void) testGetPlaceByURLOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    NSString *placePath = @"api/core/v3/places/95191";
    
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive placeOperationWithURL:[NSURL URLWithString:placePath
                                                  relativeToURL:jive.jiveInstanceURL]
                               withOptions:options
                                onComplete:completionBlock
                                   onError:errorBlock];
    }
                  withResponse:@"place"
                           URL:[NSString stringWithFormat:@"https://brewspace.jiveland.com/%@?fields=id", placePath]
                 expectedClass:[JivePlace class]];
}

- (void)testGetPlaceByURLOperationWithFilter {
    JivePlacesRequestOptions *options = [[JivePlacesRequestOptions alloc] init];
    NSString *placePath = @"api/core/v3/places?filter=entityDescriptor(37,2345)";
    
    [options addEntityType:@"37" descriptor:@"2345"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive placeOperationWithURL:[NSURL URLWithString:placePath
                                                  relativeToURL:jive.jiveInstanceURL]
                               withOptions:options
                                onComplete:completionBlock
                                   onError:errorBlock];
    }
                  withResponse:@"places"
                           URL:[NSString stringWithFormat:@"https://brewspace.jiveland.com/%@", placePath]
                 expectedClass:[JivePlace class]];
}

- (void) testPlaceActivitiesOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:1.234];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive placeActivitiesOperation:source
                                  withOptions:options
                                   onComplete:completionBlock
                                      onError:errorBlock];
    }
                withResponse:@"place_activities"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/places/95191/activities?after=1970-01-01T00%3A00%3A01.234%2B0000"
               expectedCount:27
               expectedClass:[JiveActivity class]];
}

- (void) testPlaceActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place_activities" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        [jive placeActivities:source withOptions:options onComplete:^(NSArray *activities) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)27, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testMemberOperationWithMember {
    JiveMember *testMember = [self entityForClass:[JiveMember class] fromJSONNamed:@"member"];
    JiveReturnFieldsRequestOptions *options = [JiveReturnFieldsRequestOptions new];
    
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive memberOperationWithMember:testMember
                                       options:options
                                    onComplete:completionBlock
                                       onError:errorBlock];
    }
                  withResponse:@"member_member"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/members/36391?fields=id"
                 expectedClass:[JiveMember class]];
}

- (void) testMemberWithMember {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                        password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/members/36391" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                        password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/members/36391" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"member_member"
                          andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveMember *testMember = [self entityForClass:[JiveMember class]
                                        fromJSONNamed:@"member"];
        [jive memberWithMember:testMember
                       options:nil
                    onComplete:(^(JiveMember *member) {
            STAssertNotNil(member, nil);
            finishedBlock();
        })
                       onError:(^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        })];
    }];
}

- (void) testDeletePersonOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive deletePersonOperation:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(JiveHTTPMethodTypes.DELETE, operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeletePersonServiceCall {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive deletePerson:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

//- (void) testPersonAvatarOperation {
//    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
//    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
//    __block NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"avatar" ofType:@"png"];
//    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
//    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
//        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/avatar" isEqualToString:[value absoluteString]];
//        return same;
//    }]];
//
//    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
//    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
//    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url statusCode:200 HTTPVersion:@"1.0" headerFields:[NSDictionary dictionaryWithObjectsAndKeys:@"image/png", @"Content-Type", nil]];
//    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
//    NSData *mockResponseData = [NSData dataWithContentsOfFile:contentPath];
//
//    [[[mockJiveURLResponseDelegate expect] andReturn:mockResponseData] responseBodyForRequest];
//    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
//    jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
//
//    NSOperation* operation = [jive avatarForPersonOperation:source onComplete:^(UIImage *avatarImage) {
//        UIImage *testImage = [UIImage imageNamed:@"avatar.png"];
//        STAssertEqualObjects(testImage, avatarImage, @"Wrong image returned");
//        // Check that delegates where actually called
//        [mockAuthDelegate verify];
//        [mockJiveURLResponseDelegate verify];
//    } onError:^(NSError *error) {
//        STFail([error localizedDescription]);
//    }];
//
//    [self runOperation:operation];
//}

//- (void) testPersonAvatarServiceCall {
//    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
//    __block NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"avatar" ofType:@"png"];
//    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
//    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
//        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/avatar" isEqualToString:[value absoluteString]];
//        return same;
//    }]];
//
//    mockJiveURLResponseDelegate = [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
//    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
//    jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
//
//    // Make the call
//    [self waitForTimeout:^(void (^finishedBlock)(void)) {
//        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
//        [jive avatarForPerson:source onComplete:^(UIImage *avatarImage) {
//            UIImage *testImage = [UIImage imageNamed:@"avatar.png"];
//            STAssertEqualObjects(testImage, avatarImage, @"Wrong image returned");
//            // Check that delegates where actually called
//            [mockAuthDelegate verify];
//            [mockJiveURLResponseDelegate verify];
//            finishedBlock();
//        } onError:^(NSError *error) {
//            STFail([error localizedDescription]);
//        }];
//    }];
//}

- (void) testFollowingInOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive followingInOperation:source
                              withOptions:options
                               onComplete:completionBlock
                                  onError:errorBlock];
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) test_updateFollowingInOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveStream *stream = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive updateFollowingInOperation:@[stream]
                                      forPerson:source
                                    withOptions:options
                                     onComplete:completionBlock
                                        onError:errorBlock];
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) testFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/followingIn?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/followingIn?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive followingIn:source withOptions:options onComplete:^(NSArray *streams) {
            // Called 3rd
            STAssertEquals([streams count], (NSUInteger)1, @"Wrong number of items parsed");
            STAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testStreamOperation {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive streamOperation:source
                         withOptions:options
                          onComplete:completionBlock
                             onError:errorBlock];
    }
                  withResponse:@"stream"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/streams/10872?fields=id"
                 expectedClass:[JiveStream class]];
}

- (void) testStream {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream_alternate"];
        [jive stream:source withOptions:options onComplete:^(JiveStream *stream) {
            // Called 3rd
            STAssertTrue([[stream class] isSubclassOfClass:[JiveStream class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testStreamActivitiesOperation {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive streamActivitiesOperation:source
                                   withOptions:options
                                    onComplete:completionBlock
                                       onError:errorBlock];
    }
                withResponse:@"stream_activities"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/streams/10872/activities?after=1970-01-01T00%3A00%3A00.123%2B0000"
               expectedCount:32
               expectedClass:[JiveActivity class]];
}

- (void) testStreamActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream_activities" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream_alternate"];
        [jive streamActivities:source withOptions:options onComplete:^(NSArray *activities) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)32, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testStreamConnectionsActivitiesOperation {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive streamConnectionsActivitiesOperation:options
                                               onComplete:completionBlock
                                                  onError:errorBlock];
    }
                withResponse:@"stream_activities"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/streams/connections/activities?after=1970-01-01T00%3A00%3A00.123%2B0000"
               expectedCount:32
               expectedClass:[JiveActivity class]];
}

- (void) testStreamConnectionsActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/connections/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/connections/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream_activities" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive streamConnectionsActivities:options onComplete:^(NSArray *activities) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)32, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testDeleteStreamOperation {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive deleteStreamOperation:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(JiveHTTPMethodTypes.DELETE, operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeleteStreamServiceCall {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream_alternate"];
        [jive deleteStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPersonStreamsOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive streamsOperation:source
                          withOptions:options
                           onComplete:completionBlock
                              onError:errorBlock];
    }
                withResponse:@"person_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/streams?fields=name,id"
               expectedCount:5
               expectedClass:[JiveStream class]];
}

- (void) testPersonStreams {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/streams?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/streams?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_streams" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive streams:source withOptions:options onComplete:^(NSArray *streams) {
            // Called 3rd
            STAssertEquals([streams count], (NSUInteger)5, @"Wrong number of items parsed");
            STAssertEquals([[streams objectAtIndex:0] class], [JiveStream class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPersonTasksOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderTitleAsc;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive tasksOperation:source
                        withOptions:options
                         onComplete:completionBlock
                            onError:errorBlock];
    }
                withResponse:@"person_tasks"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/tasks?sort=titleAsc"
               expectedCount:1
               expectedClass:[JiveTask class]];
}

- (void) testPersonTasks {
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderLatestActivityDesc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/tasks?sort=latestActivityDesc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/tasks?sort=latestActivityDesc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_tasks" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive tasks:source withOptions:options onComplete:^(NSArray *tasks) {
            // Called 3rd
            STAssertEquals([tasks count], (NSUInteger)1, @"Wrong number of items parsed");
            STAssertEquals([[tasks objectAtIndex:0] class], [JiveTask class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPlacesFollowingInOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive placeFollowingInOperation:source
                                   withOptions:options
                                    onComplete:completionBlock
                                       onError:errorBlock];
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/places/95191/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) testPlacesFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838/followingIn?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838/followingIn?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        [jive placeFollowingIn:source withOptions:options onComplete:^(NSArray *streams) {
            // Called 3rd
            STAssertEquals([streams count], (NSUInteger)1, @"Wrong number of items parsed");
            STAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) test_updateFollowingInOperation_forPlace {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JiveStream *stream = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive updateFollowingInOperation:@[stream]
                                       forPlace:source
                                    withOptions:options
                                     onComplete:completionBlock
                                        onError:errorBlock];
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/places/95191/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) testContentsFollowingInOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive contentFollowingInOperation:source
                                     withOptions:options
                                      onComplete:completionBlock
                                         onError:errorBlock];
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/contents/372124/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) test_updateFollowingInOperation_forContent {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    JiveStream *stream = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive updateFollowingInOperation:@[stream]
                                     forContent:source
                                    withOptions:options
                                     onComplete:completionBlock
                                        onError:errorBlock];
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/contents/372124/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) testContentsFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/followingIn?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/followingIn?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
        [jive contentFollowingIn:source withOptions:options onComplete:^(NSArray *streams) {
            // Called 3rd
            STAssertEquals([streams count], (NSUInteger)1, @"Wrong number of items parsed");
            STAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testStreamAssociationsOperation {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveAssociationsRequestOptions *options = [[JiveAssociationsRequestOptions alloc] init];
    [options addType:@"dm"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive streamAssociationsOperation:source
                                     withOptions:options
                                      onComplete:completionBlock
                                         onError:errorBlock];
    }
                withResponse:@"stream_associations"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations?filter=type(dm)"
               expectedCount:24
               expectedClass:[JiveContent class]];
}

- (void) testStreamAssociationsOperationWithPeopleAndPlaces {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveAssociationsRequestOptions *options = [[JiveAssociationsRequestOptions alloc] init];
    [options addType:@"dm"];
    self.testURL = [NSURL URLWithString:@"http://tiedhouse-yeti1.eng.jiveland.com"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive streamAssociationsOperation:source
                                     withOptions:options
                                      onComplete:^(NSArray *associations) {
                                          if (associations.count >= 3) {
                                              STAssertTrue([associations[0] isKindOfClass:[JivePerson class]], @"Wrong first item class");
                                              STAssertTrue([associations[1] isKindOfClass:[JiveGroup class]], @"Wrong second item class");
                                              STAssertTrue([associations[2] isKindOfClass:[JiveBlog class]], @"Wrong third item class");
                                          }
                                          completionBlock(associations);
                                      }
                                         onError:errorBlock];
    }
                withResponse:@"stream_associations_alt"
                         URL:@"http://tiedhouse-yeti1.eng.jiveland.com/api/core/v3/streams/10872/associations?filter=type(dm)"
               expectedCount:3
               expectedClass:[JiveTypedObject class]];
}

- (void) testStreamAssociations {
    JiveAssociationsRequestOptions *options = [[JiveAssociationsRequestOptions alloc] init];
    [options addType:@"message"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433/associations?filter=type(message)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433/associations?filter=type(message)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream_associations" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream_alternate"];
        [jive streamAssociations:source withOptions:options onComplete:^(NSArray *associations) {
            // Called 3rd
            STAssertEquals([associations count], (NSUInteger)24, @"Wrong number of items parsed");
            STAssertTrue([[associations objectAtIndex:0] isKindOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testUpdateStreamOperation {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    source.name = @"changed name";
    source.receiveEmails = [NSNumber numberWithBool:YES];
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive updateStreamOperation:source withOptions:options onComplete:^(JiveStream *stream) {
            // Called 3rd
            STAssertTrue([[stream class] isSubclassOfClass:[JiveStream class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testUpdateStream {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream_alternate"];
        source.name = @"Wrong Way";
        source.receiveEmails = nil;
        [jive updateStream:source withOptions:options onComplete:^(JiveStream *stream) {
            // Called 3rd
            STAssertTrue([[stream class] isSubclassOfClass:[JiveStream class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testUpdateMemberOperation {
    JiveMember *source = [self entityForClass:[JiveMember class] fromJSONNamed:@"member"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/members/36391?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/members/36391?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"member" andAuthDelegate:mockAuthDelegate];
    
    source.state = @"owner";
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive updateMemberOperation:source withOptions:options onComplete:^(JiveMember *member) {
            // Called 3rd
            STAssertTrue([[member class] isSubclassOfClass:[JiveMember class]], @"Wrong item class");
            STAssertEqualObjects(@"member", member.state, @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testUpdateMember {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/members/36479?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/members/36479?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"member" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveMember *source = [self entityForClass:[JiveMember class] fromJSONNamed:@"member_alternate"];
        source.state = @"banned";
        [jive updateMember:source withOptions:options onComplete:^(JiveMember *member) {
            // Called 3rd
            STAssertTrue([[member class] isSubclassOfClass:[JiveMember class]], @"Wrong item class");
            STAssertEqualObjects(@"member", member.state, @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testContentMarkAsReadOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive contentOperation:source markAsRead:YES onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testContentMarkAsRead {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
        [jive content:source markAsRead:YES onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testContentMarkAsReadOperation_unread {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive contentOperation:source markAsRead:NO onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.DELETE, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testContentMarkAsRead_unread {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
        [jive content:source markAsRead:NO onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testContentLikesOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive contentOperation:source likes:YES onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testContentLikes {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
        [jive content:source likes:YES onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testContentLikesOperation_unread {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive contentOperation:source likes:NO onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.DELETE, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testContentLikes_unread {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
        [jive content:source likes:NO onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testDeleteContentOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive deleteContentOperation:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.DELETE, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeleteContent {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
        [jive deleteContent:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testUpdateContentOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
    JiveMinorCommentRequestOptions *options = [[JiveMinorCommentRequestOptions alloc] init];
    options.minor = YES;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088?minor=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088?minor=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    source.subject = @"subject";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive updateContentOperation:source withOptions:options onComplete:^(JiveContent *content) {
            // Called 3rd
            STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
            STAssertEqualObjects(content.subject, @"Battle Week is upon us... LET'S GO ZAGS!!!", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testUpdateContent {
    JiveMinorCommentRequestOptions *options = [[JiveMinorCommentRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
        source.subject = @"alternate";
        [jive updateContent:source withOptions:options onComplete:^(JiveContent *content) {
            // Called 3rd
            STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
            STAssertEqualObjects(content.subject, @"Battle Week is upon us... LET'S GO ZAGS!!!", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testUpdatePlacesOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    source.displayName = @"displayName";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive updatePlaceOperation:source withOptions:options onComplete:^(JivePlace *place) {
            // Called 3rd
            STAssertTrue([[place class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            STAssertEqualObjects(place.displayName, @"honda", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testUpdatePlaces {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        source.displayName = @"alternate";
        [jive updatePlace:source withOptions:options onComplete:^(JivePlace *place) {
            // Called 3rd
            STAssertTrue([[place class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            STAssertEqualObjects(place.displayName, @"honda", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testUpdatePersonOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    NSDictionary *JSON = [source toJSONDictionary];
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    [self checkPersonObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive updatePersonOperation:source
                                                               onComplete:completionBlock
                                                                  onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                        withResponse:@"person_response"
                                 URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550"];
}

- (void) testUpdatePerson {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        source.location = @"alternate";
        [jive updatePerson:source onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertTrue([[person class] isSubclassOfClass:[JivePerson class]], @"Wrong item class");
            STAssertEqualObjects(person.location, @"home on the range", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testFollowPersonOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JivePerson *target = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@following/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@following/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive personOperation:source follow:target onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testFollowPerson {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@following/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@following/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        JivePerson *target = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
        [jive person:source follow:target onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testActivitiesOperation {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/activities?after=1970-01-01T00%3A00%3A00.123%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/activities?after=1970-01-01T00%3A00%3A00.123%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive activitiesOperationWithOptions:options onComplete:^(NSArray *activities, NSDate *earliestDate, NSDate *latestDate) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        [operation start];
    }];
}

- (void) testActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive activitiesWithOptions:options onComplete:^(NSArray *activities, NSDate *earliestDate, NSDate *latestDate) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testActionsOperation {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive actionsOperation:options onComplete:completionBlock onError:errorBlock];
    }
                withResponse:@"person_activities"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/actions?after=1970-01-01T00%3A00%3A00.123%2B0000"
               expectedCount:23
               expectedClass:[JiveActivity class]];
}

- (void) testActions {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/actions?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/actions?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive actions:options onComplete:^(NSArray *activities) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testContentMessagesOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"message"];
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    options.excludeReplies = YES;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive messagesOperationForContent:source
                                     withOptions:options
                                      onComplete:completionBlock
                                         onError:errorBlock];
    }
                withResponse:@"messages"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/messages/582073/messages?excludeReplies=true"
               expectedCount:2
               expectedClass:[JiveMessage class]];
}

- (void) testContentMessagesOperation_alternate {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive messagesOperationForContent:source
                                     withOptions:nil
                                      onComplete:completionBlock
                                         onError:errorBlock];
    }
                withResponse:@"content_messages"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/messages/contents/372124"
               expectedCount:4
               expectedClass:[JiveMessage class]];
}

- (void) testGetMessage {
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    options.hierarchical = YES;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/messages/582181/messages?hierarchical=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/messages/582181/messages?hierarchical=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"messages" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"message_alternate"];
        [jive messagesForContent:source withOptions:options onComplete:^(NSArray *messages) {
            // Called 3rd
            STAssertEquals([messages count], (NSUInteger)2, @"Wrong number of items parsed");
            STAssertEquals([[messages objectAtIndex:0] class], [JiveMessage class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testInvitesOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive invitesOperation:source
                          withOptions:options
                           onComplete:completionBlock
                              onError:errorBlock];
    }
                withResponse:@"invites"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/invites/places/95191?startIndex=5"
               expectedCount:2
               expectedClass:[JiveInvite class]];
}

- (void) testInvites {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/places/301838?startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/places/301838?startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invites" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        [jive invites:source withOptions:options onComplete:^(NSArray *invites) {
            // Called 3rd
            STAssertEquals([invites count], (NSUInteger)2, @"Wrong number of items parsed");
            STAssertEquals([[invites objectAtIndex:0] class], [JiveInvite class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetInviteOperation {
    JiveInvite *source = [self entityForClass:[JiveInvite class] fromJSONNamed:@"invite"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive inviteOperation:source
                         withOptions:options
                          onComplete:^(JiveInvite *invite) {
                              STAssertEqualObjects(invite.invitee.displayName, @"Jennifer Klafin", @"Wrong invite returned.");
                              completionBlock(invite);
                          }
                             onError:errorBlock];
    }
                  withResponse:@"invite_alternate"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/invites/1234567?fields=id"
                 expectedClass:[JiveInvite class]];
}

- (void) testGetInvite {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/654321?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/654321?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invite" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveInvite *source = [self entityForClass:[JiveInvite class] fromJSONNamed:@"invite_alternate"];
        [jive invite:source withOptions:options onComplete:^(JiveInvite *invite) {
            // Called 3rd
            STAssertTrue([[invite class] isSubclassOfClass:[JiveInvite class]], @"Wrong item class");
            STAssertEqualObjects(invite.invitee.displayName, @"Stewart Wachs", @"Wrong invite returned.");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testDeleteInviteOperation {
    JiveInvite *source = [self entityForClass:[JiveInvite class] fromJSONNamed:@"invite"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/1234567" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/1234567" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invite_alternate" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive deleteInviteOperation:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.DELETE, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeleteInvite {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/654321" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/654321" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invite" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveInvite *source = [self entityForClass:[JiveInvite class] fromJSONNamed:@"invite_alternate"];
        [jive deleteInvite:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testUpdateInviteOperation {
    JiveInvite *source = [self entityForClass:[JiveInvite class] fromJSONNamed:@"invite"];
    NSDictionary *jsonDictionary = @{@"id" : source.jiveId, @"state" : @"revoked"};
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    NSData *body = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive updateInviteOperation:source
                                                                withState:JiveInviteRevoked
                                                               andOptions:options
                                                               onComplete:^(JiveInvite *invite) {
                                                                   STAssertEqualObjects(invite.invitee.displayName, @"Jennifer Klafin", @"Wrong invite returned.");
                                                                   completionBlock(invite);
                                                               }
                                                                  onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"invite_alternate"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/invites/1234567?fields=id"
                 expectedClass:[JiveInvite class]];
}

- (void) testUpdateInvite {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/654321?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/654321?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invite" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveInvite *source = [self entityForClass:[JiveInvite class] fromJSONNamed:@"invite_alternate"];
        [jive updateInvite:source withState:JiveInviteFulfilled andOptions:options onComplete:^(JiveInvite *invite) {
            // Called 3rd
            STAssertTrue([[invite class] isSubclassOfClass:[JiveInvite class]], @"Wrong item class");
            STAssertEqualObjects(invite.invitee.displayName, @"Stewart Wachs", @"Wrong invite returned.");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateContentOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    
    [options addField:@"id"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createContentOperation:source
                                                               withOptions:options
                                                                onComplete:^(JiveContent *content) {
                                                                    STAssertEqualObjects(content.subject, @"Battle Week is upon us... LET'S GO ZAGS!!!", @"New object not created");
                                                                    completionBlock(content);
                                                                }
                                                                   onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"content_by_id"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/contents?fields=id"
                 expectedClass:[JiveUpdate class]];
}

- (void) testCreateContent {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
        [jive createContent:source withOptions:options onComplete:^(JiveContent *content) {
            // Called 3rd
            STAssertEquals([content class], [JiveDiscussion class], @"Wrong item class");
            STAssertEqualObjects(content.subject, @"Hitachi dates", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateDirectMessageOperation {
    JiveDirectMessage *source = [[JiveDirectMessage alloc] init];
    JiveTargetList *targets = [[JiveTargetList alloc] init];
    JivePerson *person = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    source.content = [[JiveContentBody alloc] init];
    source.content.text = @"Testing a direct message";
    [targets addUserName:@"Orson Bushnell"];
    [targets addPerson:person];
    
    NSMutableDictionary *JSONDictionary = (NSMutableDictionary *)[source toJSONDictionary];
    
    [JSONDictionary setValue:[targets toJSONArray:YES] forKey:@"participants"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSONDictionary options:0 error:nil];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createDirectMessageOperation:source
                                                                     withTargets:targets
                                                                      andOptions:options
                                                                      onComplete:^(JiveContent *content) {
                                                                          STAssertEqualObjects(content.subject, @"Heyo&#8211; can I get the email you prefer to use for Dropbox? I'll invite you to the Jive iPad share....", @"New object not created");
                                                                          completionBlock(content);
                                                                      }
                                                                         onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"direct_message_alternate"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/dms?fields=id"
                 expectedClass:[JiveDirectMessage class]];
}

- (void) testCreateDirectMessage {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/dms?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/dms?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"direct_message" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveDirectMessage *source = [[JiveDirectMessage alloc] init];
        JiveTargetList *targets = [[JiveTargetList alloc] init];
        JivePerson *person = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [targets addPerson:person];
        [jive createDirectMessage:source withTargets:targets andOptions:options onComplete:^(JiveContent *content) {
            // Called 3rd
            STAssertEquals([content class], [JiveDirectMessage class], @"Wrong item class");
            STAssertEqualObjects(content.subject, @"Hey guys,&nbsp; You should both have received two invites to join Jive's Apple iOS dev accounts. The...", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateInviteOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    NSString *message = @"Message to send";
    JiveTargetList *targets = [[JiveTargetList alloc] init];
    JivePerson *person = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    NSMutableDictionary *JSONDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [options addField:@"id"];
    [targets addUserName:@"Orson Bushnell"];
    [targets addPerson:person];
    
    [JSONDictionary setValue:message forKey:@"body"];
    [JSONDictionary setValue:[targets toJSONArray:NO] forKey:@"invitees"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSONDictionary options:0 error:nil];
    
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createInviteToOperation:source
                                                                withMessage:message
                                                                    targets:targets
                                                                 andOptions:options
                                                                 onComplete:completionBlock
                                                                    onError:errorBlock];
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"],
                             @"application/json; charset=UTF-8",
                             @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue],
                       (NSInteger)body.length,
                       @"Wrong content length");
        return operation;
    }
                withResponse:@"invites"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/invites/places/95191?fields=id"
               expectedCount:2
               expectedClass:[JiveInvite class]];
}

- (void) testCreateInvite {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/places/301838?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/places/301838?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invites" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        JiveTargetList *targets = [[JiveTargetList alloc] init];
        JivePerson *person = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [targets addPerson:person];
        [jive createInviteTo:source withMessage:@"Message to send" targets:targets andOptions:options onComplete:^(NSArray *invites) {
            // Called 3rd
            STAssertEquals([invites count], (NSUInteger)2, @"Wrong number of items parsed");
            STAssertEquals([[invites objectAtIndex:0] class], [JiveInvite class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreatePersonOperation {
    JivePerson *source = [[JivePerson alloc] init];
    JiveEmail *email = [[JiveEmail alloc] init];
    JiveWelcomeRequestOptions *options = [[JiveWelcomeRequestOptions alloc] init];
    options.welcome = YES;
    source.name = [[JiveName alloc] init];
    source.name.givenName = @"Orson";
    source.name.familyName = @"Bushnell";
    source.jive = [[JivePersonJive alloc] init];
    source.jive.username = @"orson.bushnell";
    source.jive.password = @"password";
    email.value = @"orson.bushnell@jivesoftware.com";
    email.type = @"work";
    email.jive_label = @"Email";
    source.emails = [NSArray arrayWithObject:email];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    
    [self checkPersonObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createPersonOperation:source
                                                              withOptions:options
                                                               onComplete:^(JivePerson *person) {
                                                                   STAssertEqualObjects(person.location, @"home on the range", @"New object not created");
                                                                   completionBlock(person);
                                                               }
                                                                  onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                        withResponse:@"person_response"
                                 URL:@"https://brewspace.jiveland.com/api/core/v3/people?welcome=true"];
}

- (void) testCreatePerson {
    JiveWelcomeRequestOptions *options = [[JiveWelcomeRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive createPerson:source withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.location, @"Portland", @"New object not created");
            STAssertEqualObjects(person.jiveInstance, jive, @"The person.jiveInstance was not initialized correctly");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateTaskOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveTask *testTask = [[JiveTask alloc] init];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    testTask.subject = @"subject";
    testTask.dueDate = [NSDate date];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[testTask toJSONDictionary] options:0 error:nil];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createTaskOperation:testTask
                                                              forPerson:source
                                                            withOptions:options
                                                             onComplete:^(JiveContent *task) {
                                                                 STAssertEqualObjects(task.subject, @"Sample task for iOS SDK reference", @"New object not created");
                                                                 completionBlock(task);
                                                             }
                                                                onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"task"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/tasks?fields=id"
                 expectedClass:[JiveTask class]];
}

- (void) testCreateTask {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/tasks?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/tasks?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        JiveTask *testTask = [[JiveTask alloc] init];
        testTask.subject = @"Supercalifragalisticexpialidotious - is that spelled right?";
        testTask.dueDate = [NSDate dateWithTimeIntervalSince1970:0];
        [jive createTask:testTask forPerson:source withOptions:options onComplete:^(JiveTask *task) {
            // Called 3rd
            STAssertEquals([task class], [JiveTask class], @"Wrong item class");
            STAssertEqualObjects(task.subject, @"Sample task for iOS SDK reference", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreatePlaceTaskOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JiveTask *testTask = [[JiveTask alloc] init];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    testTask.subject = @"subject";
    testTask.dueDate = [NSDate date];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[testTask toJSONDictionary] options:0 error:nil];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createTaskOperation:testTask
                                                               forPlace:source
                                                            withOptions:options
                                                             onComplete:^(JiveContent *task) {
                                                                 STAssertEqualObjects(task.subject, @"Sample task for iOS SDK reference", @"New object not created");
                                                                 completionBlock(task);
                                                             }
                                                                onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"task"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/places/95191/tasks?fields=id"
                 expectedClass:[JiveTask class]];
}

- (void) testCreatePlaceTask {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838/tasks?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/301838/tasks?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        JiveTask *testTask = [[JiveTask alloc] init];
        testTask.subject = @"Supercalifragalisticexpialidotious - is that spelled right?";
        testTask.dueDate = [NSDate dateWithTimeIntervalSince1970:0];
        [jive createTask:testTask forPlace:source withOptions:options onComplete:^(JiveTask *task) {
            // Called 3rd
            STAssertEquals([task class], [JiveTask class], @"Wrong item class");
            STAssertEqualObjects(task.subject, @"Sample task for iOS SDK reference", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreatePlaceOperation {
    JiveBlog *source = [[JiveBlog alloc] init];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    source.name = @"This is a test";
    source.parent = @"https://brewspace.jiveland.com/api/core/v3/places/301838";
    source.displayName = @"This is a test";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createPlaceOperation:source
                                                             withOptions:options
                                                              onComplete:^(JivePlace *place) {
                                                                  STAssertEqualObjects(place.displayName, @"honda", @"New object not created");
                                                                  completionBlock(place);
                                                              }
                                                                 onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"place"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/places?fields=id"
                 expectedClass:[JivePlace class]];
}

- (void) testCreatePlace {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        [jive createPlace:source withOptions:options onComplete:^(JivePlace *place) {
            // Called 3rd
            STAssertTrue([[place class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            STAssertEqualObjects(place.displayName, @"1523001374", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateCommentOperation {
    JiveComment *source = [[JiveComment alloc] init];
    JiveAuthorCommentRequestOptions *options = [[JiveAuthorCommentRequestOptions alloc] init];
    
    options.author = YES;
    source.content = [[JiveContentBody alloc] init];
    source.content.type = @"text/html";
    source.content.text = @"Comment";
    source.parent = @"https://brewspace.jiveland.com/api/core/v3/comments/484708";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createCommentOperation:source
                                                               withOptions:options
                                                                onComplete:^(JiveContent *comment) {
                                                                    STAssertEqualObjects(comment.content.text,
                                                                                         @"<body><!-- [DocumentBodyStart:ddeb4d22-8d54-4f74-908a-a26732ff43e9] --><div class=\"jive-rendered-content\"><div><p><a class=\"jive-link-email-small\" href=\"mailto:heath.borders@gmail.com\">heath.borders@gmail.com</a><span> is my personal dropbox account. Is it common for people to use personal accounts? I could create an account with my jive email if that is more common.</span></p></div></div><!-- [DocumentBodyEnd:ddeb4d22-8d54-4f74-908a-a26732ff43e9] --></body>",
                                                                                         @"New object not created");
                                                                    completionBlock(comment);
                                                                }
                                                                   onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"comment"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/comments?author=true"
                 expectedClass:[JiveComment class]];
}

- (void) testCreateComment {
    JiveAuthorCommentRequestOptions *options = [[JiveAuthorCommentRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/comments?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/comments?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"comment_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveComment *source = [self entityForClass:[JiveComment class] fromJSONNamed:@"comment"];
        [jive createComment:source withOptions:options onComplete:^(JiveContent *comment) {
            // Called 3rd
            STAssertTrue([[comment class] isSubclassOfClass:[JiveComment class]], @"Wrong item class");
            STAssertEqualObjects(comment.content.text,
                                 @"<body><!-- [DocumentBodyStart:7f270921-308d-45cf-a09f-f2c9396b33c7] --><div class=\"jive-rendered-content\"><span>I don't have a Dropbox account.</span></div><!-- [DocumentBodyEnd:7f270921-308d-45cf-a09f-f2c9396b33c7] --></body>",
                                 @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateOutcomeOperation {
    JiveOutcome *source = [self entityForClass:[JiveOutcome class] fromJSONNamed:@"outcome"];
    JiveContent *content = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [jive createOutcomeOperation:source
                                 forContent:content
                                 onComplete:^(JiveOutcome *outcome) {
                                     STAssertEqualObjects(outcome.jiveId, @"22871", @"JiveId wrong in outcome.");
                                     STAssertEqualObjects(outcome.outcomeType.jiveId, @"4", @"outcomeType JiveId is wrong in outcome.");
                                     
                                     STAssertTrue([[outcome.user class] isSubclassOfClass:[JivePerson class]], @"User is not a JivePerson");
                                     completionBlock(outcome);
                                 }
                                    onError:errorBlock];
    }
                  withResponse:@"outcome"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/contents/372088/outcomes"
                 expectedClass:[JiveOutcome class]];
}

- (void) testCreateOutcome {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/outcomes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/outcomes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"outcome" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JiveOutcome *source = [self entityForClass:[JiveOutcome class] fromJSONNamed:@"outcome"];
        JiveContent *content = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
        
        [jive createOutcome:source forContent:content onComplete:^(JiveOutcome *outcome) {
            STAssertTrue([[source class] isSubclassOfClass:[JiveOutcome class]], @"Wrong item class");
            
            STAssertTrue([outcome.jiveId isEqualToString:@"22871"], @"JiveId wrong in outcome.");
            STAssertTrue([outcome.outcomeType.jiveId isEqualToString:@"4"], @"outcomeType JiveId is wrong in outcome.");
            
            STAssertTrue([[outcome.user class] isSubclassOfClass:[JivePerson class]], @"User is not a JivePerson");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateMessageOperation {
    JiveMessage *source = [[JiveMessage alloc] init];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    source.content = [[JiveContentBody alloc] init];
    source.content.type = @"text/html";
    source.content.text = @"Comment";
    source.parent = @"https://brewspace.jiveland.com/api/core/v3/comments/484708";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createMessageOperation:source
                                                               withOptions:options
                                                                onComplete:^(JiveContent *comment) {
                                                                    STAssertEqualObjects(comment.content.text,
                                                                                         @"<body><!-- [DocumentBodyStart:1e47eba0-4637-4440-a7e6-f297b991c758] --><div class=\"jive-rendered-content\"><p>Do you know what's driving 4/15?</p></div><!-- [DocumentBodyEnd:1e47eba0-4637-4440-a7e6-f297b991c758] --></body>",
                                                                                         @"New object not created");
                                                                    completionBlock(comment);
                                                                }
                                                                   onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"message"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/messages?fields=id"
                 expectedClass:[JiveMessage class]];
}

- (void) testCreateMessage {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/messages?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/messages?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"message_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveMessage *source = [self entityForClass:[JiveMessage class] fromJSONNamed:@"message"];
        [jive createMessage:source withOptions:options onComplete:^(JiveContent *comment) {
            // Called 3rd
            STAssertTrue([[comment class] isSubclassOfClass:[JiveMessage class]], @"Wrong item class");
            STAssertEqualObjects(comment.content.text,
                                 @"<body><!-- [DocumentBodyStart:752ff804-8586-4ec5-8142-d928e17a1ff7] --><div class=\"jive-rendered-content\"><p>I asked their business sponsor and he said there are several large projects going on and they each have assigned dates, so they need to fit in this window for outages, resources, overall coordination. I asked if it could move and was basically given the same answer. Didn't get the sense that it was impossible, but just very difficult and with the pending renewal want to be sure we're all in sync internally. </p></div><!-- [DocumentBodyEnd:752ff804-8586-4ec5-8142-d928e17a1ff7] --></body>",
                                 @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateStreamOperation {
    JivePerson *person = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveStream *source = [[JiveStream alloc] init];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    source.name = @"new stream";
    source.receiveEmails = [NSNumber numberWithBool:YES];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createStreamOperation:source
                                                                forPerson:person
                                                              withOptions:options
                                                               onComplete:^(JiveStream *stream) {
                                                                   STAssertEqualObjects(stream.name, @"Test stream", @"Wrong stream name");
                                                                   completionBlock(stream);
                                                               }
                                                                  onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"stream_alternate"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/streams?fields=id"
                 expectedClass:[JiveStream class]];
}

- (void) testCreateStream {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/streams?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/streams?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *person = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        JiveStream *source = [[JiveStream alloc] init];
        source.name = @"Wrong Way";
        [jive createStream:source forPerson:person withOptions:options onComplete:^(JiveStream *stream) {
            // Called 3rd
            STAssertTrue([[stream class] isSubclassOfClass:[JiveStream class]], @"Wrong item class");
            STAssertEqualObjects(stream.name, @"The Team", @"Wrong stream name");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testDeleteStreamAssociationWithObjectOperation {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JivePerson *association = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations/person/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations/person/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive deleteAssociationOperation:association fromStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.DELETE, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeleteStreamAssociationWithObject {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433/associations/person/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433/associations/person/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream_alternate"];
        JivePerson *association = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        [jive deleteAssociation:association fromStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testCreateStreamAssociationsOperation {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JivePerson *association = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveAssociationTargetList *targetList = [[JiveAssociationTargetList alloc] init];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    [targetList addAssociationTarget:association];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[targetList toJSONArray] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive createAssociationsOperation:targetList forStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateStreamAssociationsOperationWithMultipleTargets {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveContent *association1 = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    JivePlace *association2 = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JiveAssociationTargetList *targetList = [[JiveAssociationTargetList alloc] init];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    [targetList addAssociationTarget:association1];
    [targetList addAssociationTarget:association2];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[targetList toJSONArray] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive createAssociationsOperation:targetList forStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateStreamAssociations {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433/associations" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10433/associations" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream_alternate"];
        JivePerson *association = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        JiveAssociationTargetList *targetList = [[JiveAssociationTargetList alloc] init];
        [targetList addAssociationTarget:association];
        [jive createAssociations:targetList forStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void)createMockResponse:(NSString *)response {
    [self createJiveAPIObjectWithResponse:response];
    jive = nil;
    mockAuthDelegate = nil;
}

- (void) testVersionOperationForInstance {
    [self createJiveAPIObjectWithResponse:@"version"];
    
    STAssertEqualObjects(jive.baseURI, @"api/core/v3", @"PRECONDITION: Wrong base uri");
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive versionOperationForInstance:self.testURL
                                                                     onComplete:(^(JivePlatformVersion *version) {
            STAssertEqualObjects(version.major, @7, @"Wrong version found");
            STAssertEqualObjects(((JiveCoreVersion *)version.coreURI[0]).version, @2, @"Wrong core uri version found");
            STAssertNil(version.instanceURL, @"There should not be a server URL");
            STAssertEqualObjects(jive.baseURI, @"api/core/v3", @"The base URI should not have changed");
            STAssertEqualObjects(jive.platformVersion, version, @"The Jive object was not updated to include the version");
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        })
                                                                        onError:(^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        })];
        
        [operation start];
    }];
}

- (void) testVersionForInstance {
    [self createJiveAPIObjectWithResponse:@"version_alternate"];
    
    STAssertEqualObjects(jive.baseURI, @"api/core/v3", @"PRECONDITION: Wrong base uri");
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [jive versionForInstance:self.testURL
                      onComplete:(^(JivePlatformVersion *version) {
            STAssertEqualObjects(version.major, @6, @"Wrong version found");
            STAssertEqualObjects(((JiveCoreVersion *)version.coreURI[0]).version, @2, @"Wrong core uri version found");
            STAssertEqualObjects(version.instanceURL, jive.jiveInstanceURL, @"Wrong server URL");
            STAssertEqualObjects(jive.baseURI, @"core/api/v3", @"The base URI was not updated");
            STAssertEqualObjects(jive.platformVersion, version, @"The Jive object was not updated to include the version");
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        })
                         onError:(^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        })];
    }];
}

- (void) testVersionOperationForInstanceReturnsErrorIfNoV3API {
    [self createJiveAPIObjectWithResponse:@"version_no_v3"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive versionOperationForInstance:self.testURL
                                                                     onComplete:(^(JivePlatformVersion *version) {
            BOOL found = NO;
            for (JiveCoreVersion *coreURI in version.coreURI) {
                if ([coreURI.version isEqualToNumber:@3]) {
                    STFail(@"v3 API found");
                    found = YES;
                }
            }
            if (!found) {
                STFail(@"Valid response returned without v3 API");
            }
            
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        })
                                                                        onError:(^(NSError *error) {
            STAssertEquals(error.code, JiveErrorCodeUnsupportedJivePlatformVersion, @"Wrong error code reported");
            STAssertNotNil(error.userInfo[JiveErrorKeyJivePlatformVersion], @"Missing JivePlatformVersion");
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        })];
        
        [operation start];
    }];
}

- (void) testVersionForProxiedInstance {
    [self createJiveAPIObjectWithResponse:@"version_proxy"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [jive versionForInstance:self.testURL
                      onComplete:(^(JivePlatformVersion *version) {
            NSURL *serverURL = [NSURL URLWithString:@"https://proxy.com/"];
            
            STAssertEqualObjects(version.major, @7, @"Wrong version found");
            STAssertEqualObjects(((JiveCoreVersion *)version.coreURI[0]).version, @2, @"Wrong core uri version found");
            STAssertEqualObjects(version.instanceURL, serverURL, @"Wrong server URL");
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        })
                         onError:(^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        })];
    }];
}

- (void) testChangingInstanceURL {
    NSURL *newJiveInstance = [NSURL URLWithString:@"http://alternate.net"];
    NSURL* originalJiveInstance = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    JivePlatformVersion *platformVersion = [JivePlatformVersion new];
    
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    jive = [[Jive alloc] initWithJiveInstance:originalJiveInstance
                        authorizationDelegate:mockAuthDelegate];
    [platformVersion setValue:newJiveInstance forKey:JivePlatformVersionAttributes.instanceURL];
    
    jive.jiveInstanceURL = newJiveInstance;
    STAssertNil(jive.platformVersion, @"Platform version should not exist");
    STAssertEqualObjects(jive.jiveInstanceURL, newJiveInstance, @"instance url not updated");
    
    [jive setValue:platformVersion forKey:@"platformVersion"];
    jive.jiveInstanceURL = originalJiveInstance;
    STAssertEqualObjects(jive.platformVersion, platformVersion, @"Changing the instance url should not have changed the platform version");
    STAssertEqualObjects(jive.jiveInstanceURL, originalJiveInstance, @"instance url not updated");
}

- (void) testCreateDocumentWithAttachmentsOperation {
    JiveDocument *source = [self entityForClass:[JiveDocument class] fromJSONNamed:@"document"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    JiveAttachment *simpleAttachment = [JiveAttachment new];
    NSArray *attachments = [NSArray arrayWithObject:simpleAttachment];
    
    [options addField:@"id"];
    simpleAttachment.name = @"document.json";
    simpleAttachment.url = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"document"
                                                                                                   ofType:@"json"]];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document_alternate" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive createDocumentOperation:source
                                                            withAttachments:attachments
                                                                    options:options
                                                                 onComplete:^(JiveContent *content) {
                                                                     // Called 3rd
                                                                     STAssertEquals([content class], [JiveDocument class], @"Wrong item class");
                                                                     STAssertEqualObjects(content.subject, @"TABDEV-605", @"New object not created");
                                                                     
                                                                     // Check that delegates where actually called
                                                                     [mockAuthDelegate verify];
                                                                     [mockJiveURLResponseDelegate verify];
                                                                     finishedBlock();
                                                                 } onError:^(NSError *error) {
                                                                     STFail([error localizedDescription]);
                                                                     finishedBlock();
                                                                 }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        NSString *contentType = [operation.request valueForHTTPHeaderField:@"Content-Type"];
        STAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary="], @"Wrong content type, don't care about the value of the boundary");
        [operation start];
    }];
}

- (void) testCreateDocumentWithAttachments {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveDocument *source = [self entityForClass:[JiveDocument class] fromJSONNamed:@"document_alternate"];
        JiveAttachment *simpleAttachment = [JiveAttachment new];
        NSArray *attachments = [NSArray arrayWithObject:simpleAttachment];
        
        simpleAttachment.name = @"document.json";
        simpleAttachment.url = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"document"
                                                                                                       ofType:@"json"]];
        [jive createDocument:source
             withAttachments:attachments
                     options:options
                  onComplete:^(JiveContent *content) {
                      // Called 3rd
                      STAssertEquals([content class], [JiveDocument class], @"Wrong item class");
                      STAssertEqualObjects(content.subject, @"Testing document visiblity defaults on iPad", @"New object not created");
                      
                      // Check that delegates where actually called
                      [mockAuthDelegate verify];
                      [mockJiveURLResponseDelegate verify];
                      finishedBlock();
                  } onError:^(NSError *error) {
                      STFail([error localizedDescription]);
                      finishedBlock();
                  }];
    }];
}

- (void) testPropertyWithNameOperation {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/metadata/properties/instance.url" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/metadata/properties/instance.url" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"property" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive propertyWithNameOperation:JivePropertyNames.instanceURL
                                                      onComplete:^(JiveProperty *property) {
                                                          // Called 3rd
                                                          STAssertEquals([property class], [JiveProperty class], @"Wrong item class");
                                                          
                                                          // Check that delegates where actually called
                                                          [mockAuthDelegate verify];
                                                          [mockJiveURLResponseDelegate verify];
                                                          finishedBlock();
                                                      }
                                                         onError:^(NSError *error) {
                                                             STFail([error localizedDescription]);
                                                             finishedBlock();
                                                         }];
        [operation start];
    }];
}

- (void) testPropertyWithName {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/metadata/properties/instance.title" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/metadata/properties/instance.title" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"property_alternate" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [jive propertyWithName:@"instance.title" onComplete:^(JiveProperty *property) {
            // Called 3rd
            STAssertEquals([property class], [JiveProperty class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPublicPropertyWithNameOperation {
    [self createJiveAPIObjectWithResponse:@"public_property"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive publicPropertyWithNameOperation:@"feature.mobile.nativeapp.allowed" onComplete:^(JiveProperty *property) {
            // Called 3rd
            STAssertEquals([property class], [JiveProperty class], @"Wrong item class");
            
            STAssertTrue([property valueAsBOOL], @"Public property value not as expected");
            
            // Check that delegate was actually called
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        [operation start];
    }];
}

- (void) testPublicPropertyWithName {
    [self createJiveAPIObjectWithResponse:@"public_property"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [jive publicPropertyWithName:@"feature.mobile.nativeapp.allowed" onComplete:^(JiveProperty *property) {
            // Called 3rd
            STAssertEquals([property class], [JiveProperty class], @"Wrong item class");
            
            STAssertTrue([property valueAsBOOL], @"Public property value not as expected");
            
            // Check that delegate was actually called
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPublicPropertiesList {
    [self createJiveAPIObjectWithResponse:@"public_property"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [jive publicPropertiesListWithOnComplete:^(NSArray *properties) {
            
            STAssertEquals([properties count], 1U, @"Expected one public property");
            
            // Called 3rd
            STAssertEquals([[properties objectAtIndex:0] class], [JiveProperty class], @"Wrong item class");
            
            STAssertTrue([[properties objectAtIndex:0] valueAsBOOL], @"Public property value not as expected");
            
            // Check that delegate was actually called
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testPublicPropertiesListOperation {
    [self createJiveAPIObjectWithResponse:@"public_property"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [[jive publicPropertiesListOperationWithOnComplete:^(NSArray *properties) {
            
            STAssertEquals([properties count], 1U, @"Expected one public property");
            
            // Called 3rd
            STAssertEquals([[properties objectAtIndex:0] class], [JiveProperty class], @"Wrong item class");
            
            STAssertTrue([[properties objectAtIndex:0] valueAsBOOL], @"Public property value not as expected");
            
            // Check that delegate was actually called
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }] start];
    }];
}


- (void) testCreateShareOperation {
    JiveContentBody *source = [JiveContentBody new];
    JiveTargetList *targets = [JiveTargetList new];
    JiveDocument *document = [self entityForClass:[JiveDocument class] fromJSONNamed:@"document"];
    JivePerson *person = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    self.testURL = [NSURL URLWithString:@"https://hopback.eng.jiveland.com/"];
    [options addField:@"id"];
    source.text = @"Testing a direct message";
    [targets addUserName:@"Orson Bushnell"];
    [targets addPerson:person];
    
    NSMutableDictionary *JSONDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [JSONDictionary setValue:[targets toJSONArray:YES] forKey:@"participants"];
    [JSONDictionary setValue:[document.selfRef absoluteString] forKey:@"shared"];
    [JSONDictionary setValue:[source toJSONDictionary] forKey:@"content"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSONDictionary options:0 error:nil];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation *operation = [jive createShareOperation:source
                                                              forContent:document
                                                             withTargets:targets
                                                              andOptions:options
                                                              onComplete:^(JiveShare *content) {
                                                                  STAssertEqualObjects(content.subject, @"Testing share creation.", @"New object not created");
                                                                  completionBlock(content);
                                                              }
                                                                 onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"share"
                           URL:@"https://hopback.eng.jiveland.com/api/core/v3/shares?fields=id"
                 expectedClass:[JiveShare class]];
}

- (void) testCreateShare {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/shares?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/shares?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"share_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContentBody *source = [JiveContentBody new];
        JiveTargetList *targets = [JiveTargetList new];
        JiveDocument *document = [self entityForClass:[JiveDocument class] fromJSONNamed:@"document"];
        JivePerson *person = [self entityForClass:[JivePerson class] fromJSONNamed:@"person_response"];
        source.text = @"Testing a direct message";
        [targets addPerson:person];
        [jive createShare:source
               forContent:document
              withTargets:targets
               andOptions:options
               onComplete:^(JiveContent *content) {
                   STAssertEquals([content class], [JiveShare class], @"Wrong item class");
                   STAssertEqualObjects(content.subject,
                                        @"Folks, Be sure to link to a blog on your hack, even if it's just a placeholder. Likes on blogs is...",
                                        @"New object not created");
                   
                   // Check that delegates where actually called
                   [mockAuthDelegate verify];
                   [mockJiveURLResponseDelegate verify];
                   finishedBlock();
               } onError:^(NSError *error) {
                   STFail([error localizedDescription]);
                   finishedBlock();
               }];
    }];
}

- (void) testObjectsOperation {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/metadata/objects/" isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/metadata/objects/" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"objects_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        NSOperation *operation = [jive objectsOperationOnComplete:^(NSDictionary *objects) {
            NSUInteger expectedNumberOfObjects = 72;
            STAssertEquals([objects count], expectedNumberOfObjects, @"Wrong number of objects, should be %@", @(expectedNumberOfObjects));
            STAssertEqualObjects(objects[@"person"], @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/person", nil);
            STAssertEqualObjects(objects[@"user"], @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/user", nil);
            STAssertEqualObjects(objects[@"profileImage"], @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/profileImage", nil);
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        [operation start];
    }];
}

- (void)testInstanceMetadata {
    Jive *instance = [[Jive alloc] init];
    JiveMetadata *initialMetadata = instance.instanceMetadata;
    
    STAssertNotNil(initialMetadata, @"The metadata object should be created");
    
    STAssertEquals(instance.instanceMetadata, initialMetadata, @"Second call should return the same object.");
    
    STAssertEquals(initialMetadata.instance, instance, @"The metadata object should have a reference to the Jive object that created it.");
}

- (void) testToggleCorrectAnswerOperation_markCorrect {
    NSString *expectedURL = @"https://brewspace.jiveland.com/api/core/v3/messages/602237/correctAnswer";
    JiveHTTPBasicAuthCredentials *authCredentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                                  password:@"foo"];
    JiveMessage *source = [self entityForClass:[JiveMessage class] fromJSONNamed:@"make_correct_answer_message"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:authCredentials] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURL isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:authCredentials] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURL isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    STAssertTrue(source.canMarkAsCorrectAnswer, @"PRECONDITION: Wrong make correct answer status");
    STAssertFalse(source.canClearMarkAsCorrectAnswer, @"PRECONDITION: Wrong clear correct answer status");
    [self createJiveAPIObjectWithResponse:@"clear_correct_answer_message" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive toggleCorrectAnswerOperation:source onComplete:^ {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertNil(operation.request.HTTPBody, @"No http body needed");
        [operation start];
    }];
}

- (void) testToggleCorrectAnswerOperation_removeCorrect {
    NSString *expectedURL = @"https://brewspace.jiveland.com/api/core/v3/messages/604058/correctAnswer";
    JiveHTTPBasicAuthCredentials *authCredentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                                  password:@"foo"];
    JiveMessage *source = [self entityForClass:[JiveMessage class] fromJSONNamed:@"clear_correct_answer_message"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:authCredentials] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURL isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:authCredentials] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURL isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    STAssertFalse(source.canMarkAsCorrectAnswer, @"PRECONDITION: Wrong make correct answer status");
    STAssertTrue(source.canClearMarkAsCorrectAnswer, @"PRECONDITION: Wrong clear correct answer status");
    [self createJiveAPIObjectWithResponse:@"make_correct_answer_message" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive toggleCorrectAnswerOperation:source onComplete:^ {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.DELETE, @"Wrong http method used");
        STAssertNil(operation.request.HTTPBody, @"No http body needed");
        [operation start];
    }];
}

- (void) testToggleCorrectAnswerOperation_unauthorized {
    NSString *expectedURL = @"https://brewspace.jiveland.com/api/core/v3/messages/602237/correctAnswer";
    JiveHTTPBasicAuthCredentials *authCredentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                                  password:@"foo"];
    JiveMessage *source = [self entityForClass:[JiveMessage class] fromJSONNamed:@"message"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:authCredentials] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURL isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:authCredentials] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURL isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    STAssertFalse(source.canMarkAsCorrectAnswer, @"PRECONDITION: Wrong make correct answer status");
    STAssertFalse(source.canClearMarkAsCorrectAnswer, @"PRECONDITION: Wrong clear correct answer status");
    [self createJiveAPIObjectWithResponse:@"clear_correct_answer_message" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive toggleCorrectAnswerOperation:source onComplete:^ {
            STFail(@"An unauthorized user should not be able to change the correct answer status.");
            finishedBlock();
        } onError:^(NSError *error) {
            STAssertEqualObjects(error.domain, JiveErrorDomain, @"Wrong error domain");
            STAssertEquals(error.code, JiveErrorCodeUnauthorizedActivityObjectType, @"Wrong error code");
            STAssertEqualObjects(error.userInfo[JiveErrorKeyUnauthorizedActivityObjectType],
                                 JiveErrorMessageUnauthorizedUserMarkCorrectAnswer,
                                 @"Wrong error message");
            finishedBlock();
        }];
        
        STAssertNil(operation, @"An unauthorized user should not result in a valid operation");
    }];
}

- (void) testToggleCorrectAnswer {
    NSString *expectedURL = @"https://brewspace.jiveland.com/api/core/v3/messages/604058/correctAnswer";
    JiveHTTPBasicAuthCredentials *authCredentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                                  password:@"foo"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:authCredentials] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURL isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:authCredentials] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURL isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"make_correct_answer_message" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveMessage *source = [self entityForClass:[JiveMessage class] fromJSONNamed:@"clear_correct_answer_message"];
        [jive toggleCorrectAnswer:source onComplete:^ {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetTermsAndConditionsOperation {
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/@me/termsAndConditions"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            STAssertTrue(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance should be required");
            STAssertNotNil(termsAndConditions.text, @"Missing text");
            STAssertNil(termsAndConditions.url, @"Unexpected URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertNotNil(operation, @"Missing operation");
        [operation start];
    }];
}

- (void) testGetTermsAndConditionsOperation_withURL {
    [self createJiveAPIObjectWithResponse:@"T_C_response_w_URL"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/@me/termsAndConditions"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            STAssertTrue(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance should be required");
            STAssertNil(termsAndConditions.text, @"Unexpected text");
            STAssertNotNil(termsAndConditions.url, @"Missing URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertNotNil(operation, @"Missing operation");
        [operation start];
    }];
}

- (void) testGetTermsAndConditionsOperation_alreadyAccepted {
    [self createJiveAPIObjectWithErrorCode:204
                   andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/@me/termsAndConditions"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            STAssertFalse(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance is not required");
            STAssertNil(termsAndConditions.text, @"Unexpected text");
            STAssertNil(termsAndConditions.url, @"Unexpected URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertNotNil(operation, @"Missing operation");
        [operation start];
    }];
}

- (void) testGetTermsAndConditions {
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/@me/termsAndConditions"];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive termsAndConditions:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testAcceptTermsAndConditionsOperation {
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/@me/acceptTermsAndConditions"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive acceptTermsAndConditionsOperation:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(JiveHTTPMethodTypes.POST, operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testAcceptTermsAndConditions {
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/@me/acceptTermsAndConditions"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive acceptTermsAndConditions:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetEditableContentOperation {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/466111/editable?fields=contentBody";
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"document_alternate"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"contentBody"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document" andAuthDelegate:mockAuthDelegate];
    source.subject = @"subject";
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive getEditableContentOperation:source
                                                                    withOptions:options
                                                                     onComplete:^(JiveContent *content) {
                                                                         // Called 3rd
                                                                         STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
                                                                         STAssertEqualObjects(content.subject, @"Testing document visiblity defaults on iPad", @"New object not created");
                                                                         STAssertEquals(content, source, @"Content object not updated");
                                                                         
                                                                         // Check that delegates where actually called
                                                                         [mockAuthDelegate verify];
                                                                         [mockJiveURLResponseDelegate verify];
                                                                         finishedBlock();
                                                                     }
                                                                        onError:^(NSError *error) {
                                                                            STFail([error localizedDescription]);
                                                                            finishedBlock();
                                                                        }];
        
        [operation start];
    }];
}

- (void) testGetEditableContent {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/464776/editable?fields=name,id";
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"document"];
        source.subject = @"alternate";
        [jive getEditableContent:source
                     withOptions:options
                      onComplete:^(JiveContent *content) {
                          // Called 3rd
                          STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
                          STAssertEqualObjects(content.subject, @"TABDEV-605", @"New object not created");
                          STAssertEquals(content, source, @"Content object not updated");
                          
                          // Check that delegates where actually called
                          [mockAuthDelegate verify];
                          [mockJiveURLResponseDelegate verify];
                          finishedBlock();
                      }
                         onError:^(NSError *error) {
                             STFail([error localizedDescription]);
                             finishedBlock();
                         }];
    }];
}

- (void) testLockContentForEditingOperation {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/466111/editable?fields=contentBody";
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"document_alternate"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"contentBody"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document" andAuthDelegate:mockAuthDelegate];
    source.subject = @"subject";
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive lockContentForEditingOperation:source
                                                                       withOptions:options
                                                                        onComplete:^(JiveContent *content) {
                                                                            // Called 3rd
                                                                            STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
                                                                            STAssertEqualObjects(content.subject, @"Testing document visiblity defaults on iPad", @"New object not created");
                                                                            STAssertEquals(content, source, @"Content object not updated");
                                                                            
                                                                            // Check that delegates where actually called
                                                                            [mockAuthDelegate verify];
                                                                            [mockJiveURLResponseDelegate verify];
                                                                            finishedBlock();
                                                                        }
                                                                           onError:^(NSError *error) {
                                                                               STFail([error localizedDescription]);
                                                                               finishedBlock();
                                                                           }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testLockContentForEditing {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/464776/editable?fields=name,id";
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"document"];
        source.subject = @"alternate";
        [jive lockContentForEditing:source
                        withOptions:options
                         onComplete:^(JiveContent *content) {
                             // Called 3rd
                             STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
                             STAssertEqualObjects(content.subject, @"TABDEV-605", @"New object not created");
                             STAssertEquals(content, source, @"Content object not updated");
                             
                             // Check that delegates where actually called
                             [mockAuthDelegate verify];
                             [mockJiveURLResponseDelegate verify];
                             finishedBlock();
                         }
                            onError:^(NSError *error) {
                                STFail([error localizedDescription]);
                                finishedBlock();
                            }];
    }];
}

- (void) testSaveContentWhileEditingOperation {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/466111/editable?minor=true";
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"document_alternate"];
    JiveMinorCommentRequestOptions *options = [[JiveMinorCommentRequestOptions alloc] init];
    options.minor = YES;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document" andAuthDelegate:mockAuthDelegate];
    source.subject = @"subject";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive saveContentWhileEditingOperation:source
                                                                         withOptions:options
                                                                          onComplete:^(JiveContent *content) {
                                                                              // Called 3rd
                                                                              STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
                                                                              STAssertEqualObjects(content.subject, @"Testing document visiblity defaults on iPad", @"New object not created");
                                                                              STAssertEquals(content, source, @"Content object not updated");
                                                                              
                                                                              // Check that delegates where actually called
                                                                              [mockAuthDelegate verify];
                                                                              [mockJiveURLResponseDelegate verify];
                                                                              finishedBlock();
                                                                          }
                                                                             onError:^(NSError *error) {
                                                                                 STFail([error localizedDescription]);
                                                                                 finishedBlock();
                                                                             }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testSaveContentWhileEditing {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/464776/editable?fields=name,id";
    JiveMinorCommentRequestOptions *options = [[JiveMinorCommentRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"document"];
        source.subject = @"alternate";
        [jive saveContentWhileEditing:source
                          withOptions:options
                           onComplete:^(JiveContent *content) {
                               // Called 3rd
                               STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
                               STAssertEqualObjects(content.subject, @"TABDEV-605", @"New object not created");
                               STAssertEquals(content, source, @"Content object not updated");
                               
                               // Check that delegates where actually called
                               [mockAuthDelegate verify];
                               [mockJiveURLResponseDelegate verify];
                               finishedBlock();
                           }
                              onError:^(NSError *error) {
                                  STFail([error localizedDescription]);
                                  finishedBlock();
                              }];
    }];
}

- (void) testUnlockContentOperation {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/466111/editable";
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"document_alternate"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document" andAuthDelegate:mockAuthDelegate];
    source.subject = @"subject";
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive unlockContentOperation:source
                                                                onComplete:^ {
                                                                    // Check that delegates where actually called
                                                                    [mockAuthDelegate verify];
                                                                    [mockJiveURLResponseDelegate verify];
                                                                    finishedBlock();
                                                                }
                                                                   onError:^(NSError *error) {
                                                                       STFail([error localizedDescription]);
                                                                       finishedBlock();
                                                                   }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.DELETE, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testUnlockContent {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/464776/editable";
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document_alternate" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"document"];
        source.subject = @"alternate";
        [jive unlockContent:source
                 onComplete:^ {
                     // Check that delegates where actually called
                     [mockAuthDelegate verify];
                     [mockJiveURLResponseDelegate verify];
                     finishedBlock();
                 }
                    onError:^(NSError *error) {
                        STFail([error localizedDescription]);
                        finishedBlock();
                    }];
    }];
}

- (void) testSaveDocumentWithAttachmentsOperation {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/464776/editable";
    JiveDocument *source = [self entityForClass:[JiveDocument class] fromJSONNamed:@"document"];
    JiveMinorCommentRequestOptions *options = [[JiveMinorCommentRequestOptions alloc] init];
    JiveAttachment *simpleAttachment = [JiveAttachment new];
    NSArray *attachments = [NSArray arrayWithObject:simpleAttachment];
    
    options.minor = YES;
    simpleAttachment.name = @"document.json";
    simpleAttachment.url = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"document"
                                                                                                   ofType:@"json"]];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document_alternate" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive saveDocumentWhileEditingOperation:source
                                                                      withAttachments:attachments
                                                                              options:options
                                                                           onComplete:^(JiveContent *content) {
                                                                               // Called 3rd
                                                                               STAssertEquals([content class], [JiveDocument class], @"Wrong item class");
                                                                               STAssertEqualObjects(content.subject, @"TABDEV-605", @"New object not created");
                                                                               STAssertEquals(content, source, @"Content object not updated");
                                                                               
                                                                               // Check that delegates where actually called
                                                                               [mockAuthDelegate verify];
                                                                               [mockJiveURLResponseDelegate verify];
                                                                               finishedBlock();
                                                                           }
                                                                              onError:^(NSError *error) {
                                                                                  STFail([error localizedDescription]);
                                                                                  finishedBlock();
                                                                              }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        NSString *contentType = [operation.request valueForHTTPHeaderField:@"Content-Type"];
        STAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary="], @"Wrong content type, don't care about the value of the boundary");
        [operation start];
    }];
}

- (void) testSaveDocumentWithAttachments {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/466111/editable";
    JiveMinorCommentRequestOptions *options = [[JiveMinorCommentRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveDocument *source = [self entityForClass:[JiveDocument class] fromJSONNamed:@"document_alternate"];
        JiveAttachment *simpleAttachment = [JiveAttachment new];
        NSArray *attachments = [NSArray arrayWithObject:simpleAttachment];
        
        simpleAttachment.name = @"document.json";
        simpleAttachment.url = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"document"
                                                                                                       ofType:@"json"]];
        [jive saveDocumentWhileEditing:source
                       withAttachments:attachments
                               options:options
                            onComplete:^(JiveContent *content) {
                                // Called 3rd
                                STAssertEquals([content class], [JiveDocument class], @"Wrong item class");
                                STAssertEqualObjects(content.subject, @"Testing document visiblity defaults on iPad", @"New object not created");
                                STAssertEquals(content, source, @"Content object not updated");
                                
                                // Check that delegates where actually called
                                [mockAuthDelegate verify];
                                [mockJiveURLResponseDelegate verify];
                                finishedBlock();
                            } onError:^(NSError *error) {
                                STFail([error localizedDescription]);
                                finishedBlock();
                            }];
    }];
}

- (void) testSavePostWithAttachmentsOperation {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/464776/editable";
    JivePost *source = [self entityForClass:[JiveDocument class] fromJSONNamed:@"document"];
    JiveMinorCommentRequestOptions *options = [[JiveMinorCommentRequestOptions alloc] init];
    JiveAttachment *simpleAttachment = [JiveAttachment new];
    NSArray *attachments = [NSArray arrayWithObject:simpleAttachment];
    
    options.minor = YES;
    simpleAttachment.name = @"document.json";
    simpleAttachment.url = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"document"
                                                                                                   ofType:@"json"]];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document_alternate" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [jive savePostWhileEditingOperation:source
                                                                      withAttachments:attachments
                                                                              options:options
                                                                           onComplete:^(JiveContent *content) {
                                                                               // Called 3rd
                                                                               STAssertEquals([content class], [JiveDocument class], @"Wrong item class");
                                                                               STAssertEqualObjects(content.subject, @"TABDEV-605", @"New object not created");
                                                                               STAssertEquals(content, source, @"Content object not updated");
                                                                               
                                                                               // Check that delegates where actually called
                                                                               [mockAuthDelegate verify];
                                                                               [mockJiveURLResponseDelegate verify];
                                                                               finishedBlock();
                                                                           }
                                                                              onError:^(NSError *error) {
                                                                                  STFail([error localizedDescription]);
                                                                                  finishedBlock();
                                                                              }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        NSString *contentType = [operation.request valueForHTTPHeaderField:@"Content-Type"];
        STAssertTrue([contentType hasPrefix:@"multipart/form-data; boundary="], @"Wrong content type, don't care about the value of the boundary");
        [operation start];
    }];
}

- (void) testSavePostWithAttachments {
    NSString *expectedURLString = @"https://brewspace.jiveland.com/api/core/v3/contents/466111/editable";
    JiveMinorCommentRequestOptions *options = [[JiveMinorCommentRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar" password:@"foo"]] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        // the form parameters are attached in the multipart form body
        BOOL same = [expectedURLString isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"document" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePost *source = [self entityForClass:[JiveDocument class] fromJSONNamed:@"document_alternate"];
        JiveAttachment *simpleAttachment = [JiveAttachment new];
        NSArray *attachments = [NSArray arrayWithObject:simpleAttachment];
        
        simpleAttachment.name = @"document.json";
        simpleAttachment.url = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"document"
                                                                                                       ofType:@"json"]];
        [jive savePostWhileEditing:source
                       withAttachments:attachments
                               options:options
                            onComplete:^(JiveContent *content) {
                                // Called 3rd
                                STAssertEquals([content class], [JiveDocument class], @"Wrong item class");
                                STAssertEqualObjects(content.subject, @"Testing document visiblity defaults on iPad", @"New object not created");
                                STAssertEquals(content, source, @"Content object not updated");
                                
                                // Check that delegates where actually called
                                [mockAuthDelegate verify];
                                [mockJiveURLResponseDelegate verify];
                                finishedBlock();
                            } onError:^(NSError *error) {
                                STFail([error localizedDescription]);
                                finishedBlock();
                            }];
    }];
}

@end
