//
//  JiveRetryingURLConnectionOperationTests.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveAsyncTestCase.h"
#import "JiveOperationRetrier.h"

@class JiveRetryingURLConnectionOperation;

@interface JiveRetryingURLConnectionOperationTests : JiveAsyncTestCase {
    NSError *testError;
}

- (Class)classUnderTest;

- (OHHTTPStubsResponse *)successCallbackOHHTTPStubsResponseWithResponder:(OHHTTPStubsResponder)responder;

@end

@interface JiveRetryingURLConnectionOperationTestsRetrier : NSObject<JiveOperationRetrier>

@property (atomic, readonly) NSArray *retryingOperations;
@property (atomic, readonly) NSArray *originalErrorDomains;
@property (atomic, readonly) NSArray *originalErrorCodes;

@property (atomic) NSUInteger retryCount;
@property (atomic) NSError *retryError;

@end
