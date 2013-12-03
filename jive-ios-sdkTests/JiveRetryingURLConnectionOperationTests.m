//
//  JiveRetryingURLConnectionOperationTests.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
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

#import "JiveRetryingURLConnectionOperationTests.h"
#import "JiveRetryingURLConnectionOperation.h"
#import "JiveKVOTracker.h"

@interface JiveRetryingURLConnectionOperationTestsTestOperation : NSOperation

- (void)finish;

@end

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
    STAssertTrue([testObject isFinished], nil);
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
    STAssertTrue([testObject isFinished], nil);
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
    STAssertTrue([testObject isFinished], nil);
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
    STAssertTrue([testObject isFinished], nil);
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
    STAssertTrue([testObject isFinished], nil);
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

- (void)testOperationLifecycleCancellation {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self successCallbackOHHTTPStubsResponseWithResponder:^(dispatch_block_t respondBlock) {
            // don't capture the respondBlock - we don't want the operation to finish as we want to explicitly cancel it
        }];
    })];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    
    JiveKVOTracker * __block isExecutingKVOTracker;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        isExecutingKVOTracker  = [[JiveKVOTracker alloc] initWithObservationTarget:testObject
                                                                       keySelector:@selector(isExecuting)
                                                                           options:NSKeyValueObservingOptionNew
                                                                       changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
            finishedBlock();
        })
                                                                         inContext:NULL];
        
        
        [operationQueue addOperation:testObject];
    }];
    
    [isExecutingKVOTracker stopObserving];
    
    STAssertEqualObjects((@[
                          testObject,
                          ]), [operationQueue operations], nil);
    STAssertFalse([testObject isFinished], nil);
    STAssertFalse([testObject isCancelled], nil);
    
    JiveKVOTracker * __block isFinishedKVOTracker;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        isFinishedKVOTracker = [[JiveKVOTracker alloc] initWithObservationTarget:testObject
                                                                     keySelector:@selector(isFinished)
                                                                         options:NSKeyValueObservingOptionNew
                                                                     changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
            finishedBlock();
        })
                                                                       inContext:NULL];
        [operationQueue cancelAllOperations];
    }];
    
    [isFinishedKVOTracker stopObserving];
    
    STAssertEqualObjects((@[
                          ]), [operationQueue operations], nil);
    STAssertFalse([testObject isExecuting], nil);
    STAssertTrue([testObject isFinished], nil);
    STAssertTrue([testObject isCancelled], nil);
}

- (void)testOperationLifecyclePrecancel {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self successCallbackOHHTTPStubsResponseWithResponder:^(dispatch_block_t respondBlock) {
            // don't capture the respondBlock - we don't want the operation to finish as we want to explicitly cancel it
        }];
    })];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    
    BOOL __block didExecute = NO;
    JiveKVOTracker *isExecutingKVOTracker  = [[JiveKVOTracker alloc] initWithObservationTarget:testObject
                                                                   keySelector:@selector(isExecuting)
                                                                       options:NSKeyValueObservingOptionNew
                                                                   changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
        didExecute = YES;
    })
                                                                     inContext:NULL];
    
    [testObject cancel];
    
    STAssertFalse([testObject isFinished], nil);
    
    JiveKVOTracker * __block isFinishedKVOTracker;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        isFinishedKVOTracker = [[JiveKVOTracker alloc] initWithObservationTarget:testObject
                                                                     keySelector:@selector(isFinished)
                                                                         options:NSKeyValueObservingOptionNew
                                                                     changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
            finishedBlock();
        })
                                                                       inContext:NULL];
        [operationQueue addOperation:testObject];
    }];
    
    [isFinishedKVOTracker stopObserving];
    
    // give isExecuting some time to try to erroneously change
    [self delay];
    [isExecutingKVOTracker stopObserving];
    
    STAssertEqualObjects((@[
                          ]), [operationQueue operations], nil);
    STAssertFalse([testObject isExecuting], nil);
    STAssertTrue([testObject isFinished], nil);
    STAssertTrue([testObject isCancelled], nil);
}

