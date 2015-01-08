//
//  OCMockObject+MockJiveURLProtocol.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
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

#import "OCMockObject+MockJiveURLResponseDelegate.h"

@implementation OCMockObject (MockJiveURLResponseDelegate2)

+ (id<MockJiveURLResponseDelegate2>) mockJiveURLResponseDelegate2 {
    return [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate2)];
}

- (void)expectResponseWithContentsOfJSONFileNamed:(NSString *)JSONFileName
                             bundledWithTestClass:(Class)testClass
                                forRequestWithURL:(NSURL *)URL {
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                              statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:(@{
                                                                                                                   @"Content-Type" : @"application/json",
                                                                                                                   })];
    [[[self expect] andReturn:response] responseForRequestWithHTTPMethod:@"GET"
                                                                  forURL:URL];
    NSString *JSONFilePath = [[NSBundle bundleForClass:testClass] pathForResource:JSONFileName
                                                                           ofType:@"json"];
    NSData *JSONResponseData = [NSData dataWithContentsOfFile:JSONFilePath];
    NSAssert(JSONResponseData, @"invalid JSONFileName: %@", JSONFileName);
    [[[self expect] andReturn:JSONResponseData] responseBodyForRequestWithHTTPMethod:@"GET"
                                                                              forURL:URL];
    
    [[[self expect] andReturn:nil] errorForRequestWithHTTPMethod:@"GET"
                                                          forURL:URL];
}

- (void)expectNoResponseForRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                              statusCode:204
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:(@{
                                                                          @"Content-Type" : @"text/plain; charset=UTF=8",
                                                                          })];
    
    [[[self expect] andReturn:response] responseForRequestWithHTTPMethod:HTTPMethod
                                                                  forURL:URL];
    
    [[[self expect] andReturn:[NSData data]] responseBodyForRequestWithHTTPMethod:HTTPMethod
                                                                           forURL:URL];
    [[[self expect] andReturn:nil] errorForRequestWithHTTPMethod:HTTPMethod
                                                          forURL:URL];
}

- (void) expectError:(NSError *)error forRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                              statusCode:204
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:(@{
                                                                          @"Content-Type" : @"text/plain; charset=UTF=8",
                                                                          })];
    
    [[[self expect] andReturn:response] responseForRequestWithHTTPMethod:HTTPMethod
                                                                  forURL:URL];
    
    [[[self expect] andReturn:[NSData data]] responseBodyForRequestWithHTTPMethod:HTTPMethod
                                                                           forURL:URL];
    [[[self expect] andReturn:error] errorForRequestWithHTTPMethod:HTTPMethod
                                                            forURL:URL];
}

@end
