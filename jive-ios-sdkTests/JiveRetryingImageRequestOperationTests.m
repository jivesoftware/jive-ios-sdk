//
//  JiveRetryingImageRequestOperationTests.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/26/13.
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
