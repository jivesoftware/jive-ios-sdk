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
#import "JiveCredentials.h"
#import "JAPIRequestOperation.h"

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

// API call is to Jive, by removing "throw 'allowIllegalResourceCall is false.';"
- (void) testJAPIRequestOperation {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"my_response" ofType:@"json"]]];
    
    JAPIRequestOperation *operation = [[JAPIRequestOperation alloc] initWithRequest:request];
    
    id mock = [OCMockObject partialMockForObject:operation];
   
    [[[mock stub] andCall:@selector(hasAcceptableContentType) onObject:self] hasAcceptableContentType];
 
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [mock setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *HTTPRequestOperation, id responseObject) {
            // Test succeeds if we get here
            STAssertNotNil(responseObject, @"JAPIRequestOperation returned nil response.");
            finishedBlock();
        } failure:^(AFHTTPRequestOperation *HTTPRequestOperation, NSError *error) {
            STFail(@"Unable to load test data. %@", [error localizedDescription]);
        }];
        
        [(JAPIRequestOperation *)mock start];
    }];

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
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive me:^(id JSON) {
            STAssertNotNil(JSON, @"Response was nil");
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
        }];
    }];
    
    //[mockAuthDelegate verify]; // Check that delegate was actually called

    
}

- (void) LIVE(testCreateBlogPost) {
    NSURL *url = [NSURL URLWithString:@"http://tiedhouse-yeti1.eng.jiveland.com"];
    id mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"iOS-SDK-TestUser1" password:@"test123"]] credentialsForJiveInstance:[OCMArg any]];
    
    Jive *jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    JivePost *post = [[JivePost alloc] init];
    __block JiveContent *postToDelete = nil;
    
    post.subject = @"Test blog 12345";
    post.content = [[JiveContentBody alloc] init];
    post.content.type = @"test/html";
    post.content.text = @"<body><p>This is a test of the emergency broadcast system.</p></body>";
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [jive createContent:post withOptions:nil onComplete:^(JiveContent *newPost) {
            STAssertEqualObjects([newPost class], [JivePost class], @"Wrong content created");
            postToDelete = newPost;
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"iOS-SDK-TestUser1" password:@"test123"]] credentialsForJiveInstance:[OCMArg any]];
    jive = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    [self waitForTimeout:^(void (^finishedBlock2)(void)) {
        [jive deleteContent:postToDelete onComplete:^{
            finishedBlock2();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock2();
        }];
    }];
}

@end
