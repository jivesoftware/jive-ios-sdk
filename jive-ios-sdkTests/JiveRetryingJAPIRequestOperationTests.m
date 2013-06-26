//
//  JiveRetryingJAPIRequestOperationTests.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/24/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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

- (void)testCancellation {
    // don't define a request handler - we don't want the operation to finish as we want to explicitly cancel it
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    JiveRetryingJAPIRequestOperation __block *testObject;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        testObject = [JiveRetryingJAPIRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]]
                                                                               success:(^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            finishedBlock();
        })
                                                                               failure:(^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            finishedBlock();
        })];
        
        [operationQueue addOperation:testObject];
        STAssertEquals((NSUInteger)1, [operationQueue operationCount], nil);
        STAssertFalse([testObject isFinished], nil);
        STAssertFalse([testObject isCancelled], nil);
        [operationQueue cancelAllOperations];
    }];
    STAssertEquals((NSUInteger)0, [operationQueue operationCount], nil);
    STAssertFalse([testObject isExecuting], nil);
    STAssertTrue([testObject isFinished], nil);
    STAssertTrue([testObject isCancelled], nil);
}

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
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
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
        
        [operationQueue addOperation:testObject];
        STAssertEquals((NSUInteger)1, [operationQueue operationCount], nil);
        STAssertFalse([testObject isCancelled], nil);
    }];
    STAssertEquals((NSUInteger)0, [operationQueue operationCount], nil);
    STAssertFalse([testObject isExecuting], nil);
    STAssertTrue([testObject isFinished], nil);
    STAssertFalse([testObject isCancelled], nil);
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
