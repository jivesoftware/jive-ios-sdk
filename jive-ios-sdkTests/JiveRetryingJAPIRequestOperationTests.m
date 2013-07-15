//
//  JiveRetryingJAPIRequestOperationTests.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/24/13.
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
#import "JiveRetryingJAPIRequestOperation.h"

@interface JiveRetryingJAPIRequestOperationTests : JiveRetryingHTTPRequestOperationTests

@end

@implementation JiveRetryingJAPIRequestOperationTests

#pragma mark - JiveRetryingURLConnectionOperationTests

- (Class)classUnderTest {
    return [JiveRetryingJAPIRequestOperation class];
}

- (OHHTTPStubsResponse *)successCallbackOHHTTPStubsResponseWithResponder:(OHHTTPStubsResponder)responder {
    return [OHHTTPStubsResponse responseWithJSON:(@{
                                                  @"foo" : @"bar",
                                                  })
                                       responder:responder];
}

#pragma mark - tests

- (void)testResponseJSONSuccess {
    id expectedJSON = (@{
                       @"foo" : @"bar",
                       });
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithJSON:expectedJSON];
                              })];
    
    id __block actualJSON = nil;
    JiveRetryingJAPIRequestOperation __block *testObject;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        testObject = [JiveRetryingJAPIRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]]
                                                                               success:(^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            actualJSON = JSON;
            finishedBlock();
        })
                                                                               failure:(^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            finishedBlock();
        })];
        [testObject start];
    }];
    STAssertEqualObjects(expectedJSON, actualJSON, nil);
}

- (void)testResponseJSONFailure {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[@"{\"foo\":\"bar"/* intentionally missing closing quote */@"}" dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:200
                                        responseTime:0
                                             headers:(@{
                                                      @"Content-Type" : @"application/json",
                                                      })];
    })];
    
    NSError * __block actualError = nil;
    id __block actualJSON = nil;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        JiveRetryingJAPIRequestOperation *testObject;
        testObject = [JiveRetryingJAPIRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]]
                                                                               success:(^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            finishedBlock();
        })
                                                                               failure:(^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            actualError = error;
            actualJSON = nil;
            finishedBlock();
        })];
        [testObject start];
    }];
    
    STAssertEqualObjects(NSCocoaErrorDomain, [actualError domain], nil);
    STAssertEquals(NSPropertyListReadCorruptError, [actualError code], nil);
    STAssertNil(actualJSON, nil);
}

@end
