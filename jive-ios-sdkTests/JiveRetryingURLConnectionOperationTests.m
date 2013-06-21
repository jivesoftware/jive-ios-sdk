//
//  JiveRetryingURLConnectionOperationTests.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveRetryingURLConnectionOperationTests.h"
#import "JiveRetryingURLConnectionOperation.h"

@implementation JiveRetryingURLConnectionOperationTests {
    AFURLConnectionOperation<JiveRetryingOperation> *testObject;
}

#pragma mark - SenTestCase

- (void)setUp {
    [super setUp];
    
    testObject = [[[self classUnderTest] alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]]];
    testError = [NSError errorWithDomain:NSStringFromClass([self class])
                                    code:1
                                userInfo:nil];
}

#pragma mark - public API

- (Class)classUnderTest {
    return [JiveRetryingURLConnectionOperation class];
}

- (OHHTTPStubsResponse *)successCallbackOHHTTPStubsResponseWithResponder:(OHHTTPStubsResponder)responder {
    return [OHHTTPStubsResponse responseWithHTML:@"<html></html>"
                                       responder:responder];
}

#pragma mark - tests

- (void)testConformsToJiveRetryingOperation {
    STAssertTrue([testObject conformsToProtocol:@protocol(JiveRetryingOperation)], nil);
}

- (void)testClassUnderTestIsSubclassOfAFURLConnectionOperation {
    STAssertTrue([[self classUnderTest] isSubclassOfClass:[AFURLConnectionOperation class]], nil);
}

- (void)testSuccessCallsCompletionBlockAndNilsRetrier {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self successCallbackOHHTTPStubsResponseWithResponder:nil];
    })];
    
    testObject.retrier = [JiveRetryingURLConnectionOperationTestsRetrier new];
    
    BOOL __block completionBlockCalled = NO;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
       [testObject setCompletionBlock:^{
           completionBlockCalled = YES;
           finishedBlock();
       }];
        
        [testObject start];
    }];
    
    STAssertTrue(completionBlockCalled, nil);
    STAssertNil(testObject.retrier, nil);
}

- (void)testFailureCallsCompletionBlockWhenThereIsNoRetrierAndHasOperationError {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithError:testError];
    })];
    
    BOOL __block completionBlockCalled = NO;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [testObject setCompletionBlock:^{
            completionBlockCalled = YES;
            finishedBlock();
        }];
        
        [testObject start];
    }];
    
    STAssertTrue(completionBlockCalled, nil);
    STAssertEqualObjects([testObject.error domain], [testError domain], nil);
    STAssertEquals([testObject.error code], [testError code], nil);
}

- (void)testFailureCallsCompletionBlockWhenRetrierFailsAndHasRetrierErrorAndNilsRetrier {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithError:testError];
    })];
    
    NSError *retryError = [NSError errorWithDomain:@"retry"
                                              code:[testError code] + 1
                                          userInfo:nil];
    JiveRetryingURLConnectionOperationTestsRetrier *testRetrier = [JiveRetryingURLConnectionOperationTestsRetrier new];
    testRetrier.retryError = retryError;
    testObject.retrier = testRetrier;
    
    BOOL __block completionBlockCalled = NO;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [testObject setCompletionBlock:^{
            completionBlockCalled = YES;
            finishedBlock();
        }];
        
        [testObject start];
    }];
    
    STAssertTrue(completionBlockCalled, nil);
    STAssertEqualObjects([testObject.error domain], [retryError domain], nil);
    STAssertEquals([testObject.error code], [retryError code], nil);
    STAssertEqualObjects(testRetrier.retryingOperations, (@[
                                                          testObject,
                                                          ]), nil);
    STAssertEqualObjects(testRetrier.originalErrorDomains, (@[
                                                            [testError domain],
                                                            ]), nil);
    STAssertEqualObjects(testRetrier.originalErrorCodes, (@[
                                                          @([testError code]),
                                                          ]), nil);
    STAssertNil(testObject.retrier, nil);
}

- (void)testFailureRetriesWithGivenOperationAndCallsCompletionBlockWithSuccessAndNilsRetrier {
    JiveRetryingURLConnectionOperationTestsRetrier *testRetrier = [JiveRetryingURLConnectionOperationTestsRetrier new];
    testRetrier.retryCount = 1;
    testObject.retrier = testRetrier;
    
    BOOL __block completionBlockCalled = NO;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *maybeFailingRequest) {
            return [[[maybeFailingRequest URL] absoluteString] isEqualToString:@"http://example.com"];
        })
                                  withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *failingRequest) {
            return [OHHTTPStubsResponse responseWithError:testError
                                                responder:^(dispatch_block_t respondBlock) {
                                                    [OHHTTPStubs removeAllRequestHandlers];
                                                    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *maybeSuccessfulRequest) {
                                                        return [[[maybeSuccessfulRequest URL] absoluteString] isEqualToString:@"http://example.com"];
                                                    })
                                                                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *successfulRequest) {
                                                        return [self successCallbackOHHTTPStubsResponseWithResponder:nil];
                                                    })];
                                                    respondBlock();
                                                }];
        })];
        
        [testObject setCompletionBlock:^{
            completionBlockCalled = YES;
            finishedBlock();
        }];
        
        [testObject start];
    }];
    
    STAssertTrue(completionBlockCalled, nil);
    STAssertNil(testObject.error, nil);
    STAssertEqualObjects(testRetrier.retryingOperations, (@[
                                                          testObject,
                                                          ]), nil);
    STAssertEqualObjects(testRetrier.originalErrorDomains, (@[
                                                            [testError domain],
                                                            ]), nil);
    STAssertEqualObjects(testRetrier.originalErrorCodes, (@[
                                                          @([testError code]),
                                                          ]), nil);
    STAssertNil(testObject.retrier, nil);
}

