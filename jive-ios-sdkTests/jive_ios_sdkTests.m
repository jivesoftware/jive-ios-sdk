//
//  jive_ios_sdkTests.m
//  jive-ios-sdkTests
//
//  Created by Rob Derstadt on 9/27/12.
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

#import "jive_ios_sdkTests.h"

#import <OCMock/OCMock.h>

#import <UIKit/UIKit.h>

#import "Jive.h"
#import "JiveHTTPBasicAuthCredentials.h"
#import "JAPIRequestOperation.h"
#import "JiveMobileAnalyticsHeader.h"
#import "JiveRetryingJAPIRequestOperation.h"
#import "JiveRetryingInnerJAPIRequestOperation.h"

typedef void (^AFURLConnectionOperationAuthenticationChallengeBlock)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge);

@interface Jive (TestSupport)
- (void)setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:(AFURLConnectionOperation<JiveRetryingOperation> *)retryingURLConnectionOperation;
@end

@interface AFURLConnectionOperation (TestSupport)
@property (nonatomic, copy) AFURLConnectionOperationAuthenticationChallengeBlock authenticationChallenge;
@end

@interface JiveRetryingJAPIRequestOperation (TestSupport)
@property (atomic, readwrite) JiveRetryingInnerJAPIRequestOperation *innerOperation;
@end


#undef RUN_LIVE

#ifndef RUN_LIVE
#define LIVE( x ) _ ## x
#else
#define LIVE( x ) x
#endif

@implementation jive_ios_sdkTests

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

- (void)test_setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation_with_NSURLAuthenticationMethodServerTrust {
    id mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];

    Jive *jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"http://www.example.com"] authorizationDelegate:mockAuthDelegate];
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:nil port:0 protocol:nil realm:nil authenticationMethod:NSURLAuthenticationMethodServerTrust];
    NSURLAuthenticationChallenge *challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:nil previousFailureCount:0 failureResponse:nil error:nil sender:nil];
    [[mockAuthDelegate expect] receivedServerTrustAuthenticationChallenge:challenge];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.example.com"]];
    
    JiveRetryingJAPIRequestOperation *operation = [JiveRetryingJAPIRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
    [jive setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:(AFURLConnectionOperation<JiveRetryingOperation> *)operation];
    
    STAssertNoThrow(operation.innerOperation.operation.authenticationChallenge([NSURLConnection new], challenge), nil);
    STAssertNoThrow([mockAuthDelegate verify], @"receivedServerTrustAuthenticationChallenge should be called");
}

- (void)test_setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation_with_NSURLAuthenticationMethodDefault {
    id mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    
    Jive *jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"http://www.example.com"] authorizationDelegate:mockAuthDelegate];
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:nil port:0 protocol:nil realm:nil authenticationMethod:NSURLAuthenticationMethodDefault];
    NSURLAuthenticationChallenge *challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:nil previousFailureCount:0 failureResponse:nil error:nil sender:nil];
    [[mockAuthDelegate reject] receivedServerTrustAuthenticationChallenge:challenge];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.example.com"]];
    
    JiveRetryingJAPIRequestOperation *operation = [JiveRetryingJAPIRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
    [jive setAuthenticationBlocksAndRetrierForRetryingURLConnectionOperation:(AFURLConnectionOperation<JiveRetryingOperation> *)operation];
    
    STAssertNoThrow(operation.innerOperation.operation.authenticationChallenge([NSURLConnection new], challenge), nil);
    STAssertNoThrow([mockAuthDelegate verify], @"receivedServerTrustAuthenticationChallenge should not be called");
}

// API call is to Jive, by removing "throw 'allowIllegalResourceCall is false.';"
- (void) testJAPIRequestOperation {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"my_response" ofType:@"json"]]];
    
    JAPIRequestOperation *operation = [[JAPIRequestOperation alloc] initWithRequest:request];
    
    id mock = [OCMockObject partialMockForObject:operation];
    
    [[[mock stub] andCall:@selector(hasAcceptableContentType) onObject:self] hasAcceptableContentType];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [mock setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *HTTPRequestOperation, id responseObject) {
            // Test succeeds if we get here
            STAssertNotNil(responseObject, @"JAPIRequestOperation returned nil response.");
            finishedBlock();
        } failure:^(AFHTTPRequestOperation *HTTPRequestOperation, NSError *error) {
            STFail(@"Unable to load test data. %@", [error localizedDescription]);
        }];
        
        [(JAPIRequestOperation *)mock start];
    });
    
}

