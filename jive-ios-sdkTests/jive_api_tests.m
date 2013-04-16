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

#import "JiveCredentials.h"
#import "JiveTargetList_internal.h"
#import "JiveAssociationTargetList_internal.h"
#import "JAPIRequestOperation.h"
#import "MockJiveURLProtocol.h"

#import "OCMockObject+MockJiveURLResponseDelegate.h"
#import "NSError+Jive.h"

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

// Create the Jive API object, using mock auth delegate
- (Jive *)createJiveAPIObjectWithResponse:(NSString *)resourceName andAuthDelegate:(id)authDelegate {
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    
    // Reponse file containing data from JIVE My request
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:resourceName ofType:@"json"];
    
    // Mock response delegate
    mockJiveURLResponseDelegate = [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:authDelegate];
    return jive;
}

// Create the Jive API object with a generic mock auth delegate
- (Jive *)createJiveAPIObjectWithResponse:(NSString *)resourceName {
    
    mockAuthDelegate = [self mockJiveAuthenticationDelegate];
    return [self createJiveAPIObjectWithResponse:resourceName andAuthDelegate:mockAuthDelegate];
}

- (void) testJiveInstance {
    
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    
    NSURL* originalJiveInstance = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    
    jive = [[Jive alloc] initWithJiveInstance:originalJiveInstance
                        authorizationDelegate:mockAuthDelegate];
    
    NSURL* configuredJiveInstance = [jive jiveInstanceURL];
    
    STAssertNotNil(configuredJiveInstance, @"jiveInstance URL should never be nil");
    STAssertTrue([[configuredJiveInstance absoluteString] isEqualToString:[originalJiveInstance absoluteString]], @"Configured URL does not match original URL");
}

