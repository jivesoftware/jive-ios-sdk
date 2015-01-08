//
//  JiveRetryingImageRequestOperation.h
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

#import "AFImageRequestOperation.h"
#import "JiveRetryingOperation.h"
#include <AvailabilityMacros.h>
#import "JiveResponseBlocks.h"

@interface JiveRetryingImageRequestOperation : AFImageRequestOperation<JiveRetryingOperation>

// We can't support these methods because AFImageRequestOperation doesn't properly delegate them to subclasses.

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
										 success:(void (^)(UIImage *image))success DEPRECATED_ATTRIBUTE;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
										 success:(void (^)(NSImage *image))success DEPRECATED_ATTRIBUTE;
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
							imageProcessingBlock:(UIImage *(^)(UIImage *image))imageProcessingBlock
										 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
										 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure DEPRECATED_ATTRIBUTE;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
+ (instancetype)imageRequestOperationWithRequest:(NSURLRequest *)urlRequest
							imageProcessingBlock:(NSImage *(^)(NSImage *image))imageProcessingBlock
										 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSImage *image))success
										 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure DEPRECATED_ATTRIBUTE;
#endif

+ (id)createOperationForInvalidRequest:(JiveCompletedBlock)errorReporter;

@end
