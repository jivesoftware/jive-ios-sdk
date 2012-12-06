//
//  JiveAPITestCase.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAPITestCase.h"

@implementation JiveAPITestCase

- (void)setUp
{
    [super setUp];
    [NSURLProtocol registerClass:[MockJiveURLProtocol class]];
}

- (void)tearDown
{
    [super tearDown];
    [NSURLProtocol unregisterClass:[MockJiveURLProtocol class]];
}

- (id) mockJiveAuthenticationDelegate:(NSString*) username password:(NSString*) password {
    // Mock Auth Delegate
    id mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    
    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:username password:password]] credentialsForJiveInstance:[OCMArg any]];
    
    return mockAuthDelegate;
}

- (id) mockJiveAuthenticationDelegate {
    return [self mockJiveAuthenticationDelegate:@"foo" password:@"bar"];
}

- (id) mockJiveURLDelegate:(NSURL*) url returningContentsOfFile:(NSString*) path {
    
    id mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url statusCode:200 HTTPVersion:@"1.0" headerFields:[NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"Content-Type", nil]];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    
    // Mock data
    NSData *mockResponseData = [NSData dataWithContentsOfFile:path];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:mockResponseData] responseBodyForRequest];
    
    return mockJiveURLResponseDelegate;
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

@end