- (void) testJiveHTTPBasicAuthCredentials {
    
    JiveHTTPBasicAuthCredentials *HTTPBasicAuthCredentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"rob"
                                                                                                           password:@"blahblah987654"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.jivesoftware.com"]];
    
    STAssertTrue([[request allHTTPHeaderFields] count] == 0, @"NSMutableURLRequest should have 0 header count");
    
    [HTTPBasicAuthCredentials applyToRequest:request];
    
    
    STAssertTrue([[request allHTTPHeaderFields] count] == 1, @"NSMutableURLRequest should have at least 1 header");
    
    NSString *header = [[request allHTTPHeaderFields] objectForKey:@"Authorization"];
    
    STAssertNotNil(header, @"Authorization should not be nil");
    
    STAssertTrue([header isEqualToString:@"Basic cm9iOmJsYWhibGFoOTg3NjU0"],
                 @"JiveCredentials failed to properly generate Basic Auth header");
    
}

- (void) testJiveMobileAnalyticsHeader {
    JiveMobileAnalyticsHeader *mobileAnalyticsHeader = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"jive-ios-sdkTests"
                                                                                             appVersion:@"0.5b"
                                                                                         connectionType:@"wifi"
                                                                                         devicePlatform:@"iPad"
                                                                                          deviceVersion:@"6.0.0"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.jivesoftware.com"]];
    
    STAssertTrue([[request allHTTPHeaderFields] count] == 0, @"NSMutableURLRequest should have 0 header count");
    
    [mobileAnalyticsHeader applyToRequest:request];
    
    STAssertTrue([[request allHTTPHeaderFields] count] == 1, @"NSMutableURLRequest should have at least 1 header");
    
    NSString *header = [[request allHTTPHeaderFields] objectForKey:@"X-Jive-Client"];
    
    STAssertNotNil(header, @"Mobile Analytics Header should not be nil");
    
#ifdef __LP64__
    NSString *expectedHeader = @"eyJBcHAtU3BlYyI6eyJkZXZpY2VWZXJzaW9uIjoiNi4wLjAiLCJjb25uZWN0aW9uVHlwZSI6IndpZmkiLCJkZXZpY2VQbGF0Zm9ybSI6ImlQYWQiLCJyZXF1ZXN0T3JpZ2luIjoiTmF0aXZlIn0sIkFwcC1JRCI6ImppdmUtaW9zLXNka1Rlc3RzIiwiQXBwLVZlcnNpb24iOiIwLjViIn0=";
#else // ifdef __LP64__
    NSString *expectedHeader = @"eyJBcHAtVmVyc2lvbiI6IjAuNWIiLCJBcHAtU3BlYyI6eyJkZXZpY2VQbGF0Zm9ybSI6ImlQYWQiLCJyZXF1ZXN0T3JpZ2luIjoiTmF0aXZlIiwiY29ubmVjdGlvblR5cGUiOiJ3aWZpIiwiZGV2aWNlVmVyc2lvbiI6IjYuMC4wIn0sIkFwcC1JRCI6ImppdmUtaW9zLXNka1Rlc3RzIn0=";
#endif // ifdef __LP64__ else
    
    STAssertTrue([header isEqualToString:expectedHeader],
                 @"JiveCredentials failed to properly generate Basic Auth header: %@", header);
}

- (void) LIVE(testMeService) {
    
    NSURL* url = [NSURL URLWithString:@"https://testing.jiveland.com"];
    
    id mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"rob.derstadt"
                                                                                        password:@""]] credentialsForJiveInstance:[OCMArg any]];
    
    //     __block JiveCredentials* credentials = [[JiveCredentials alloc] initWithUserName:@"rob.derstadt" password:@""];
    //
    //    [[[mockAuthDelegate expect] andDo:^(NSInvocation *invocation) {
    //        [invocation setReturnValue:&credentials];
    //    }] credentialsForJiveInstance: [OCMArg any]];
    
    Jive *jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [jive me:^(id JSON) {
            STAssertNotNil(JSON, @"Response was nil");
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    });
    
    //[mockAuthDelegate verify]; // Check that delegate was actually called
    
    
}

- (void) LIVE(testCreateBlogPost) {
    NSURL *url = [NSURL URLWithString:@"http://tiedhouse-yeti1.eng.jiveland.com"];
    id mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"iOS-SDK-TestUser1"
                                                                                        password:@"test123"]] credentialsForJiveInstance:[OCMArg any]];
    
    Jive *jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    JivePost *post = [[JivePost alloc] init];
    __block JiveContent *postToDelete = nil;
    
    post.subject = @"Test blog 12345";
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"test/html";
    post.content.text = @"<body><p>This is a test of the emergency broadcast system.</p></body>";
    waitForTimeout(^(void (^finishedBlock)(void)) {
        [jive createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
            STAssertEqualObjects([newPost class], [JivePost class], @"Wrong content created");
            postToDelete = newPost;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    });
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"iOS-SDK-TestUser1"
                                                                                        password:@"test123"]] credentialsForJiveInstance:[OCMArg any]];
    jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    waitForTimeout(^(void (^finishedBlock2)(void)) {
        [jive deleteContent:postToDelete onComplete:^{
            finishedBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock2();
        }];
    });
}

@end
