//
//  JiveRetryingImageRequestOperation.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "AFImageRequestOperation.h"
#import "JiveRetryingOperation.h"
#include <AvailabilityMacros.h>

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

@end
