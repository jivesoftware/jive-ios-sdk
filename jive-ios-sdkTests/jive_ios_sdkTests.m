//
//  jive_ios_sdkTests.m
//  jive-ios-sdkTests
//
//  Created by Rob Derstadt on 9/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "jive_ios_sdkTests.h"

#import <OCMock/OCMock.h>
//#import <ReactiveCocoa/ReactiveCocoa.h>

#import <UIKit/UIKit.h>

#import "Jive.h"
#import "JiveCredentials.h"
#import "JAPIRequestOperation.h"

#undef RUN_LIVE 

#ifndef RUN_LIVE
#define LIVE( x ) _ ## x
#else
#define LIVE( x ) x
#endif

@implementation jive_ios_sdkTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// From https://github.com/akisute/SenAsyncTestCase/blob/master/SenAsyncTestCase.m
- (void)waitForTimeout:(NSTimeInterval)timeout
{
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
}

// See http://ocmock.org/#tutorials for examples on how to use OCMock
// More examples here: http://svn.mulle-kybernetik.com/OCMock/trunk/Source/OCMockObjectTests.m

- (void) testOCMockExample {
  
    id mockString = [OCMockObject mockForClass:[NSMutableString class]];
    
    NSUInteger expectedValue = 10;
    
    [[[mockString stub] andReturnValue:OCMOCK_VALUE(expectedValue)] length];
    
    STAssertEquals(expectedValue, [mockString length], @"Mock string length incorrect.");
    
}

- (BOOL)hasAcceptableContentType {
    return YES;
}

// API call is to Jive, by removing "throw 'allowIllegalResourceCall is false.';"
- (void) testJAPIRequestOperation {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"my_response" ofType:@"json"]]];
    
    JAPIRequestOperation *operation = [[JAPIRequestOperation alloc] initWithRequest:request];
    
    id mock = [OCMockObject partialMockForObject:operation];
   
    [[[mock stub] andCall:@selector(hasAcceptableContentType) onObject:self] hasAcceptableContentType];
 
    [mock setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Test succeeds if we get here
        STAssertNotNil(responseObject, @"JAPIRequestOperation returned nil response.");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        STFail(@"Unable to load test data. %@", [error localizedDescription]);
    }];
    
    [(JAPIRequestOperation *)mock start];
    
    [self waitForTimeout:5.0];

}

- (void) testJiveCredentialsBasicAuth {
    
    JiveCredentials *credentials = [[JiveCredentials alloc]
                                    initWithUserName:@"rob" password:@"blahblah987654"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.jivesoftware.com"]];
    
    STAssertTrue([[request allHTTPHeaderFields] count] == 0, @"NSMutableURLRequest should have 0 header count");
    
    [credentials applyToRequest:request];
    
    
    STAssertTrue([[request allHTTPHeaderFields] count] == 1, @"NSMutableURLRequest should have at least 1 header");
    
    NSString *header = [[request allHTTPHeaderFields] objectForKey:@"Authorization"];
    
    STAssertNotNil(header, @"Authorization should not be nil");
    
    STAssertTrue([header isEqualToString:@"Basic cm9iOmJsYWhibGFoOTg3NjU0"],
                  @"JiveCredentials failed to properly generate Basic Auth header");
    
}

- (void) LIVE(testMeService) {
    
    NSURL* url = [NSURL URLWithString:@"https://brewspace.jiveland.com"];
    
    id mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
   
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"rob.derstadt" password:@""]] credentialsForJiveInstance:[OCMArg any]];
    
//     __block JiveCredentials* credentials = [[JiveCredentials alloc] initWithUserName:@"rob.derstadt" password:@""];
//    
//    [[[mockAuthDelegate expect] andDo:^(NSInvocation *invocation) {
//        [invocation setReturnValue:&credentials];
//    }] credentialsForJiveInstance: [OCMArg any]];
    
    Jive *jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    
    [jive me:^(id JSON) {
        STAssertNotNil(JSON, @"Response was nil");
    } onError:^(NSError *error) {
        STFail([error localizedDescription]);
    }];
    
    //[mockAuthDelegate verify]; // Check that delegate was actually called


    [self waitForTimeout:5.0];
    
}



@end
