//
//  JiveRetryingInnerHTTPRequestOperation.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveRetryingInnerHTTPRequestOperation.h"
#import "JiveRetryingURLConnectionOperation+JiveProtected.h"
#import "JiveRetryingHTTPRequestOperation.h"

@interface JiveClassDelegatingAFHTTPRequestOperation : AFHTTPRequestOperation

@end

@implementation JiveRetryingInnerHTTPRequestOperation

#pragma mark - AFHTTPRequestOperation

- (NSHTTPURLResponse *)response {
    return self.operation.response;
}

- (BOOL)hasAcceptableStatusCode {
    return self.operation.hasAcceptableStatusCode;
}

- (BOOL)hasAcceptableContentType {
    return self.operation.hasAcceptableContentType;
}

- (dispatch_queue_t)successCallbackQueue {
    return self.operation.successCallbackQueue;
}

- (void)setSuccessCallbackQueue:(dispatch_queue_t)successCallbackQueue {
    self.operation.successCallbackQueue = successCallbackQueue;
}

- (dispatch_queue_t)failureCallbackQueue {
    return self.operation.failureCallbackQueue;
}

- (void)setFailureCallbackQueue:(dispatch_queue_t)failureCallbackQueue {
    self.operation.failureCallbackQueue = failureCallbackQueue;
}

+ (NSIndexSet *)acceptableStatusCodes {
    return [AFHTTPRequestOperation acceptableStatusCodes];
}

+ (void)addAcceptableStatusCodes:(NSIndexSet *)statusCodes {
    [AFHTTPRequestOperation addAcceptableStatusCodes:statusCodes];
}

+ (NSSet *)acceptableContentTypes {
    return [AFHTTPRequestOperation acceptableContentTypes];
}

+ (void)addAcceptableContentTypes:(NSSet *)contentTypes {
    [AFHTTPRequestOperation addAcceptableContentTypes:contentTypes];
}

// Don't delegate here. Replicate AFHTTPRequestOperation's default behavior
+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    if ([[self class] isEqual:[JiveRetryingInnerHTTPRequestOperation class]]) {
        return YES;
    } else {
        return [AFHTTPRequestOperation canProcessRequest:urlRequest];
    }
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self.outerOperation setCompletionBlockWithSuccess:success
                                               failure:failure];
}

#pragma mark - JiveRetryingURLConnectionOperation

- (AFHTTPRequestOperation *)operation {
    return (AFHTTPRequestOperation *)[super operation];
}

+ (Class)operationClass {
    return [JiveClassDelegatingAFHTTPRequestOperation class];
}

#pragma mark - public API

+ (NSIndexSet *)JiveAFAcceptableStatusCodes {
    return nil;
}

+ (NSSet *)JiveAFAcceptableContentTypes {
    return nil;
}

+ (BOOL)JiveAFCanProcessRequest:(NSURLRequest *)urlRequest {
    return NO;
}

@end

@implementation JiveClassDelegatingAFHTTPRequestOperation

#pragma mark - AFHTTPRequestOperation

+ (NSIndexSet *)acceptableStatusCodes {
    return [JiveRetryingHTTPRequestOperation acceptableStatusCodes];
}

+ (NSSet *)acceptableContentTypes {
    return [JiveRetryingHTTPRequestOperation acceptableContentTypes];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    return [JiveRetryingHTTPRequestOperation canProcessRequest:urlRequest];
}

@end
