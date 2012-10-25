//
//  jive_api_tests.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "jive_api_tests.h"

#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>

#import "Jive.h"
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
    [super tearDown];
}

- (void) testInboxServiceCall {
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    
    // Reponse file containing data from JIVE My request
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"inbox_response" ofType:@"json"];
    
    // Mock response delegate
    id mockJiveURLResponseDelegate = [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
    
    // Mock auth delegate
    id mockAuthDelegate = [self mockJiveAuthenticationDelegate];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    Jive *jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    
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
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    
    // Reponse file containing data from JIVE My request
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"my_response" ofType:@"json"];
    
    // Mock response delegate
    id mockJiveURLResponseDelegate = [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
      
    // Mock auth delegate
    id mockAuthDelegate = [self mockJiveAuthenticationDelegate];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    Jive *jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    
    [[jive me:^(id JSON) {
        // Called 3rd
        STAssertNotNil(JSON, @"Response was nil");
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }] subscribeNext:^(id x) {
        // Called 2nd
        STAssertNotNil(x, @"Response was nil");
    } error:^(NSError *error) {
        STFail([error localizedDescription]);
    } completed:^{
        // Called 1st
        
        // Check that delegates where actually called
        [mockAuthDelegate verify]; 
        [mockJiveURLResponseDelegate verify];
    }];
    
    [self waitForTimeout:5.0];
    
}





@end
