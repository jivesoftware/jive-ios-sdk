//
//  jive_api_tests.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "jive_api_tests.h"

#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>

#import "JiveCredentials.h"
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

- (void) testInboxServiceCall {
    [self createJiveAPIObjectWithResponse:@"inbox_response"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inbox:nil onComplete:^(NSArray *inboxEntries) {
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

- (void) testMarkAsReadWithTwoUnread {
    mockAuthDelegate = [OCMockObject mockJiveAuthorizationDelegate];
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"https://brewspace.jiveland.com"]
                        authorizationDelegate:mockAuthDelegate];
    mockJiveURLResponseDelegate2 = [OCMockObject mockJiveURLResponseDelegate2];
    [mockJiveURLResponseDelegate2 expectResponseWithContentsOfJSONFileNamed:@"inbox_mark_response"
                                                       bundledWithTestClass:[self class]
                                                          forRequestWithURL:[NSURL URLWithString:@"https://brewspace.jiveland.com/api/core/v3/inbox"]];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:mockJiveURLResponseDelegate2];
    
    __block NSArray *inboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inbox:nil onComplete:^(NSArray *returnedInboxEntries) {
            inboxEntries = returnedInboxEntries;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
    [inboxEntries objectAtIndex:1],
    [inboxEntries objectAtIndex:11],
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
    
    __block NSArray *inboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inbox:nil onComplete:^(NSArray *returnedInboxEntries) {
            inboxEntries = returnedInboxEntries;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
    [inboxEntries objectAtIndex:0],
    [inboxEntries objectAtIndex:1],
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
    
    __block NSArray *inboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inbox:nil onComplete:^(NSArray *returnedInboxEntries) {
            inboxEntries = returnedInboxEntries;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
    [inboxEntries objectAtIndex:0],
    [inboxEntries objectAtIndex:1],
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
    
    __block NSArray *inboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inbox:nil onComplete:^(NSArray *returnedInboxEntries) {
            inboxEntries = returnedInboxEntries;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
    [inboxEntries objectAtIndex:0],
    [inboxEntries objectAtIndex:8],
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
    
    __block NSArray *inboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inbox:nil onComplete:^(NSArray *returnedInboxEntries) {
            inboxEntries = returnedInboxEntries;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
    [inboxEntries objectAtIndex:1],
    [inboxEntries objectAtIndex:2],
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
    
    __block NSArray *inboxEntries = nil;
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive inbox:nil onComplete:^(NSArray *returnedInboxEntries) {
            inboxEntries = returnedInboxEntries;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
        }];
    }];
    
    
    NSArray *markingInboxEntries = @[
    [inboxEntries objectAtIndex:0],
    [inboxEntries objectAtIndex:8],
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
    
    NSOperation* operation = [jive meOperation:^(JivePerson *person) {
        // Called 3rd
        STAssertEquals([person class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
        }];
    }];
}

- (void) testColleguesOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@colleagues?startIndex=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive colleguesOperation:@"8192" withOptions:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)9, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testColleguesServiceCall {    
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@colleagues?startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive collegues:@"2918" withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)9, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testFollowersOperation {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@followers" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive followersOperation:@"8192" onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testFollowersServiceCall {    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@followers" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive followers:@"2918" onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testFollowersServiceCallUsesPersonID {
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@followers" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive followers:@"8192" onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testFollowersOperationWithOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    options.count = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@followers?count=10&startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive followersOperation:@"2918" withOptions:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testFollowersServiceCallWithOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 0;
    options.count = 5;
    [options addField:@"dummy"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@followers?fields=dummy&count=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive followers:@"8192" withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@followers?fields=dummy,second,third&count=3&startIndex=6" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"followers_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive followers:@"8192" withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
    
    NSOperation* operation = [jive searchPeopleRequestOperation:options onComplete:^(NSArray *people) {
        STAssertEquals([people count], (NSUInteger)13, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation =  [jive searchPlacesRequestOperation:options onComplete:^(NSArray *places) {
        // Called 3rd
        STAssertEquals([places count], (NSUInteger)10, @"Wrong number of items parsed");
        STAssertTrue([[places objectAtIndex:0] isKindOfClass:[JivePlace class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive searchContentsRequestOperation:options onComplete:^(NSArray *contents) {
        // Called 3rd
        STAssertEquals([contents count], (NSUInteger)7, @"Wrong number of items parsed");
        STAssertTrue([[contents objectAtIndex:0] isKindOfClass:[JiveContent class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive peopleOperation:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
        }];
    }];
}

- (void) testPersonOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2203?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive personOperation:@"2203" withOptions:options onComplete:^(JivePerson *person) {
        // Called 3rd
        STAssertEquals([person class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testPersonServiceCall {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3220?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive person:@"3220" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
    
    NSOperation* operation = [jive filterableFieldsOperation:^(NSArray *fields) {
        // Called 3rd
        CFStringRef referenceString = CFStringCreateWithCString(nil, "a", kCFStringEncodingMacRoman); // Make a real CFStringRef not a CFConstStringRef
        STAssertEquals([fields count], (NSUInteger)6, @"Wrong number of items parsed");
        STAssertEquals([[fields objectAtIndex:0] class], [(__bridge NSString *)referenceString class], @"Wrong item class");
        CFRelease(referenceString);
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive supportedFieldsOperation:^(NSArray *fields) {
        // Called 3rd
        CFStringRef referenceString = CFStringCreateWithCString(nil, "a", kCFStringEncodingMacRoman); // Make a real CFStringRef not a CFConstStringRef
        STAssertEquals([fields count], (NSUInteger)18, @"Wrong number of items parsed");
        STAssertEquals([[fields objectAtIndex:0] class], [(__bridge NSString *)referenceString class], @"Wrong item class");
        CFRelease(referenceString);
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive personByEmailOperation:@"email_test" withOptions:options onComplete:^(JivePerson *person) {
        // Called 3rd
        STAssertEquals([person class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive personByUserNameOperation:@"Name" withOptions:options onComplete:^(JivePerson *person) {
        // Called 3rd
        STAssertEquals([person class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive recommendedPeopleOperation:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)1, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive resourcesOperation:^(NSArray *resources) {
        // Called 3rd
        STAssertEquals([resources count], (NSUInteger)19, @"Wrong number of items parsed");
        STAssertEquals([[resources objectAtIndex:0] class], [JiveResource class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive trendingOperation:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)25, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
        }];
    }];
}

- (void) testPersonActivitiesOperation {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/activities?after=1970-01-01T00%3A00%3A00.123%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive activitiesOperation:@"8192" withOptions:options onComplete:^(NSArray *activities) {
        // Called 3rd
        STAssertEquals([activities count], (NSUInteger)23, @"Wrong number of items parsed");
        STAssertEquals([[activities objectAtIndex:0] class], [JiveInboxEntry class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testPersonActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/activities?after=1970-01-01T00%3A00%3A00.000%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive activities:@"2918" withOptions:options onComplete:^(NSArray *activities) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveInboxEntry class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testGetBlogOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/blog?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"blog" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive blogOperation:@"8192" withOptions:options onComplete:^(JiveBlog *blog) {
        // Called 3rd
        STAssertEquals([blog class], [JiveBlog class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testGetBlog {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/blog?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"blog" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive blog:@"2918" withOptions:options onComplete:^(JiveBlog *blog) {
            // Called 3rd
            STAssertEquals([blog class], [JiveBlog class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testGetManagerOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@manager?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive managerOperation:@"8192" withOptions:options onComplete:^(JivePerson *person) {
        // Called 3rd
        STAssertEquals([person class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testGetManager {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@manager?fields=name,id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive manager:@"2918" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testGetReportsOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@reports?count=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive reportsOperation:@"8192" withOptions:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testGetReports {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@reports?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive reports:@"2918" withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testGetFollowingOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/8192/@following?count=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive followingOperation:@"8192" withOptions:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testGetFollowing {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/@following?count=3" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive following:@"2918" withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
    
    NSOperation* operation = [jive person:@"8192" reportsOperation:@"1876" withOptions:options onComplete:^(JivePerson *person) {
        // Called 3rd
        STAssertEquals([person class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive contentsOperation:options onComplete:^(NSArray *contents) {
        // Called 3rd
        STAssertEquals([contents count], (NSUInteger)25, @"Wrong number of items parsed");
        STAssertTrue([[[contents objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive popularContentsOperation:options onComplete:^(NSArray *contents) {
        // Called 3rd
        STAssertEquals([contents count], (NSUInteger)25, @"Wrong number of items parsed");
        STAssertTrue([[[contents objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive recommendedContentsOperation:options onComplete:^(NSArray *contents) {
        // Called 3rd
        STAssertEquals([contents count], (NSUInteger)25, @"Wrong number of items parsed");
        STAssertTrue([[[contents objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive trendingContentsOperation:options onComplete:^(NSArray *contents) {
        // Called 3rd
        STAssertEquals([contents count], (NSUInteger)25, @"Wrong number of items parsed");
        STAssertTrue([[[contents objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
        }];
    }];
}

- (void) testGetContentsByIDOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/456789?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive contentOperation:@"456789" withOptions:options onComplete:^(JiveContent *content) {
        // Called 3rd
        STAssertEquals([content class], [JiveUpdate class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testGetContentsByID {
    
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
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
        [jive content:@"372124" withOptions:options onComplete:^(JiveContent *content) {
            // Called 3rd
            STAssertEquals([content class], [JiveUpdate class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testGetCommentsForContentOperation {
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    options.excludeReplies = YES;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/456789/comments?excludeReplies=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_comments" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive commentsForContentOperation:@"456789" withOptions:options onComplete:^(NSArray *comments) {
        // Called 3rd
        STAssertEquals([comments count], (NSUInteger)23, @"Wrong number of items parsed");
        STAssertTrue([[[comments objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testGetCommentsForContent {
    
    JiveCommentsRequestOptions *options = [[JiveCommentsRequestOptions alloc] init];
    options.hierarchical = YES;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372098/comments?hierarchical=true" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_comments" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive commentsForContent:@"372098" withOptions:options onComplete:^(NSArray *comments) {
            // Called 3rd
            STAssertEquals([comments count], (NSUInteger)23, @"Wrong number of items parsed");
            STAssertTrue([[[comments objectAtIndex:0] class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testGetContentLikesOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/456789/likes?startIndex=10" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive contentLikedByOperation:@"456789" withOptions:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testGetContentLikes {
    
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372098/likes?startIndex=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive contentLikedBy:@"372098" withOptions:options onComplete:^(NSArray *people) {
            // Called 3rd
            STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
            STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
    
    NSOperation* operation = [jive recommendedPlacesOperation:options onComplete:^(NSArray *places) {
        // Called 3rd
        STAssertEquals([places count], (NSUInteger)7, @"Wrong number of items parsed");
        STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive trendingPlacesOperation:options onComplete:^(NSArray *places) {
        // Called 3rd
        STAssertEquals([places count], (NSUInteger)7, @"Wrong number of items parsed");
        STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive placesOperation:options onComplete:^(NSArray *places) {
        // Called 3rd
        STAssertEquals([places count], (NSUInteger)25, @"Wrong number of items parsed");
        STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
        }];
    }];
}

- (void) testGetPlacesPlacesOperation {
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    [options addType:@"question"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/87654/places?filter=type(question)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive placePlacesOperation:@"87654" withOptions:options onComplete:^(NSArray *places) {
        // Called 3rd
        STAssertEquals([places count], (NSUInteger)7, @"Wrong number of items parsed");
        STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
}

- (void) testGetPlacesPlaces {
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    [options addType:@"blog"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/12345/places?filter=type(blog)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive placePlaces:@"12345" withOptions:options onComplete:^(NSArray *places) {
            // Called 3rd
            STAssertEquals([places count], (NSUInteger)7, @"Wrong number of items parsed");
            STAssertTrue([[[places objectAtIndex:0] class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testGetPlaceByIdOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/87654?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive placeOperation:@"87654" withOptions:options onComplete:^(JivePlace *place) {
        // Called 3rd
        STAssertTrue([[place class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
        [jive place:@"301838" withOptions:options onComplete:^(JivePlace *place) {
            // Called 3rd
            STAssertTrue([[place class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
}

- (void) testPlaceActivitiesOperation {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:1.234];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/87654/activities?after=1970-01-01T00%3A00%3A01.234%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"place_activities" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive placeActivitiesOperation:@"87654" withOptions:options onComplete:^(NSArray *activities) {
        // Called 3rd
        STAssertEquals([activities count], (NSUInteger)27, @"Wrong number of items parsed");
        STAssertEquals([[activities objectAtIndex:0] class], [JiveInboxEntry class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
        [jive placeActivities:@"301838" withOptions:options onComplete:^(NSArray *activities) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)27, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveInboxEntry class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
        JiveMember *member = [self entityForClass:[JiveMember class]
                                    fromJSONNamed:@"member"];
        [jive memberWithMember:member
                       options:nil
                    onComplete:(^(JiveMember *member) {
            STAssertNotNil(member, nil);
            finishedBlock();
        })
                       onError:(^(NSError *error) {
            STFail([error localizedDescription]);
        })];
    }];
}

@end
