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
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/@colleagues?startIndex=5" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive colleguesOperation:source withOptions:options onComplete:^(NSArray *people) {
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
    
    NSOperation* operation = [jive followersOperation:source onComplete:^(NSArray *people) {
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
    
    NSOperation* operation = [jive followersOperation:source withOptions:options onComplete:^(NSArray *people) {
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
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive personOperation:source withOptions:options onComplete:^(JivePerson *person) {
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
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/activities?after=1970-01-01T00%3A00%3A00.123%2B0000" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_activities" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive activitiesOperation:source withOptions:options onComplete:^(NSArray *activities) {
        // Called 3rd
        STAssertEquals([activities count], (NSUInteger)23, @"Wrong number of items parsed");
        STAssertEquals([[activities objectAtIndex:0] class], [JiveActivityObject class], @"Wrong item class");
        
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
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivityObject class], @"Wrong item class");
            
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
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550/blog?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"blog" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive blogOperation:source withOptions:options onComplete:^(JiveBlog *blog) {
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
    
    NSOperation* operation = [jive managerOperation:source withOptions:options onComplete:^(JivePerson *person) {
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
    
    NSOperation* operation = [jive reportsOperation:source withOptions:options onComplete:^(NSArray *people) {
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
    
    NSOperation* operation = [jive followingOperation:source withOptions:options onComplete:^(NSArray *people) {
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
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/contents/372124?fields=id" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"content_by_id" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive contentOperation:source withOptions:options onComplete:^(JiveContent *content) {
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
    
    NSOperation* operation = [jive commentsOperationForContent:source withOptions:options onComplete:^(NSArray *comments) {
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
    
    NSOperation* operation = [jive contentLikedByOperation:source withOptions:options onComplete:^(NSArray *people) {
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
    JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place_alternate"];
    JivePlacePlacesRequestOptions *options = [[JivePlacePlacesRequestOptions alloc] init];
    [options addType:@"question"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/places/95191/places?filter=type(question)" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"recommended_places" andAuthDelegate:mockAuthDelegate];
    
    NSOperation* operation = [jive placePlacesOperation:source withOptions:options onComplete:^(NSArray *places) {
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
    
    NSOperation* operation = [jive placeOperation:source withOptions:options onComplete:^(JivePlace *place) {
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
        }];
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
    
    NSOperation* operation = [jive placeActivitiesOperation:source withOptions:options onComplete:^(NSArray *activities) {
        // Called 3rd
        STAssertEquals([activities count], (NSUInteger)27, @"Wrong number of items parsed");
        STAssertEquals([[activities objectAtIndex:0] class], [JiveActivityObject class], @"Wrong item class");
        
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
        JivePlace *source = [self entityForClass:[JivePlace class] fromJSONNamed:@"place"];
        [jive placeActivities:source withOptions:options onComplete:^(NSArray *activities) {
            // Called 3rd
            STAssertEquals([activities count], (NSUInteger)27, @"Wrong number of items parsed");
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivityObject class], @"Wrong item class");
            
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

- (void) testDeletePersonOperation {
    JivePerson *source = [self entityForClass:[JivePerson class] fromJSONNamed:@"alt_person_response"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/3550" isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"person_response" andAuthDelegate:mockAuthDelegate];
    
    JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive deletePersonOperation:source onComplete:^() {
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(@"DELETE", operation.request.HTTPMethod, @"Wrong http method used");
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive followingInOperation:source withOptions:options onComplete:^(NSArray *streams) {
        // Called 3rd
        STAssertEquals([streams count], (NSUInteger)1, @"Wrong number of items parsed");
        STAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive streamOperation:source withOptions:options onComplete:^(JiveStream *stream) {
        // Called 3rd
        STAssertTrue([[stream class] isSubclassOfClass:[JiveStream class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive streamActivitiesOperation:source withOptions:options onComplete:^(NSArray *activities) {
        // Called 3rd
        STAssertEquals([activities count], (NSUInteger)32, @"Wrong number of items parsed");
        STAssertEquals([[activities objectAtIndex:0] class], [JiveActivityObject class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivityObject class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
    
    NSOperation* operation = [jive streamConnectionsActivitiesOperation:options onComplete:^(NSArray *activities) {
        // Called 3rd
        STAssertEquals([activities count], (NSUInteger)32, @"Wrong number of items parsed");
        STAssertEquals([[activities objectAtIndex:0] class], [JiveActivityObject class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
            STAssertEquals([[activities objectAtIndex:0] class], [JiveActivityObject class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
    
    JAPIRequestOperation *operation = (JAPIRequestOperation *)[jive deleteStreamOperation:source onComplete:^() {
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(@"DELETE", operation.request.HTTPMethod, @"Wrong http method used");
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive streamsOperation:source withOptions:options onComplete:^(NSArray *streams) {
        // Called 3rd
        STAssertEquals([streams count], (NSUInteger)5, @"Wrong number of items parsed");
        STAssertEquals([[streams objectAtIndex:0] class], [JiveStream class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive tasksOperation:source withOptions:options onComplete:^(NSArray *tasks) {
        // Called 3rd
        STAssertEquals([tasks count], (NSUInteger)1, @"Wrong number of items parsed");
        STAssertEquals([[tasks objectAtIndex:0] class], [JiveTask class], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive placeFollowingInOperation:source withOptions:options onComplete:^(NSArray *streams) {
        // Called 3rd
        STAssertEquals([streams count], (NSUInteger)1, @"Wrong number of items parsed");
        STAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive contentFollowingInOperation:source withOptions:options onComplete:^(NSArray *streams) {
        // Called 3rd
        STAssertEquals([streams count], (NSUInteger)1, @"Wrong number of items parsed");
        STAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
    
    NSOperation* operation = [jive streamAssociationsOperation:source withOptions:options onComplete:^(NSArray *associations) {
        // Called 3rd
        STAssertEquals([associations count], (NSUInteger)25, @"Wrong number of items parsed");
        STAssertTrue([[associations objectAtIndex:0] isKindOfClass:[JiveContent class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self runOperation:operation];
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
            STAssertEquals([associations count], (NSUInteger)25, @"Wrong number of items parsed");
            STAssertTrue([[associations objectAtIndex:0] isKindOfClass:[JiveContent class]], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
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
    JAPIRequestOperation* operation = (JAPIRequestOperation *)[jive updateStreamOperation:source withOptions:options onComplete:^(JiveStream *stream) {
        // Called 3rd
        STAssertTrue([[stream class] isSubclassOfClass:[JiveStream class]], @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
    STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http method used");
    [self runOperation:operation];
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
    JAPIRequestOperation* operation = (JAPIRequestOperation *)[jive updateMemberOperation:source withOptions:options onComplete:^(JiveMember *member) {
        // Called 3rd
        STAssertTrue([[member class] isSubclassOfClass:[JiveMember class]], @"Wrong item class");
        STAssertEqualObjects(@"member", member.state, @"New object not created");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
    STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http method used");
    [self runOperation:operation];
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
    
    JAPIRequestOperation* operation = (JAPIRequestOperation *)[jive contentOperation:source markAsRead:YES onComplete:^() {
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
    [self runOperation:operation];
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
    
    JAPIRequestOperation* operation = (JAPIRequestOperation *)[jive contentOperation:source markAsRead:NO onComplete:^() {
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(operation.request.HTTPMethod, @"DELETE", @"Wrong http method used");
    [self runOperation:operation];
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
    
    JAPIRequestOperation* operation = (JAPIRequestOperation *)[jive contentOperation:source likes:YES onComplete:^() {
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(operation.request.HTTPMethod, @"POST", @"Wrong http method used");
    [self runOperation:operation];
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
    
    JAPIRequestOperation* operation = (JAPIRequestOperation *)[jive contentOperation:source likes:NO onComplete:^() {
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(operation.request.HTTPMethod, @"DELETE", @"Wrong http method used");
    [self runOperation:operation];
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
    
    JAPIRequestOperation* operation = (JAPIRequestOperation *)[jive deleteContentOperation:source onComplete:^() {
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(operation.request.HTTPMethod, @"DELETE", @"Wrong http method used");
    [self runOperation:operation];
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
    JAPIRequestOperation* operation = (JAPIRequestOperation *)[jive updateContentOperation:source withOptions:options onComplete:^(JiveContent *content) {
        // Called 3rd
        STAssertTrue([[content class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
        STAssertEqualObjects(content.subject, @"Battle Week is upon us... LET'S GO ZAGS!!!", @"New object not created");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    STAssertEqualObjects(operation.request.HTTPMethod, @"PUT", @"Wrong http method used");
    STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http method used");
    [self runOperation:operation];
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
        }];
    }];
}

@end
