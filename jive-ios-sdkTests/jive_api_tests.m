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
#import "JiveInboxOptions.h"

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

    __block BOOL completeBlockCalled = false;
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
        completeBlockCalled = true;
        
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
    
    __block BOOL completeBlockCalled = false;
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
        completeBlockCalled = true;
        
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

    JiveInboxOptions *options = [[JiveInboxOptions alloc] init];
    __block BOOL completeBlockCalled = false;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/people/8192/@followers%3Fcount=5&fields=dummy" relativeToURL:url] absoluteString];
    
    options.startIndex = 0;
    options.count = 5;
    options.fields = [NSArray arrayWithObject:@"dummy"];
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
        completeBlockCalled = true;
        
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
    
    JiveInboxOptions *options = [[JiveInboxOptions alloc] init];
    __block BOOL completeBlockCalled = false;
    // Create a mock auth delegate to verify the request url
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    __block NSString* expectedUrl = [[NSURL URLWithString:@"/api/core/v3/people/8192/@followers%3FstartIndex=6&count=3&fields=dummy,second,third" relativeToURL:url] absoluteString];
    
    options.startIndex = 6;
    options.count = 3;
    options.fields = [NSArray arrayWithObjects:@"dummy", @"second", @"third", nil];
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
        completeBlockCalled = true;
        
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
