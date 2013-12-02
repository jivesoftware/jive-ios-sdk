//
//  JiveRetryingImageRequestOperation.m
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

#import "JiveRetryingImageRequestOperation.h"
#import "JiveRetryingInnerImageRequestOperation.h"
#import "JiveRetryingURLConnectionOperation+JiveProtected.h"

@interface JiveRetryingImageRequestOperation ()

@property (atomic, readwrite) JiveRetryingInnerImageRequestOperation *innerOperation;
@property (nonatomic) JiveKVOAdapter *KVOAdapter;

@end

@implementation JiveRetryingImageRequestOperation

#pragma mark - NSOperation

- (BOOL)isReady {
    // must call [super isReady] because of the -[NSOperation isReady] contract.
    // -[NSOperation isReady] tracks dependent operations for us.
    // -[AFURLConnectionOperation isReady] should always be true because we override all the -[NSOperation state changers]
    BOOL isReady = [super isReady] && [self.innerOperation isReady];
    return isReady;
}

- (BOOL)isExecuting {
    return [self.innerOperation isExecuting];
}

- (BOOL)isFinished {
    return [self.innerOperation isFinished];
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)start {
    [self.innerOperation start];
}

- (BOOL)isCancelled {
    return [self.innerOperation isCancelled];
}

- (void)cancel {
    [self.innerOperation cancel];
}

- (void)setCompletionBlock:(void (^)(void))block {
    [self.innerOperation setCompletionBlock:block];
}

#pragma mark - AFURLConnectionOperation

///-------------------------------
/// @name Accessing Run Loop Modes
///-------------------------------

- (NSSet *)runLoopModes {
    return self.innerOperation.runLoopModes;
}

- (void)setRunLoopModes:(NSSet *)runLoopModes {
    self.innerOperation.runLoopModes = runLoopModes;
}

///-----------------------------------------
/// @name Getting URL Connection Information
///-----------------------------------------

- (NSURLRequest *)request {
    return self.innerOperation.request;
}

- (NSError *)error {
    return self.innerOperation.error;
}

///----------------------------
/// @name Getting Response Data
///----------------------------

- (NSData *)responseData {
    return self.innerOperation.responseData;
}

- (NSString *)responseString {
    return self.innerOperation.responseString;
}

///-------------------------------
/// @name Managing URL Credentials
///-------------------------------

- (BOOL)shouldUseCredentialStorage {
    return self.innerOperation.shouldUseCredentialStorage;
}

- (void)setShouldUseCredentialStorage:(BOOL)shouldUseCredentialStorage {
    self.innerOperation.shouldUseCredentialStorage = shouldUseCredentialStorage;
}

- (NSURLCredential *)credential {
    return self.innerOperation.credential;
}

- (void)setCredential:(NSURLCredential *)credential {
    self.innerOperation.credential = credential;
}

///------------------------
/// @name Accessing Streams
///------------------------

- (NSInputStream *)inputStream {
    return self.innerOperation.inputStream;
}

- (void)setInputStream:(NSInputStream *)inputStream {
    self.innerOperation.inputStream = inputStream;
}

- (NSOutputStream *)outputStream {
    return self.innerOperation.outputStream;
}

- (void)setOutputStream:(NSOutputStream *)outputStream {
    self.innerOperation.outputStream = outputStream;
}

///---------------------------------------------
/// @name Managing Request Operation Information
///---------------------------------------------

- (NSDictionary *)userInfo {
    return self.innerOperation.userInfo;
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    self.innerOperation.userInfo = userInfo;
}

///------------------------------------------------------
/// @name Initializing an AFURLConnectionOperation Object
///------------------------------------------------------

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    // must use the designated initializer or isReady won't work properly
    self = [super initWithRequest:urlRequest];
    if (self) {
        self.innerOperation = [[JiveRetryingInnerImageRequestOperation alloc] initWithRequest:urlRequest
                                                                               outerOperation:self];
        self.KVOAdapter = [JiveKVOAdapter retryingOperationKVOAdapterWithSourceObject:self.innerOperation
                                                                         targetObject:self];
    }
    
    return self;
}

///----------------------------------
/// @name Pausing / Resuming Requests
///----------------------------------

- (void)pause {
    [self.innerOperation pause];
}

- (BOOL)isPaused {
    return [self.innerOperation isPaused];
}

- (void)resume {
    [self.innerOperation resume];
}

///----------------------------------------------
/// @name Configuring Backgrounding Task Behavior
///----------------------------------------------

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (void)setShouldExecuteAsBackgroundTaskWithExpirationHandler:(void (^)(void))handler {
    [self.innerOperation setShouldExecuteAsBackgroundTaskWithExpirationHandler:handler];
}
#endif

///---------------------------------
/// @name Setting Progress Callbacks
///---------------------------------

- (void)setUploadProgressBlock:(void (^)(NSUInteger, long long, long long))block {
    [self.innerOperation setUploadProgressBlock:block];
}

- (void)setDownloadProgressBlock:(void (^)(NSUInteger, long long, long long))block {
    [self.innerOperation setDownloadProgressBlock:block];
}

///-------------------------------------------------
/// @name Setting NSURLConnection Delegate Callbacks
///-------------------------------------------------

