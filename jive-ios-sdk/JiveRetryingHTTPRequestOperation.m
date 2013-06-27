//
//  JiveRetryingHTTPRequestOperation.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveRetryingHTTPRequestOperation.h"
#import "JiveRetryingURLConnectionOperation+JiveProtected.h"
#import "JiveRetryingInnerHTTPRequestOperation.h"

@interface JiveRetryingHTTPRequestOperation ()

@property (atomic, readwrite) JiveRetryingInnerHTTPRequestOperation *innerOperation;
@property (nonatomic) JiveKVOAdapter *KVOAdapter;

@end

@implementation JiveRetryingHTTPRequestOperation

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
        self.innerOperation = [[JiveRetryingInnerHTTPRequestOperation alloc] initWithRequest:urlRequest
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

- (void)setShouldExecuteAsBackgroundTaskWithExpirationHandler:(void (^)(void))handler {
    [self.innerOperation setShouldExecuteAsBackgroundTaskWithExpirationHandler:handler];
}

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
    return [JiveRetryingInnerHTTPRequestOperation acceptableStatusCodes];
}

+ (void)addAcceptableStatusCodes:(NSIndexSet *)statusCodes {
    [JiveRetryingInnerHTTPRequestOperation addAcceptableStatusCodes:statusCodes];
}

+ (NSSet *)acceptableContentTypes {
    return [JiveRetryingInnerHTTPRequestOperation acceptableContentTypes];
}

+ (void)addAcceptableContentTypes:(NSSet *)contentTypes {
    [JiveRetryingInnerHTTPRequestOperation addAcceptableContentTypes:contentTypes];
}

///-----------------------------------------------------
/// @name Determining Whether A Request Can Be Processed
///-----------------------------------------------------


+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    return [JiveRetryingInnerHTTPRequestOperation canProcessRequest:urlRequest];
}

///-----------------------------------------------------------
/// @name Setting Completion Block Success / Failure Callbacks
///-----------------------------------------------------------

/*
 * Don't override. Calls through to setCompletionBlock:, which we properly override.
 * Leaving this comment here to account for all public superclass methods
 * - (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
 */

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