- (void)testOperationLifecycleNormal {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    dispatch_block_t __block respondBlock = NULL;
    JiveKVOTracker * __block isExecutingKVOTracker;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        dispatch_block_t maybeFinishedBlock = ^{
            if ([testObject isExecuting] &&
                (respondBlock != NULL)) {
                finishedBlock();
            }
        };
        isExecutingKVOTracker  = [[JiveKVOTracker alloc] initWithObservationTarget:testObject
                                                                       keySelector:@selector(isExecuting)
                                                                           options:NSKeyValueObservingOptionNew
                                                                       changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
            maybeFinishedBlock();
        })
                                                                         inContext:NULL];
        [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
            return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
        })
                                  withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [self successCallbackOHHTTPStubsResponseWithResponder:^(dispatch_block_t respondBlock_) {
                respondBlock = respondBlock_;
                maybeFinishedBlock();
            }];
        })];
        
        [operationQueue addOperation:testObject];
    }];
    
    [isExecutingKVOTracker stopObserving];
    
    if (respondBlock) {
        STAssertEqualObjects((@[
                              testObject,
                              ]), [operationQueue operations], nil);
        STAssertTrue([testObject isExecuting], nil);
        STAssertFalse([testObject isFinished], nil);
        STAssertFalse([testObject isCancelled], nil);
        
        
        JiveKVOTracker * __block isFinishedKVOTracker;
        [self waitForTimeout:^(dispatch_block_t finishedBlock) {
            isFinishedKVOTracker = [[JiveKVOTracker alloc] initWithObservationTarget:testObject
                                                                         keySelector:@selector(isFinished)
                                                                             options:NSKeyValueObservingOptionNew
                                                                         changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
                finishedBlock();
            })
                                                                           inContext:NULL];
            respondBlock();
        }];
        
        [isFinishedKVOTracker stopObserving];
        
        STAssertEqualObjects((@[
                              ]), [operationQueue operations], nil);
        STAssertFalse([testObject isExecuting], nil);
        STAssertTrue([testObject isFinished], nil);
        STAssertFalse([testObject isCancelled], nil);
    } else {
        STFail(nil);
    }
}

- (void)testOperationLifecyclePredependent {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self successCallbackOHHTTPStubsResponseWithResponder:^(dispatch_block_t respondBlock_) {
            // don't capture the respondBlock - we don't want the operation to finish as we want to explicitly cancel it
        }];
    })];
    
    JiveRetryingURLConnectionOperationTestsTestOperation *testDependentOperation = [JiveRetryingURLConnectionOperationTestsTestOperation new];
    [testObject addDependency:testDependentOperation];
    
    JiveKVOTracker * __block isExecutingKVOTracker;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        isExecutingKVOTracker  = [[JiveKVOTracker alloc] initWithObservationTarget:testDependentOperation
                                                                       keySelector:@selector(isExecuting)
                                                                           options:NSKeyValueObservingOptionNew
                                                                       changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
            finishedBlock();
        })
                                                                         inContext:NULL];
        
        [operationQueue addOperations:(@[
                                       testDependentOperation,
                                       testObject,
                                       ])
                    waitUntilFinished:NO];
    }];
    
    [isExecutingKVOTracker stopObserving];
    
    STAssertEqualObjects((@[
                          testDependentOperation,
                          testObject,
                          ]), [operationQueue operations], nil);
    STAssertFalse([testObject isExecuting], nil);
    STAssertFalse([testObject isFinished], nil);
    STAssertFalse([testObject isCancelled], nil);
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        isExecutingKVOTracker  = [[JiveKVOTracker alloc] initWithObservationTarget:testObject
                                                                       keySelector:@selector(isExecuting)
                                                                           options:NSKeyValueObservingOptionNew
                                                                       changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
            finishedBlock();
        })
                                                                         inContext:NULL];
        
        [testDependentOperation finish];
    }];
    
    STAssertEqualObjects((@[
                          testObject,
                          ]), [operationQueue operations], nil);
    STAssertTrue([testObject isExecuting], nil);
    STAssertFalse([testObject isFinished], nil);
    STAssertFalse([testObject isCancelled], nil);
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [testObject setCompletionBlock:^{
            finishedBlock();
        }];
        
        [testObject cancel];
    }];
    
    STAssertEqualObjects((@[
                          ]), [operationQueue operations], nil);
    STAssertFalse([testObject isExecuting], nil);
    STAssertTrue([testObject isFinished], nil);
    STAssertTrue([testObject isCancelled], nil);
}

