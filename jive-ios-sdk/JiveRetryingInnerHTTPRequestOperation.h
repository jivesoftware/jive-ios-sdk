//
//  JiveRetryingInnerHTTPRequestOperation.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
