//
//  JiveRetryingImageRequestOperationTests.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveRetryingHTTPRequestOperationTests.h"
#import "JiveRetryingImageRequestOperation.h"

@interface JiveRetryingImageRequestOperationTests : JiveRetryingHTTPRequestOperationTests

@end

@implementation JiveRetryingImageRequestOperationTests

#pragma mark - JiveRetryingURLConnectionOperationTests

- (Class)classUnderTest {
    return [JiveRetryingImageRequestOperation class];
}

- (OHHTTPStubsResponse *)successCallbackOHHTTPStubsResponseWithResponder:(OHHTTPStubsResponder)responder {
    NSURL *testPngURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"avatar"
                                                                 withExtension:@"png"];
    NSData *testPngData = [NSData dataWithContentsOfURL:testPngURL];
    OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithData:testPngData
                                                               statusCode:200
                                                             responseTime:0
                                                                  headers:(@{
                                                                           @"Content-Type" : @"image/png",
                                                                           })];
    response.responder = responder;
    return response;
}

@end
