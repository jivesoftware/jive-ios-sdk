//
//  JiveAPITestCase.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
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

#import "JiveAPITestCase.h"

@implementation JiveAPITestCase

#pragma mark - SenTestCase

- (void)setUp {
    [super setUp];
    [NSURLProtocol registerClass:[MockJiveURLProtocol class]];
}

- (void)tearDown {
    [super tearDown];
    [NSURLProtocol unregisterClass:[MockJiveURLProtocol class]];
}

#pragma mark - public API

- (id) mockJiveAuthenticationDelegate:(NSString*) username password:(NSString*) password {
    // Mock Auth Delegate
    id mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:username
                                                                                        password:password]] credentialsForJiveInstance:[OCMArg any]];
    [[[mockAuthDelegate expect] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:username
                                                                                        password:password]] mobileAnalyticsHeaderForJiveInstance:[OCMArg any]];
    
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

- (id) entityForClass:(Class) entityClass
        fromJSONNamed:(NSString *)jsonName {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:jsonName
                                                                          ofType:@"json"];
    NSData *rawJson = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:rawJson
                                                         options:0
                                                           error:NULL];
    id entity = [entityClass objectFromJSON:JSON withInstance:nil];
    return entity;
}

@end