- (void)testFailureRetriesWithGivenOperationAndCallsCompletionBlockWhenSecondRetrierFailsWithSecondRetryErrorAndNilsRetrier {
    NSError *firstRetryError = [NSError errorWithDomain:@"firstRetry"
                                                   code:[testError code] + 1
                                               userInfo:nil];
    NSError *secondRetryError = [NSError errorWithDomain:@"secondRetry"
                                                    code:[firstRetryError code] + 1
                                                userInfo:nil];
    JiveRetryingURLConnectionOperationTestsRetrier *testRetrier = [JiveRetryingURLConnectionOperationTestsRetrier new]; // a strong reference, testObject.retrier is weak
    testRetrier.retryCount = 1;
    testRetrier.retryError = secondRetryError;
    testObject.retrier = testRetrier;
    
    BOOL __block completionBlockCalled = NO;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *maybeFailingRequest) {
            return [[[maybeFailingRequest URL] absoluteString] isEqualToString:@"http://example.com"];
        })
                                  withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *failingRequest) {
            return [OHHTTPStubsResponse responseWithError:testError
                                                responder:^(dispatch_block_t respondBlock) {
                                                    [OHHTTPStubs removeAllRequestHandlers];
                                                    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *maybeSuccessfulRequest) {
                                                        return [[[maybeSuccessfulRequest URL] absoluteString] isEqualToString:@"http://example.com"];
                                                    })
                                                                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *successfulRequest) {
                                                        return [OHHTTPStubsResponse responseWithError:firstRetryError];
                                                    })];
                                                    respondBlock();
                                                }];
        })];
        
        [testObject setCompletionBlock:^{
            completionBlockCalled = YES;
            finishedBlock();
        }];
        
        [testObject start];
    }];
    
    STAssertTrue(completionBlockCalled, nil);
    STAssertEqualObjects([testObject.error domain], [secondRetryError domain], nil);
    STAssertEquals([testObject.error code], [secondRetryError code], nil);
    STAssertEqualObjects(testRetrier.retryingOperations, (@[
                                                          testObject,
                                                          testObject,
                                                          ]), nil);
    STAssertEqualObjects(testRetrier.originalErrorDomains, (@[
                                                            [testError domain],
                                                            [firstRetryError domain],
                                                            ]), nil);
    STAssertEqualObjects(testRetrier.originalErrorCodes, (@[
                                                          @([testError code]),
                                                          @([firstRetryError code]),
                                                          ]), nil);
    STAssertNil(testObject.retrier, nil);
}

- (void)testResponseFieldsNilUntilFinishedOnSuccess {
    dispatch_block_t __block respondBlock = NULL;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
            return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
        })
                                  withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [self successCallbackOHHTTPStubsResponseWithResponder:(^(dispatch_block_t respondBlock_) {
                respondBlock = respondBlock_;
                finishedBlock();
            })];
        })];
        
        [testObject start];
    }];
    
    if (respondBlock) {
        STAssertNil(testObject.response, nil);
        STAssertNil(testObject.error, nil);
        STAssertNil(testObject.responseData, nil);
        STAssertNil(testObject.responseString, nil);
        
        [self waitForTimeout:^(dispatch_block_t finishedBlock) {
            [testObject setCompletionBlock:^{
                finishedBlock();
            }];
            
            respondBlock();
        }];
    } else {
        STFail(nil);
    }
}

- (void)testResponseFieldsNilUntilFinishedOnFailure {
    dispatch_block_t __block respondBlock = NULL;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
            return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
        })
                                  withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithError:testError
                                               responder:(^(dispatch_block_t respondBlock_) {
                respondBlock = respondBlock_;
                finishedBlock();
            })];
        })];
        
        [testObject start];
    }];
    
    if (respondBlock) {
        STAssertNil(testObject.response, nil);
        STAssertNil(testObject.error, nil);
        STAssertNil(testObject.responseData, nil);
        STAssertNil(testObject.responseString, nil);
        
        [self waitForTimeout:^(dispatch_block_t finishedBlock) {
            [testObject setCompletionBlock:^{
                finishedBlock();
            }];
            
            respondBlock();
        }];
    } else {
        STFail(nil);
    }
}