- (void) testInbox {
    [self createJiveAPIObjectWithResponse:@"inbox_response"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inbox:nil onComplete:^(NSArray *inboxEntries, NSDate *earliestDate, NSDate *latestDate) {
            STAssertNotNil(inboxEntries, @"InboxEntries where nil!");
            STAssertTrue([inboxEntries count] == 28, @"Incorrect number of inbox entries where returned");
            
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
        NSOperation *operation = [jive inboxOperation:nil onComplete:^(NSArray *inboxEntries, NSDate *earliestDate, NSDate *latestDate) {
            STAssertNotNil(inboxEntries, @"InboxEntries where nil!");
            STAssertTrue([inboxEntries count] == 28, @"Incorrect number of inbox entries where returned");
            
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
        [jive inbox:nil onComplete:^(NSArray *inboxEntries, NSDate *earliestDate, NSDate *latestDate) {
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
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"POST"
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/contents/370230/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"POST"
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
        [jive inbox:nil onComplete:^(NSArray *inboxEntries, NSDate *earliestDate, NSDate *latestDate) {
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
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"POST"
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/dms/153160/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"POST"
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
        [jive inbox:nil onComplete:^(NSArray *inboxEntries, NSDate *earliestDate, NSDate *latestDate) {
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
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"DELETE"
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/dms/153160/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"DELETE"
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
        [jive inbox:nil onComplete:^(NSArray *inboxEntries, NSDate *earliestDate, NSDate *latestDate) {
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
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"DELETE"
                                                                    forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/dms/153160/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"DELETE"
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
        [jive inbox:nil onComplete:^(NSArray *inboxEntries, NSDate *earliestDate, NSDate *latestDate) {
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
    
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"POST"
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
        [jive inbox:nil onComplete:^(NSArray *inboxEntries, NSDate *earliestDate, NSDate *latestDate) {
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
                     forRequestWithHTTPMethod:@"DELETE"
                                       forURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/dms/153160/read"]];
    [mockJiveURLResponseDelegate2 expectNoResponseForRequestWithHTTPMethod:@"DELETE"
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

- (void) testMyOperation {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@me" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"my_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive meOperation:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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

- (void) testMyServiceCall {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@me" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"my_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive me:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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

- (void) testColleguesOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@colleagues?startIndex=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive colleguesOperation:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)9, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testColleguesServiceCall {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive followersOperation:source onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testFollowersServiceCall {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@followers?count=10&startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive followersOperation:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testFollowersServiceCallWithOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 0;
    options.count = 5;
    [options addField:@"dummy"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    options.sort = JiveSortOrderUpdatedDesc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/people?sort=updatedDesc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_people_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive searchPeopleRequestOperation:options onComplete:^(NSArray *people) {
            STAssertEquals([people count], (NSUInteger)13, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testSearchPeopleServiceCall {
    JiveSearchPeopleRequestOptions *options = [[JiveSearchPeopleRequestOptions alloc] init];
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    options.sort = JiveSortOrderUpdatedDesc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/places?sort=updatedDesc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_places_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation =  [jive searchPlacesRequestOperation:options onComplete:^(NSArray *places) {
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
        [operation start];
    }];
}

- (void) testSearchPlacesServiceCall {
    JiveSearchPlacesRequestOptions *options = [[JiveSearchPlacesRequestOptions alloc] init];
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    options.sort = JiveSortOrderUpdatedDesc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/search/contents?sort=updatedDesc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_contents_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive searchContentsRequestOperation:options onComplete:^(NSArray *contents) {
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
        [operation start];
    }];
}

- (void) testSearchContentsServiceCall {
    JiveSearchContentsRequestOptions *options = [[JiveSearchContentsRequestOptions alloc] init];
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    options.sort = JiveSortOrderDateJoinedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people?sort=dateJoinedAsc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive peopleOperation:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testPeopleServiceCall {
    JivePeopleRequestOptions *options = [[JivePeopleRequestOptions alloc] init];
    options.sort = JiveSortOrderDateJoinedDesc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive personOperation:source withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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

- (void) testPersonServiceCall {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/email/email_test?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive personByEmailOperation:@"email_test" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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

- (void) testPersonByEmail {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/email/test_email?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive personByEmail:@"test_email" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/username/Name?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive personByUserNameOperation:@"Name" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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

- (void) testPersonByUserName {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/username/UserName?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive personByUserName:@"UserName" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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
    options.count = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/recommended?count=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_people" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive recommendedPeopleOperation:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)1, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testRecommendedPeople {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/recommended?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_people" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive recommendedPeople:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)1, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/@resources" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"resource_info" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive resourcesOperation:^(NSArray *resources) {
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
        [operation start];
    }];
}

- (void) testResources {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/trending?filter=place(https://brewspace.jiveland.com/api/core/v3/places/1234)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"trending_people" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive trendingOperation:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)25, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testTrendingPeople {
    JiveTrendingPeopleRequestOptions *options = [[JiveTrendingPeopleRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/activities?after=1970-01-01T00%3A00%3A00.123%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive activitiesOperation:source withOptions:options onComplete:^(NSArray *activities) {
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

- (void) testPersonActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/blog?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"blog" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive blogOperation:source withOptions:options onComplete:^(JiveBlog *blog) {
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
        [operation start];
    }];
}

- (void) testGetBlog {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@manager?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive managerOperation:source withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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

- (void) testGetManager {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    options.count = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@reports?count=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive reportsOperation:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testGetReports {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    options.count = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@following?count=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive followingOperation:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testGetFollowing {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@reports/1876?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive person:@"8192" reportsOperation:@"1876" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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

- (void) testGetReportsFrom {
    
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@reports/5630?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive person:@"2918" reports:@"5630" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents?filter=author(http://person.com/dummy)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"contents" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive contentsOperation:options onComplete:^(NSArray *contents) {
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
        [operation start];
    }];
}

- (void) testGetContents {
    JiveContentRequestOptions *options = [[JiveContentRequestOptions alloc] init];
    [options addAuthor:[NSURL URLWithString:@"http://dummy.com/person"]];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/popular?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"contents" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive popularContentsOperation:options onComplete:^(NSArray *contents) {
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
        [operation start];
    }];
}

- (void) testGetPopularContents {
    
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/recommended?count=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"contents" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive recommendedContentsOperation:options onComplete:^(NSArray *contents) {
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
        [operation start];
    }];
}

- (void) testGetRecommendedContents {
    
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/trending?filter=type(blog)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"contents" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive trendingContentsOperation:options onComplete:^(NSArray *contents) {
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
        [operation start];
    }];
}

- (void) testGetTrendingContents {
    
    JiveTrendingContentRequestOptions *options = [[JiveTrendingContentRequestOptions alloc] init];
    [options addType:@"discussion"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive contentOperation:source withOptions:options onComplete:^(JiveContent *content) {
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
        [operation start];
    }];
}

- (void) testGetContentsByID {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/comments?excludeReplies=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_comments" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive commentsOperationForContent:source withOptions:options onComplete:^(NSArray *comments) {
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
        [operation start];
    }];
}

- (void) testGetCommentsForContent {
    
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    options.hierarchical = YES;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    options.startIndex = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/likes?startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive contentLikedByOperation:source withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
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

- (void) testGetContentLikes {
    
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/recommended?count=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive recommendedPlacesOperation:options onComplete:^(NSArray *places) {
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
        [operation start];
    }];
}

- (void) testGetRecommendedPlaces {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/trending?count=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive trendingPlacesOperation:options onComplete:^(NSArray *places) {
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
        [operation start];
    }];
}

- (void) testGetTrendingPlaces {
    JiveCountRequestOptions *options = [[JiveCountRequestOptions alloc] init];
    options.count = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places?filter=entityDescriptor(12,4321)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"places" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive placesOperation:options onComplete:^(NSArray *places) {
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
        [operation start];
    }];
}

- (void) testGetPlaces {
    JivePlacesRequestOptions *options = [[JivePlacesRequestOptions alloc] init];
    [options addEntityType:@"37" descriptor:@"2345"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191/places?filter=type(question)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive placePlacesOperation:source withOptions:options onComplete:^(NSArray *places) {
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
        [operation start];
    }];
}

- (void) testGetPlacesPlaces {
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    [options addType:@"blog"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive placeOperation:source withOptions:options onComplete:^(JivePlace *place) {
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
        [operation start];
    }];
}

- (void) testGetPlaceById {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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

- (void) testGetPlaceByURLOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation *operation = [jive placeOperationWithURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/places/95191"]
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
        
        [operation start];
    }];
}

- (void) testPlaceActivitiesOperation {
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:1.234];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191/activities?after=1970-01-01T00%3A00%3A01.234%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place_activities" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive placeActivitiesOperation:source withOptions:options onComplete:^(NSArray *activities) {
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
        [operation start];
    }];
}

- (void) testPlaceActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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

- (void) testMemberWithMember {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar"
                                                                           password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive deletePersonOperation:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(@"DELETE", operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeletePersonServiceCall {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
//    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
//    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/followingIn?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive followingInOperation:source withOptions:options onComplete:^(NSArray *streams) {
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
        [operation start];
    }];
}

- (void) testFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive streamOperation:source withOptions:options onComplete:^(JiveStream *stream) {
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
        [operation start];
    }];
}

- (void) testStream {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/activities?after=1970-01-01T00%3A00%3A00.123%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream_activities" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive streamActivitiesOperation:source withOptions:options onComplete:^(NSArray *activities) {
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
        [operation start];
    }];
}

- (void) testStreamActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/connections/activities?after=1970-01-01T00%3A00%3A00.123%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream_activities" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive streamConnectionsActivitiesOperation:options onComplete:^(NSArray *activities) {
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
        [operation start];
    }];
}

- (void) testStreamConnectionsActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive deleteStreamOperation:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(@"DELETE", operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeleteStreamServiceCall {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/streams?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_streams" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive streamsOperation:source withOptions:options onComplete:^(NSArray *streams) {
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
        [operation start];
    }];
}

- (void) testPersonStreams {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/tasks?sort=titleAsc" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_tasks" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive tasksOperation:source withOptions:options onComplete:^(NSArray *tasks) {
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
        [operation start];
    }];
}

- (void) testPersonTasks {
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderLatestActivityDesc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191/followingIn?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive placeFollowingInOperation:source withOptions:options onComplete:^(NSArray *streams) {
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
        [operation start];
    }];
}

- (void) testPlacesFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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

- (void) testContentsFollowingInOperation {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/followingIn?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive contentFollowingInOperation:source withOptions:options onComplete:^(NSArray *streams) {
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
        [operation start];
    }];
}

- (void) testContentsFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations?filter=type(dm)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream_associations" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive streamAssociationsOperation:source withOptions:options onComplete:^(NSArray *associations) {
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
        [operation start];
    }];
}

- (void) testStreamAssociationsOperationWithPeopleAndPlaces {
    JiveStream *source = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveAssociationsRequestOptions *options = [[JiveAssociationsRequestOptions alloc] init];
    [options addType:@"dm"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations?filter=type(dm)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream_associations_alt" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive streamAssociationsOperation:source withOptions:options onComplete:^(NSArray *associations) {
            NSUInteger associationsCount = [associations count];
            STAssertEquals(associationsCount, (NSUInteger)3, @"Wrong number of items parsed");
            if (associationsCount >= 3) {
                STAssertTrue([[associations objectAtIndex:0] isKindOfClass:[JivePerson class]], @"Wrong first item class");
                STAssertTrue([[associations objectAtIndex:1] isKindOfClass:[JiveGroup class]], @"Wrong second item class");
                STAssertTrue([[associations objectAtIndex:2] isKindOfClass:[JiveBlog class]], @"Wrong third item class");
            }
            
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

- (void) testStreamAssociations {
    JiveAssociationsRequestOptions *options = [[JiveAssociationsRequestOptions alloc] init];
    [options addType:@"message"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    source.name = @"changed name";
    source.receiveEmails = [NSNumber numberWithBool:YES];
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive updateStreamOperation:source withOptions:options onComplete:^(JiveStream *stream) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/members/36391?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"member" andAuthDelegate:mockAuthDelegate];
    
    source.state = @"owner";
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive updateMemberOperation:source withOptions:options onComplete:^(JiveMember *member) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive contentOperation:source markAsRead:YES onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        [operation start];
    }];
}

- (void) testContentMarkAsRead {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/read" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive contentOperation:source markAsRead:NO onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"DELETE", @"Wrong http method used");
        [operation start];
    }];
}

- (void) testContentMarkAsRead_unread {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive contentOperation:source likes:YES onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        [operation start];
    }];
}

- (void) testContentLikes {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/likes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive contentOperation:source likes:NO onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"DELETE", @"Wrong http method used");
        [operation start];
    }];
}

