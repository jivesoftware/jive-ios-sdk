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

@implementation jive_api_tests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    jive = nil;
    mockAuthDelegate = nil;
    mockJiveURLResponseDelegate = nil;
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
    
    [jive inbox:nil onComplete:^(NSArray *inboxEntries) {
        
        STAssertNotNil(inboxEntries, @"InboxEntries where nil!");
        STAssertTrue([inboxEntries count] == 28, @"Incorrect number of inbox entries where returned");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        //
    }];
    
    [self waitForTimeout:5.0];
}

- (void) testMyServiceCall {
    
    [self createJiveAPIObjectWithResponse:@"my_response"];
    
    [jive me:^(id JSON) {
        // Called 3rd
        STAssertNotNil(JSON, @"Response was nil");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];

    [self waitForTimeout:5.0];
    
}

- (void) testColleguesServiceCall {
    
    [self createJiveAPIObjectWithResponse:@"collegues_response"];
    
    [jive collegues:@"2918" onComplete:^(id JSON) {
        // Called 3rd
        STAssertNotNil(JSON, @"Response was nil");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];

    [self waitForTimeout:5.0];
}

- (void) testFollowersServiceCall {

    __block BOOL completeBlockCalled = NO;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/people/2918/@followers" relativeToURL:url] absoluteString];

    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedUrl isEqualToString:[value absoluteString]];
        return same;
    }]];

    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];

    // Make the call
    [jive followers:@"2918" onComplete:^(id JSON) {
        // Called 3rd
        STAssertNotNil(JSON, @"Response was nil");
        completeBlockCalled = YES;
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];

    [self waitForTimeout:0.5];
    STAssertTrue(completeBlockCalled, @"onComplete handler not called.");
}

- (void) testFollowersServiceCallUsesPersonID {
    
    __block BOOL completeBlockCalled = NO;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/people/8192/@followers" relativeToURL:url] absoluteString];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedUrl isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [jive followers:@"8192" onComplete:^(id JSON) {
        // Called 3rd
        STAssertNotNil(JSON, @"Response was nil");
        completeBlockCalled = YES;
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self waitForTimeout:0.5];
    STAssertTrue(completeBlockCalled, @"onComplete handler not called.");
}

- (void) testFollowersServiceCallWithOptions {

    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    __block BOOL completeBlockCalled = NO;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/people/8192/@followers?fields=dummy&count=5" relativeToURL:url] absoluteString];
    
    options.startIndex = 0;
    options.count = 5;
    [options addField:@"dummy"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedUrl isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [jive followers:@"8192" withOptions:options onComplete:^(id JSON) {
        // Called 3rd
        STAssertNotNil(JSON, @"Response was nil");
        completeBlockCalled = YES;
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self waitForTimeout:0.5];
    STAssertTrue(completeBlockCalled, @"onComplete handler not called.");
}

- (void) testFollowersServiceCallWithDifferentOptions {
    
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    __block BOOL completeBlockCalled = NO;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/people/8192/@followers?fields=dummy,second,third&count=3&startIndex=6" relativeToURL:url] absoluteString];
    
    options.startIndex = 6;
    options.count = 3;
    [options addField:@"dummy"];
    [options addField:@"second"];
    [options addField:@"third"];
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedUrl isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [jive followers:@"8192" withOptions:options onComplete:^(id JSON) {
        // Called 3rd
        STAssertNotNil(JSON, @"Response was nil");
        completeBlockCalled = YES;
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self waitForTimeout:0.5];
    STAssertTrue(completeBlockCalled, @"onComplete handler not called.");
}

- (void) testSearchPeopleServiceCall {
    
    JiveSearchPeopleRequestOptions *options = [[JiveSearchPeopleRequestOptions alloc] init];
    __block BOOL completeBlockCalled = NO;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/search/people?sort=updatedAsc" relativeToURL:url] absoluteString];
    
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedUrl isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [jive searchPeople:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)13, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        completeBlockCalled = YES;
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self waitForTimeout:0.5];
    STAssertTrue(completeBlockCalled, @"onComplete handler not called.");
}

- (void) testSearchPlacesServiceCall {
    
    JiveSearchPlacesRequestOptions *options = [[JiveSearchPlacesRequestOptions alloc] init];
    __block BOOL completeBlockCalled = NO;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/search/places?sort=updatedAsc" relativeToURL:url] absoluteString];
    
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedUrl isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_places_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [jive searchPlaces:options onComplete:^(NSArray *places) {
        // Called 3rd
        STAssertEquals([places count], (NSUInteger)10, @"Wrong number of items parsed");
        STAssertTrue([[places objectAtIndex:0] isKindOfClass:[JivePlace class]], @"Wrong item class");
        completeBlockCalled = YES;
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self waitForTimeout:0.5];
    STAssertTrue(completeBlockCalled, @"onComplete handler not called.");
}

- (void) testSearchContentsServiceCall {
    
    JiveSearchContentsRequestOptions *options = [[JiveSearchContentsRequestOptions alloc] init];
    __block BOOL completeBlockCalled = NO;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/search/contents?sort=updatedAsc" relativeToURL:url] absoluteString];
    
    options.sort = JiveSortOrderUpdatedAsc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedUrl isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"search_contents_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [jive searchContents:options onComplete:^(NSArray *contents) {
        // Called 3rd
        STAssertEquals([contents count], (NSUInteger)7, @"Wrong number of items parsed");
        STAssertTrue([[contents objectAtIndex:0] isKindOfClass:[JiveContent class]], @"Wrong item class");
        completeBlockCalled = YES;
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self waitForTimeout:0.5];
    STAssertTrue(completeBlockCalled, @"onComplete handler not called.");
}

- (void) testPeopleServiceCall {
    
    JivePeopleRequestOptions *options = [[JivePeopleRequestOptions alloc] init];
    __block BOOL completeBlockCalled = NO;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/people?sort=dateJoinedDesc" relativeToURL:url] absoluteString];
    
    options.sort = JiveSortOrderDateJoinedDesc;
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar" password:@"foo"]] credentialsForJiveInstance:[OCMArg checkWithBlock:^BOOL(id value) {
        BOOL same = [expectedUrl isEqualToString:[value absoluteString]];
        return same;
    }]];
    
    [self createJiveAPIObjectWithResponse:@"people_response" andAuthDelegate:mockAuthDelegate];
    
    // Make the call
    [jive people:options onComplete:^(NSArray *people) {
        // Called 3rd
        STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
        STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
        completeBlockCalled = YES;
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
        
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    [self waitForTimeout:0.5];
    STAssertTrue(completeBlockCalled, @"onComplete handler not called.");
}

@end
