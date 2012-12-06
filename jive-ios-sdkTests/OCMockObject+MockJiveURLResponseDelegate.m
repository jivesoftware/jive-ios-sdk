//
//  OCMockObject+MockJiveURLProtocol.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "OCMockObject+MockJiveURLResponseDelegate.h"

@implementation OCMockObject (MockJiveURLResponseDelegate)

+ (id<MockJiveURLResponseDelegate>) mockJiveURLResponseDelegate {
    return [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
}

- (void) expectResponseWithContentsOfFileAtPath:(NSString *)filePath
                       forRequestWithHTTPMethod:(NSString *)HTTPMethod
                                         forURL:(NSURL *)URL {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"1.0" headerFields:[NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"Content-Type", nil]];
    
    [[[self expect] andReturn:response] responseBodyForRequestWithHTTPMethod:HTTPMethod
                                                                      forURL:URL];
    
    NSData *mockResponseData = [NSData dataWithContentsOfFile:filePath];
    NSAssert(mockResponseData != nil, @"Invalid response contents file path: %@", filePath);
    
    [[[self expect] andReturn:mockResponseData] responseBodyForRequestWithHTTPMethod:HTTPMethod
                                                                              forURL:URL];
}

- (void) expectError:(NSError *)error forRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL {
    [[[self expect] andReturn:error] errorForRequestWithHTTPMethod:HTTPMethod
                                                            forURL:URL];
}

@end
