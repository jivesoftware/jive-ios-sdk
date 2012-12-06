//
//  OCMockObject+MockJiveURLProtocol.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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
    [[[self expect] andReturn:error] errorForRequestWithHTTPMethod:HTTPMethod
                                                            forURL:URL];
}

@end
