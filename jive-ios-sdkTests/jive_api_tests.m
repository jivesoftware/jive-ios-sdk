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

- (void)setUp {
    [super setUp];
    [[JiveObject dateFormatter] setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; // Make sure there is no time zone confusion.
}

- (void)tearDown
{
    jive = nil;
    mockAuthDelegate = nil;
    mockJiveURLResponseDelegate = nil;
    mockJiveURLResponseDelegate2 = nil;
    
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:nil];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:nil];
    
    [super tearDown];
}

// Create the Jive API object, using mock auth delegate
- (void)createJiveAPIObjectWithResponse:(NSString *)resourceName andAuthDelegate:(id)authDelegate {
    
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
}

// Create the Jive API object with a generic mock auth delegate
- (void)createJiveAPIObjectWithResponse:(NSString *)resourceName {
    
    mockAuthDelegate = [self mockJiveAuthenticationDelegate];
    [self createJiveAPIObjectWithResponse:resourceName andAuthDelegate:mockAuthDelegate];
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

- (void) testPersonActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [@"https://brewspace.jiveland.com/api/core/v3/people/2918/activities?after=1970-01-01T00:00:00.000+0000" isEqualToString:[value absoluteString]];
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
        [jive blog:@"2918" withOptions:options onComplete:^(JivePerson *person) {
            // Called 3rd
            STAssertEquals([person class], [JiveBlog class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
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

@end