- (void)testResponseFieldsNilUntilFinishedOnRetrySuccess {
    JiveRetryingURLConnectionOperationTestsRetrier *testRetrier = [JiveRetryingURLConnectionOperationTestsRetrier new];
    testRetrier.retryCount = 1;
    testObject.retrier = testRetrier;
    
    dispatch_block_t __block secondRespondBlock = NULL;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *maybeFailedRequest) {
            return [[[maybeFailedRequest URL] absoluteString] isEqualToString:@"http://example.com"];
        })
                                  withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *failedRequest) {
            return [OHHTTPStubsResponse responseWithError:testError
                                                responder:(^(dispatch_block_t firstRespondBlock) {
                [OHHTTPStubs removeAllRequestHandlers];
                [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *maybeSuccessfulRequest) {
                    return [[[maybeSuccessfulRequest URL] absoluteString] isEqualToString:@"http://example.com"];
                })
                                          withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *successfulRequest) {
                    return [self successCallbackOHHTTPStubsResponseWithResponder:^(dispatch_block_t secondRespondBlock_) {
                        secondRespondBlock = secondRespondBlock_;
                        finishedBlock();
                    }];
                })];
                firstRespondBlock();
            })];
        })];
        
        [testObject start];
    }];
    
    if (secondRespondBlock) {
        STAssertNil(testObject.response, nil);
        STAssertNil(testObject.error, nil);
        STAssertNil(testObject.responseData, nil);
        STAssertNil(testObject.responseString, nil);
        
        [self waitForTimeout:^(dispatch_block_t finishedBlock) {
            [testObject setCompletionBlock:^{
                finishedBlock();
            }];
            
            secondRespondBlock();
        }];
    } else {
        STFail(nil);
    }
}

- (void)testResponseFieldsNilUntilFinishedOnRetryFailure {
    JiveRetryingURLConnectionOperationTestsRetrier *testRetrier = [JiveRetryingURLConnectionOperationTestsRetrier new];
    testRetrier.retryCount = 1;
    testObject.retrier = testRetrier;
    
    dispatch_block_t __block secondRespondBlock = NULL;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *maybeFailedRequest) {
            return [[[maybeFailedRequest URL] absoluteString] isEqualToString:@"http://example.com"];
        })
                                  withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *failedRequest) {
            return [OHHTTPStubsResponse responseWithError:testError
                                                responder:(^(dispatch_block_t firstRespondBlock) {
                [OHHTTPStubs removeAllRequestHandlers];
                [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *maybeSuccessfulRequest) {
                    return [[[maybeSuccessfulRequest URL] absoluteString] isEqualToString:@"http://example.com"];
                })
                                          withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *successfulRequest) {
                    return [OHHTTPStubsResponse responseWithError:testError
                                                        responder:^(dispatch_block_t secondRespondBlock_) {
                                                            secondRespondBlock = secondRespondBlock_;
                                                            finishedBlock();
                                                        }];
                })];
                firstRespondBlock();
            })];
        })];
        
        [testObject start];
    }];
    
    if (secondRespondBlock) {
        STAssertNil(testObject.response, nil);
        STAssertNil(testObject.error, nil);
        STAssertNil(testObject.responseData, nil);
        STAssertNil(testObject.responseString, nil);
        
        [self waitForTimeout:^(dispatch_block_t finishedBlock) {
            [testObject setCompletionBlock:^{
                finishedBlock();
            }];
            
            secondRespondBlock();
        }];
    } else {
        STFail(nil);
    }
}

@end

@interface JiveRetryingURLConnectionOperationTestsRetrier()

@property (atomic) NSObject *writeMonitor;
@property (atomic, readwrite) NSArray *retryingOperations;
@property (atomic, readwrite) NSArray *originalErrorDomains;
@property (atomic, readwrite) NSArray *originalErrorCodes;

@end

@implementation JiveRetryingURLConnectionOperationTestsRetrier

#pragma mark - init/dealloc

- (id)init {
    self = [super init];
    if (self) {
        self.writeMonitor = [NSObject new];
        self.retryingOperations = [NSArray new];
        self.originalErrorDomains = [NSArray new];
        self.originalErrorCodes = [NSArray new];
    }
    return self;
}

#pragma mark - JiveOperationRetrier

- (void)retryingOperation:(NSOperation *)retryingOperation
     retryFailedOperation:(NSOperation *)failedOperation
      thatFailedWithError:(NSError *)originalError
           withRetryBlock:(JiveOperationRetrierRetryBlock)retryBlock
                failBlock:(JiveOperationRetrierFailBlock)failBlock {
    @synchronized(self.writeMonitor) {
        self.retryingOperations = [self.retryingOperations arrayByAddingObject:retryingOperation];
        self.originalErrorDomains = [self.originalErrorDomains arrayByAddingObject:[originalError domain]];
        self.originalErrorCodes = [self.originalErrorCodes arrayByAddingObject:@([originalError code])];
    }
    if (self.retryCount) {
        self.retryCount--;
        
        retryBlock();
    } else if (self.retryError) {
        failBlock(self.retryError);
    } else {
        failBlock(originalError);
    }
}

@end
