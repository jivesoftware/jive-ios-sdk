//
//  JiveRetryingInnerHTTPRequestOperation.h
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

#import "JiveRetryingURLConnectionOperation.h"

@class JiveRetryingHTTPRequestOperation;

@interface JiveRetryingInnerHTTPRequestOperation : JiveRetryingURLConnectionOperation

#pragma mark - AFHTTPRequestOperation

@property (readonly, nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, readonly) BOOL hasAcceptableStatusCode;
@property (nonatomic, readonly) BOOL hasAcceptableContentType;
@property (nonatomic, assign) dispatch_queue_t successCallbackQueue;
@property (nonatomic, assign) dispatch_queue_t failureCallbackQueue;
+ (NSIndexSet *)acceptableStatusCodes;
+ (void)addAcceptableStatusCodes:(NSIndexSet *)statusCodes;
+ (NSSet *)acceptableContentTypes;
+ (void)addAcceptableContentTypes:(NSSet *)contentTypes;
+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest;
- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - JiveRetryingURLConnectionOperation

- (AFHTTPRequestOperation *)operation;

@end