- (void)setAuthenticationAgainstProtectionSpaceBlock:(BOOL (^)(NSURLConnection *, NSURLProtectionSpace *))block {
    [self.innerOperation setAuthenticationAgainstProtectionSpaceBlock:block];
}

- (void)setAuthenticationChallengeBlock:(void (^)(NSURLConnection *, NSURLAuthenticationChallenge *))block {
    [self.innerOperation setAuthenticationChallengeBlock:block];
}

- (void)setRedirectResponseBlock:(NSURLRequest *(^)(NSURLConnection *, NSURLRequest *, NSURLResponse *))block {
    [self.innerOperation setRedirectResponseBlock:block];
}

- (void)setCacheResponseBlock:(NSCachedURLResponse *(^)(NSURLConnection *, NSCachedURLResponse *))block {
    [self.innerOperation setCacheResponseBlock:block];
}

#pragma mark - AFHTTPRequestOperation

///----------------------------------------------
/// @name Getting HTTP URL Connection Information
///----------------------------------------------

- (NSHTTPURLResponse *)response {
    return self.innerOperation.response;
}

///----------------------------------------------------------
/// @name Managing And Checking For Acceptable HTTP Responses
///----------------------------------------------------------

- (BOOL)hasAcceptableStatusCode {
    return self.innerOperation.hasAcceptableStatusCode;
}

- (BOOL)hasAcceptableContentType {
    return self.innerOperation.hasAcceptableContentType;
}

- (dispatch_queue_t)successCallbackQueue {
    return self.innerOperation.successCallbackQueue;
}

- (void)setSuccessCallbackQueue:(dispatch_queue_t)successCallbackQueue {
    self.innerOperation.successCallbackQueue = successCallbackQueue;
}

- (dispatch_queue_t)failureCallbackQueue {
    return self.innerOperation.failureCallbackQueue;
}

- (void)setFailureCallbackQueue:(dispatch_queue_t)failureCallbackQueue {
    self.innerOperation.failureCallbackQueue = failureCallbackQueue;
}

///------------------------------------------------------------
/// @name Managing Acceptable HTTP Status Codes & Content Types
///------------------------------------------------------------

+ (NSIndexSet *)acceptableStatusCodes {
    return [JiveRetryingInnerImageRequestOperation acceptableStatusCodes];
}

+ (void)addAcceptableStatusCodes:(NSIndexSet *)statusCodes {
    [JiveRetryingInnerImageRequestOperation addAcceptableStatusCodes:statusCodes];
}

+ (NSSet *)acceptableContentTypes {
    return [JiveRetryingInnerImageRequestOperation acceptableContentTypes];
}

+ (void)addAcceptableContentTypes:(NSSet *)contentTypes {
    [JiveRetryingInnerImageRequestOperation addAcceptableContentTypes:contentTypes];
}

///-----------------------------------------------------
/// @name Determining Whether A Request Can Be Processed
///-----------------------------------------------------

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    return [JiveRetryingInnerImageRequestOperation canProcessRequest:urlRequest];
}

///-----------------------------------------------------------
/// @name Setting Completion Block Success / Failure Callbacks
///-----------------------------------------------------------

/*
 * Don't override. Calls through to setCompletionBlock:, which we properly override.
 * Leaving this comment here to account for all public superclass methods
 * - (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
 */

#pragma mark - AFImageRequestOperation

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
success:(void (^)(UIImage *image))success DEPRECATED_ATTRIBUTE {
    NSAssert(NO, @"%@ is can't retry", NSStringFromSelector(_cmd));
    return nil;
}
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
success:(void (^)(NSImage *image))success DEPRECATED_ATTRIBUTE {
    NSAssert(NO, @"%@ is can't retry", NSStringFromSelector(_cmd));
    return nil;
}
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
imageProcessingBlock:(UIImage *(^)(UIImage *image))imageProcessingBlock
success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure DEPRECATED_ATTRIBUTE {
    NSAssert(NO, @"%@ is can't retry", NSStringFromSelector(_cmd));
    return nil;
}
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
imageProcessingBlock:(NSImage *(^)(NSImage *image))imageProcessingBlock
success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSImage *image))success
failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure DEPRECATED_ATTRIBUTE {
    NSAssert(NO, @"%@ is can't retry", NSStringFromSelector(_cmd));
    return nil;
}
#endif

#pragma clang diagnostic pop

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (UIImage *)responseImage {
    return self.innerOperation.responseImage;
}
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
- (NSImage *)responseImage {
    return self.innerOperation.responseImage;
}
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (CGFloat)imageScale {
    return self.innerOperation.imageScale;
}

- (void)setImageScale:(CGFloat)imageScale {
    self.innerOperation.imageScale = imageScale;
}
#endif

#pragma mark - JiveRetryingOperation

- (id<JiveOperationRetrier>)retrier {
    return self.innerOperation.retrier;
}

- (void)setRetrier:(id<JiveOperationRetrier>)retrier {
    self.innerOperation.retrier = retrier;
}

- (dispatch_queue_t)retryCallbackQueue {
    return self.innerOperation.retryCallbackQueue;
}

- (void)setRetryCallbackQueue:(dispatch_queue_t)retryCallbackQueue {
    self.innerOperation.retryCallbackQueue = retryCallbackQueue;
}

@end