- (void) testContentLikes_unread {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive deleteContentOperation:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"DELETE", @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeleteContent {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088?minor=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    source.subject = @"subject";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive updateContentOperation:source withOptions:options onComplete:^(JiveContent *content) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    source.displayName = @"displayName";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive updatePlaceOperation:source withOptions:options onComplete:^(JivePlace *place) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    source.location = @"location";
    
    NSDictionary *JSON = [source toJSONDictionary];
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive updatePersonOperation:source onComplete:^(JivePerson *person) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testUpdatePerson {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@following/5316" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive personOperation:source follow:target onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
        [operation start];
    }];
}

- (void) testFollowPerson {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/actions?after=1970-01-01T00%3A00%3A00.123%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive actionsOperation:options onComplete:^(NSArray *activities) {
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

- (void) testActions {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/messages/582073/messages?excludeReplies=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"messages" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive messagesOperationForContent:source withOptions:options onComplete:^(NSArray *messages) {
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
        [operation start];
    }];
}

- (void) testContentMessagesOperation_alternate {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/messages/contents/372124" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_messages" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive messagesOperationForContent:source withOptions:nil onComplete:^(NSArray *messages) {
            // Called 3rd
            STAssertEquals([messages count], (NSUInteger)4, @"Wrong number of items parsed");
            STAssertEquals([[messages objectAtIndex:0] class], [JiveMessage class], @"Wrong item class");
            
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

- (void) testGetMessage {
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    options.hierarchical = YES;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/places/95191?startIndex=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invites" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive invitesOperation:source withOptions:options onComplete:^(NSArray *invites) {
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
        [operation start];
    }];
}

- (void) testInvites {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/1234567?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invite_alternate" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSOperation* operation = [jive inviteOperation:source withOptions:options onComplete:^(JiveInvite *invite) {
            // Called 3rd
            STAssertTrue([[invite class] isSubclassOfClass:[JiveInvite class]], @"Wrong item class");
            STAssertEqualObjects(invite.invitee.displayName, @"Jennifer Klafin", @"Wrong invite returned.");
            
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

- (void) testGetInvite {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/1234567" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invite_alternate" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive deleteInviteOperation:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"DELETE", @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeleteInvite {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/1234567?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invite_alternate" andAuthDelegate:mockAuthDelegate];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive updateInviteOperation:source withState:JiveInviteRevoked andOptions:options onComplete:^(JiveInvite *invite) {
            // Called 3rd
            STAssertTrue([[invite class] isSubclassOfClass:[JiveInvite class]], @"Wrong item class");
            STAssertEqualObjects(invite.invitee.displayName, @"Jennifer Klafin", @"Wrong invite returned.");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testUpdateInvite {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createContentOperation:source withOptions:options onComplete:^(JiveContent *content) {
            // Called 3rd
            STAssertEquals([content class], [JiveUpdate class], @"Wrong item class");
            STAssertEqualObjects(content.subject, @"Battle Week is upon us... LET'S GO ZAGS!!!", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateContent {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/dms?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"direct_message_alternate" andAuthDelegate:mockAuthDelegate];
    source.content = [[JiveContentBody alloc] init];
    source.content.text = @"Testing a direct message";
    [targets addUserName:@"Orson Bushnell"];
    [targets addPerson:person];
    
    NSMutableDictionary *JSONDictionary = (NSMutableDictionary *)[source toJSONDictionary];
    
    [JSONDictionary setValue:[targets toJSONArray:YES] forKey:@"participants"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSONDictionary options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createDirectMessageOperation:source withTargets:targets andOptions:options onComplete:^(JiveContent *content) {
            // Called 3rd
            STAssertEquals([content class], [JiveDirectMessage class], @"Wrong item class");
            STAssertEqualObjects(content.subject, @"Heyo&#8211; can I get the email you prefer to use for Dropbox? I'll invite you to the Jive iPad share....", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateDirectMessage {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/invites/places/95191?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"invites" andAuthDelegate:mockAuthDelegate];
    [targets addUserName:@"Orson Bushnell"];
    [targets addPerson:person];
    
    NSMutableDictionary *JSONDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [JSONDictionary setValue:message forKey:@"body"];
    [JSONDictionary setValue:[targets toJSONArray:NO] forKey:@"invitees"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:JSONDictionary options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createInviteToOperation:source withMessage:message targets:targets andOptions:options onComplete:^(NSArray *invites) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateInvite {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people?welcome=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
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
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createPersonOperation:source withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            STAssertEqualObjects(person.location, @"home on the range", @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreatePerson {
    JiveWelcomeRequestOptions *options = [[JiveWelcomeRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/tasks?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    testTask.subject = @"subject";
    testTask.dueDate = [NSDate date];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[testTask toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createTaskOperation:testTask forPerson:source withOptions:options onComplete:^(JiveTask *task) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateTask {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191/tasks?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    testTask.subject = @"subject";
    testTask.dueDate = [NSDate date];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[testTask toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createTaskOperation:testTask forPlace:source withOptions:options onComplete:^(JiveTask *task) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreatePlaceTask {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    source.name = @"This is a test";
    source.parent = @"https://brewspace.jiveland.com/api/core/v3/places/301838";
    source.displayName = @"This is a test";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createPlaceOperation:source withOptions:options onComplete:^(JivePlace *place) {
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
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreatePlace {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/comments?author=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"comment" andAuthDelegate:mockAuthDelegate];
    source.content = [[JiveContentBody alloc] init];
    source.content.type = @"text/html";
    source.content.text = @"Comment";
    source.parent = @"https://brewspace.jiveland.com/api/core/v3/comments/484708";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createCommentOperation:source withOptions:options onComplete:^(JiveContent *comment) {
            // Called 3rd
            STAssertTrue([[comment class] isSubclassOfClass:[JiveComment class]], @"Wrong item class");
            STAssertEqualObjects(comment.content.text,
                                 @"<body><!-- [DocumentBodyStart:ddeb4d22-8d54-4f74-908a-a26732ff43e9] --><div class=\"jive-rendered-content\"><div><p><a class=\"jive-link-email-small\" href=\"mailto:heath.borders@gmail.com\">heath.borders@gmail.com</a><span> is my personal dropbox account. Is it common for people to use personal accounts? I could create an account with my jive email if that is more common.</span></p></div></div><!-- [DocumentBodyEnd:ddeb4d22-8d54-4f74-908a-a26732ff43e9] --></body>",
                                 @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateComment {
    JiveAuthorCommentRequestOptions *options = [[JiveAuthorCommentRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372088/outcomes" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"outcome" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JiveOutcome *source = [self entityForClass:[JiveOutcome class] fromJSONNamed:@"outcome"];
        JiveContent *content = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
        
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createOutcomeOperation:source forContent:content onComplete:^(JiveOutcome *outcome) {
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
        
        [operation start];
    }];
}

- (void) testCreateOutcome {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/messages?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"message" andAuthDelegate:mockAuthDelegate];
    source.content = [[JiveContentBody alloc] init];
    source.content.type = @"text/html";
    source.content.text = @"Comment";
    source.parent = @"https://brewspace.jiveland.com/api/core/v3/comments/484708";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createMessageOperation:source withOptions:options onComplete:^(JiveContent *comment) {
            // Called 3rd
            STAssertTrue([[comment class] isSubclassOfClass:[JiveMessage class]], @"Wrong item class");
            STAssertEqualObjects(comment.content.text,
                                 @"<body><!-- [DocumentBodyStart:1e47eba0-4637-4440-a7e6-f297b991c758] --><div class=\"jive-rendered-content\"><p>Do you know what's driving 4/15?</p></div><!-- [DocumentBodyEnd:1e47eba0-4637-4440-a7e6-f297b991c758] --></body>",
                                 @"New object not created");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateMessage {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/streams?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream_alternate" andAuthDelegate:mockAuthDelegate];
    
    source.name = @"new stream";
    source.receiveEmails = [NSNumber numberWithBool:YES];
    NSData *body = [NSJSONSerialization dataWithJSONObject:[source toJSONDictionary] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createStreamOperation:source forPerson:person withOptions:options onComplete:^(JiveStream *stream) {
            // Called 3rd
            STAssertTrue([[stream class] isSubclassOfClass:[JiveStream class]], @"Wrong item class");
            STAssertEqualObjects(stream.name, @"Test stream", @"Wrong stream name");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateStream {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations/person/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"stream" andAuthDelegate:mockAuthDelegate];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive deleteAssociationOperation:association fromStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"DELETE", @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeleteStreamAssociationWithObject {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    [targetList addAssociationTarget:association];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[targetList toJSONArray] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createAssociationsOperation:targetList forStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
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
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/streams/10872/associations" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"task" andAuthDelegate:mockAuthDelegate];
    [targetList addAssociationTarget:association1];
    [targetList addAssociationTarget:association2];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:[targetList toJSONArray] options:0 error:nil];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive createAssociationsOperation:targetList forStream:source onComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        [operation start];
    }];
}

- (void) testCreateStreamAssociations {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
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

- (void) testGetVersionOperationForInstance {
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"version" ofType:@"json"];
    
    mockJiveURLResponseDelegate = [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[Jive getVersionOperationForInstance:url
                                                                                            onComplete:^(JivePlatformVersion *version) {
                                                                                                STAssertEqualObjects(version.major, @7, @"Wrong version found");
                                                                                                STAssertEqualObjects(((JiveCoreVersion *)version.coreURI[0]).version, @2, @"Wrong core uri version found");
                                                                                                [mockJiveURLResponseDelegate verify];
                                                                                                finishedBlock();
                                                                                            } onError:^(NSError *error) {
                                                                                                STFail([error localizedDescription]);
                                                                                                finishedBlock();
                                                                                            }];
        
        [operation start];
    }];
}

- (void) testGetVersionForInstance {
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"version_alternate" ofType:@"json"];
    
    mockJiveURLResponseDelegate = [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [Jive getVersionForInstance:url
                         onComplete:^(JivePlatformVersion *version) {
                             STAssertEqualObjects(version.major, @6, @"Wrong version found");
                             STAssertEqualObjects(((JiveCoreVersion *)version.coreURI[0]).version, @2, @"Wrong core uri version found");
                             [mockJiveURLResponseDelegate verify];
                             finishedBlock();
                         } onError:^(NSError *error) {
                             STFail([error localizedDescription]);
                             finishedBlock();
                         }];
    }];
}

- (void) testGetVersionOperationForInstanceReturnsErrorIfNoV3API {
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"version_no_v3" ofType:@"json"];
    
    mockJiveURLResponseDelegate = [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JAPIRequestOperation *operation = (JAPIRequestOperation *)[Jive getVersionOperationForInstance:url
                                                                                            onComplete:^(JivePlatformVersion *version) {
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
                                                                                            } onError:^(NSError *error) {
                                                                                                STAssertEquals(error.code, JiveErrorCodeUnsupportedJivePlatformVersion, @"Wrong error code reported");
                                                                                                STAssertNotNil(error.userInfo[JiveErrorKeyJivePlatformVersion], @"Missing JivePlatformVersion");
                                                                                                [mockJiveURLResponseDelegate verify];
                                                                                                finishedBlock();
                                                                                            }];
        
        [operation start];
    }];
}

@end
