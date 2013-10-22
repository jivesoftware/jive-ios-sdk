//
//  JiveRetryingInnerHTTPRequestOperation.m
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
    AFHTTPRequestOperation *outerOperation = (AFHTTPRequestOperation *)self.outerOperation;
    [outerOperation setCompletionBlockWithSuccess:success
                                          failure:failure];
}

#pragma mark - JiveRetryingURLConnectionOperation

- (AFHTTPRequestOperation *)operation {
    return (AFHTTPRequestOperation *)[super operation];
}

+ (Class)operationClass {
    return [JiveClassDelegatingAFHTTPRequestOperation class];
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
