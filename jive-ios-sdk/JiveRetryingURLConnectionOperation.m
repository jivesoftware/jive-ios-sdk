//
//  JiveRetryingURLConnectionOperation.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/20/13.
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
#import "JiveRetryingURLConnectionOperation+JiveProtected.h"
#import "JiveOperationRetrier.h"
#import "JiveRetryingOperation.h"

@interface JiveRetryingURLConnectionOperation () {
    BOOL _isExecuting;
    BOOL _isFinished;
    BOOL _isCancelled;
    
    AFURLConnectionOperation * __weak _outerOperation;
}
@property (atomic) NSObject *stateMonitor;
@property (atomic) NSObject *operationMonitor;
@property (atomic) AFURLConnectionOperation *operation;
@property (atomic) NSError *retryError;

- (void)setOuterOperation:(AFURLConnectionOperation *)outerOperation;

@end

@implementation JiveRetryingURLConnectionOperation

@synthesize retrier = _retrier;
@synthesize operation = _operation;
@synthesize retryCallbackQueue = _retryCallbackQueue;

#pragma mark - NSObject

- (void)dealloc {
    self.operation = nil;
}

#pragma mark - NSOperation

- (BOOL)isReady {
    // must call [super isReady] because of the -[NSOperation isReady] contract.
    // -[NSOperation isReady] tracks dependent operations for us.
    // -[AFURLConnectionOperation isReady] should always be true because we override all the -[NSOperation state changers]
    BOOL isReady = [super isReady] && [self.operation isReady];
    return isReady;
}

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
            [self jive_finish];
        } else {
            [self willChangeValueForKey:@"isExecuting"];
            @synchronized(self.stateMonitor) {
                _isExecuting = YES;
            }
            [self didChangeValueForKey:@"isExecuting"];
            
            [self.operation start];
        }
    }
}

- (BOOL)isCancelled {
    BOOL isCancelled;
    @synchronized(self.stateMonitor) {
        isCancelled = _isCancelled;
    }
    return isCancelled;
}

- (void)cancel {
    if (![self isFinished] && ![self isCancelled]) {
        [self willChangeValueForKey:@"isCancelled"];
        @synchronized(self.stateMonitor) {
            _isCancelled = YES;
        }
        [self didChangeValueForKey:@"isCancelled"];
        
        [self.operation cancel];
    }
}

/*
 * No need to override setCompletionBlock. -[AFURLConnectionOperation setCompletionBlock:] is fine for us.
 * Leaving this comment here to account for all public superclass methods
 - (void)setCompletionBlock:(void (^)(void))block;
 */

#pragma mark - AFURLConnectionOperation

///-------------------------------
/// @name Accessing Run Loop Modes
///-------------------------------

- (NSSet *)runLoopModes {
    return self.operation.runLoopModes;
}

- (void)setRunLoopModes:(NSSet *)runLoopModes {
    self.operation.runLoopModes = runLoopModes;
}

///-----------------------------------------
/// @name Getting URL Connection Information
///-----------------------------------------

- (NSURLRequest *)request {
    return self.operation.request;
}

- (NSURLResponse *)response {
    if ([self isFinished]) {
        return self.operation.response;
    } else {
        return nil;
    }
}

- (NSError *)error {
    if ([self isFinished]) {
        if (self.retryError) {
            return self.retryError;
        } else {
            return self.operation.error;
        }
    } else {
        return nil;
    }
}

///----------------------------
/// @name Getting Response Data
///----------------------------

- (NSData *)responseData {
    if ([self isFinished]) {
        return self.operation.responseData;
    } else {
        return nil;
    }
}

- (NSString *)responseString {
    if ([self isFinished]) {
        return self.operation.responseString;
    } else {
        return nil;
    }
}

///-------------------------------
/// @name Managing URL Credentials
///-------------------------------

- (BOOL)shouldUseCredentialStorage {
    return self.operation.shouldUseCredentialStorage;
}

- (void)setShouldUseCredentialStorage:(BOOL)shouldUseCredentialStorage {
    self.operation.shouldUseCredentialStorage = shouldUseCredentialStorage;
}

- (NSURLCredential *)credential {
    return self.operation.credential;
}

- (void)setCredential:(NSURLCredential *)credential {
    self.operation.credential = credential;
}

///------------------------
/// @name Accessing Streams
///------------------------

- (NSInputStream *)inputStream {
    return self.operation.inputStream;
}

- (void)setInputStream:(NSInputStream *)inputStream {
    self.operation.inputStream = inputStream;
}

- (NSOutputStream *)outputStream {
    return self.operation.outputStream;
}

- (void)setOutputStream:(NSOutputStream *)outputStream {
    self.operation.outputStream = outputStream;
}

///---------------------------------------------
/// @name Managing Request Operation Information
///---------------------------------------------

- (NSDictionary *)userInfo {
    return self.operation.userInfo;
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    self.operation.userInfo = userInfo;
}