- (void)testOperationLifecyclePostdependent {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    JiveRetryingURLConnectionOperationTestsTestOperation *testDependentOperation = [JiveRetryingURLConnectionOperationTestsTestOperation new];
    [testDependentOperation addDependency:testObject];
    
    dispatch_block_t __block respondBlock = NULL;
    JiveKVOTracker * __block isExecutingKVOTracker;
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        dispatch_block_t maybeFinishedBlock = ^{
            if ([testObject isExecuting] &&
                (respondBlock != NULL)) {
                finishedBlock();
            }
        };
        isExecutingKVOTracker  = [[JiveKVOTracker alloc] initWithObservationTarget:testObject
                                                                       keySelector:@selector(isExecuting)
                                                                           options:NSKeyValueObservingOptionNew
                                                                       changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
            maybeFinishedBlock();
        })
                                                                         inContext:NULL];
        [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
            return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
        })
                                  withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [self successCallbackOHHTTPStubsResponseWithResponder:^(dispatch_block_t respondBlock_) {
                respondBlock = respondBlock_;
                maybeFinishedBlock();
            }];
        })];
        
        [operationQueue addOperations:(@[
                                       testObject,
                                       testDependentOperation,
                                       ])
                    waitUntilFinished:NO];
    }];
    
    [isExecutingKVOTracker stopObserving];
    
    if (respondBlock) {
        STAssertEqualObjects((@[
                              testObject,
                              testDependentOperation,
                              ]), [operationQueue operations], nil);
        STAssertTrue([testObject isExecuting], nil);
        STAssertFalse([testObject isFinished], nil);
        STAssertFalse([testObject isCancelled], nil);
        STAssertFalse([testDependentOperation isExecuting], nil);
        STAssertFalse([testDependentOperation isFinished], nil);
        STAssertFalse([testDependentOperation isCancelled], nil);
        
        
        [self waitForTimeout:^(dispatch_block_t finishedBlock) {
            isExecutingKVOTracker  = [[JiveKVOTracker alloc] initWithObservationTarget:testDependentOperation
                                                                           keySelector:@selector(isExecuting)
                                                                               options:NSKeyValueObservingOptionNew
                                                                           changeBlock:(^(id context, NSString *keyPath, id observationTarget, NSDictionary *change, JiveKVOTracker *strongWeakKVOTracker) {
                finishedBlock();
            })
                                                                             inContext:NULL];
            
            respondBlock();
        }];
        [isExecutingKVOTracker stopObserving];
        
        STAssertEqualObjects((@[
                              testDependentOperation,
                              ]), [operationQueue operations], nil);
        STAssertFalse([testObject isExecuting], nil);
        STAssertTrue([testObject isFinished], nil);
        STAssertFalse([testObject isCancelled], nil);
        STAssertTrue([testDependentOperation isExecuting], nil);
        STAssertFalse([testDependentOperation isFinished], nil);
        STAssertFalse([testDependentOperation isCancelled], nil);
        
        [self waitForTimeout:^(dispatch_block_t finishedBlock) {
            [testDependentOperation setCompletionBlock:^{
                finishedBlock();
            }];
            
            [testDependentOperation finish];
        }];
        
        STAssertEqualObjects((@[
                              ]), [operationQueue operations], nil);
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

-(NSOperation<JiveRetryingOperation>*)retriableOperationForFailedOperation:(NSOperation<JiveRetryingOperation>*)failedOperation {
    return [failedOperation copy];    
}
@end

@interface JiveRetryingURLConnectionOperationTestsTestOperation ()

@property (atomic) NSObject *stateMonitor;

@end

@implementation JiveRetryingURLConnectionOperationTestsTestOperation {
    BOOL _isExecuting;
    BOOL _isFinished;
}

- (id)init {
    self = [super init];
    if (self) {
        self.stateMonitor = [NSObject new];
    }
    return self;
}

#pragma mark - NSOperation

- (BOOL)isExecuting {
    BOOL isExecuting;
    @synchronized(self.stateMonitor) {
        isExecuting = _isExecuting;
    }
    
    return isExecuting;
}

- (BOOL)isFinished {
    BOOL isFinished;
    @synchronized(self.stateMonitor) {
        isFinished = _isFinished;
    }
    return isFinished;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)start {
    if ([self isReady]) {
        if ([self isCancelled]) {
            [self finish];
        } else {
            [self willChangeValueForKey:@"isExecuting"];
            @synchronized(self.stateMonitor) {
                _isExecuting = YES;
            }
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

- (void)cancel {
    [super cancel];
    [self finish];
}

#pragma mark - public API

- (void)finish {
    BOOL wasExecuting = [self isExecuting];
    if (wasExecuting) {
        [self willChangeValueForKey:@"isExecuting"];
    }
    [self willChangeValueForKey:@"isFinished"];
    @synchronized(self.stateMonitor) {
        if (wasExecuting) {
            _isExecuting = NO;
        }
        _isFinished = YES;
    }
    if (wasExecuting) {
        [self didChangeValueForKey:@"isExecuting"];
    }
    [self didChangeValueForKey:@"isFinished"];
}

@end