///------------------------------------------------------
/// @name Initializing an AFURLConnectionOperation Object
///------------------------------------------------------

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    return [self initWithRequest:urlRequest
                  outerOperation:nil];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest
       outerOperation:(AFURLConnectionOperation *)outerOperation {
    // must use the designated initializer or isReady won't work properly
    self = [super initWithRequest:urlRequest];
    if (self) {
        self.stateMonitor = [NSObject new];
        self.operationMonitor = [NSObject new];
        if (outerOperation) {
            [self setOuterOperation:outerOperation];
        } else {
            [self setOuterOperation:self];
        }
        self.operation = [[[[self class] operationClass] alloc] initWithRequest:urlRequest];
    }
    
    return self;
}

///----------------------------------
/// @name Pausing / Resuming Requests
///----------------------------------

- (void)pause {
    [self.operation pause];
}

- (BOOL)isPaused {
    return [self.operation isPaused];
}

- (void)resume {
    [self.operation resume];
}

///----------------------------------------------
/// @name Configuring Backgrounding Task Behavior
///----------------------------------------------

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (void)setShouldExecuteAsBackgroundTaskWithExpirationHandler:(void (^)(void))handler {
    [self.operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:handler];
}
#endif

///---------------------------------
/// @name Setting Progress Callbacks
///---------------------------------

- (void)setUploadProgressBlock:(void (^)(NSUInteger, long long, long long))block {
    [self.operation setUploadProgressBlock:block];
}

- (void)setDownloadProgressBlock:(void (^)(NSUInteger, long long, long long))block {
    [self.operation setDownloadProgressBlock:block];
}

///-------------------------------------------------
/// @name Setting NSURLConnection Delegate Callbacks
///-------------------------------------------------

- (void)setWillSendRequestForAuthenticationChallengeBlock:(void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge))block {
    [self.operation setWillSendRequestForAuthenticationChallengeBlock:block];
}

- (void)setRedirectResponseBlock:(NSURLRequest *(^)(NSURLConnection *, NSURLRequest *, NSURLResponse *))block {
    [self.operation setRedirectResponseBlock:block];
}

- (void)setCacheResponseBlock:(NSCachedURLResponse *(^)(NSURLConnection *, NSCachedURLResponse *))block {
    [self.operation setCacheResponseBlock:block];
}

#pragma mark - protected API

- (AFURLConnectionOperation *)outerOperation {
    return _outerOperation;
}

- (NSOperation *)operation {
    NSOperation *operation;
    @synchronized(self.operationMonitor) {
        operation = _operation;
    }
    return operation;
}

+ (Class)operationClass {
    return [AFURLConnectionOperation class];
}

#pragma mark - private API

- (void)setOuterOperation:(AFURLConnectionOperation *)outerOperation {
    _outerOperation = outerOperation;
}

- (void)setOperation:(AFURLConnectionOperation *)operation {
    @synchronized(self.operationMonitor) {
        if (_operation != operation) {
            [_operation setCompletionBlock:NULL];
            [_operation cancel];
            
            _operation = operation;
            
            if (_operation) {
                // if we're in -dealloc, we can't weakify self.
                __typeof__(self) __weak weakSelf = self;
                [_operation setCompletionBlock:^{
                    __typeof__(weakSelf) __strong strongWeakSelf = weakSelf;
                    if ([strongWeakSelf isCancelled]) {
                        [strongWeakSelf jive_finish];
                    } else {
                        NSError *error = strongWeakSelf.operation.error;
                        __typeof__(strongWeakSelf.retrier) retrier = strongWeakSelf.retrier;
                        if (error && retrier) {
                            AFURLConnectionOperation *failedOperation = strongWeakSelf.operation;
                            
                            dispatch_queue_t retryCallbackQueue;
                            if (strongWeakSelf.retryCallbackQueue) {
                                retryCallbackQueue = strongWeakSelf.retryCallbackQueue;
                            } else {
                                retryCallbackQueue = dispatch_get_main_queue();
                            }
                            
                            dispatch_async(retryCallbackQueue, ^{
                                [retrier retryingOperation:strongWeakSelf.outerOperation
                                      retryFailedOperation:failedOperation
                                       thatFailedWithError:error
                                            withRetryBlock:[(^{
                                    AFURLConnectionOperation* newOperation = (AFURLConnectionOperation*) [strongWeakSelf.retrier retriableOperationForFailedOperation:(id<JiveRetryingOperation>)strongWeakSelf.operation];
                                    strongWeakSelf.operation = newOperation;
                                    [strongWeakSelf.operation start];
                                }) copy]
                                                 failBlock:[(^(NSError *retryError) {
                                    strongWeakSelf.operation = operation;
                                    strongWeakSelf.retryError = retryError;
                                    [strongWeakSelf jive_finish];
                                }) copy]];
                            });
                        } else {
                            [strongWeakSelf jive_finish];
                        }
                    }
                }];
            }
        }
    }
}

- (void)jive_finish {
    self.retrier = nil;
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

@implementation JiveKVOAdapter (JiveRetryingURLConnectionOperation)

+ (instancetype)retryingOperationKVOAdapterWithSourceObject:(id)sourceObject
                                               targetObject:(id)targetObject {
    return [[self alloc] initWithSourceObject:sourceObject
                                 targetObject:targetObject
                            keyPathsToObserve:(@[
                                               NSStringFromSelector(@selector(isCancelled)),
                                               NSStringFromSelector(@selector(isExecuting)),
                                               NSStringFromSelector(@selector(isFinished)),
                                               ])];
}

@end
