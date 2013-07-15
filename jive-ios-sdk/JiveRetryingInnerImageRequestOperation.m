//
//  JiveRetryingInnerImageRequestOperation.m
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

#import "JiveRetryingInnerImageRequestOperation.h"
#import "JiveRetryingImageRequestOperation.h"

@interface JiveClassDelegatingImageRequestOperation : AFImageRequestOperation

@end

@implementation JiveRetryingInnerImageRequestOperation

#pragma mark - AFHTTPRequestOperation

+ (NSIndexSet *)acceptableStatusCodes {
    return [AFImageRequestOperation acceptableStatusCodes];
}

+ (void)addAcceptableStatusCodes:(NSIndexSet *)statusCodes {
    [AFImageRequestOperation addAcceptableStatusCodes:statusCodes];
}

+ (NSSet *)acceptableContentTypes {
    return [AFImageRequestOperation acceptableContentTypes];
}

+ (void)addAcceptableContentTypes:(NSSet *)contentTypes {
    [AFImageRequestOperation addAcceptableContentTypes:contentTypes];
}

// Don't delegate here. Replicate AFHTTPRequestOperation's default behavior
+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    return [AFImageRequestOperation canProcessRequest:urlRequest];
}

#pragma mark - AFImageRequestOperation

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (UIImage *)responseImage {
    return self.operation.responseImage;
}
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
- (NSImage *)responseImage {
    return self.operation.responseImage;
}
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (CGFloat)imageScale {
    return self.operation.imageScale;
}

- (void)setImageScale:(CGFloat)imageScale {
    self.operation.imageScale = imageScale;
}
#endif

#pragma mark - JiveRetryingURLConnectionOperation

+ (Class)operationClass {
    return [JiveClassDelegatingImageRequestOperation class];
}

#pragma mark - JiveRetryingInnerHTTPRequestOperation

- (AFImageRequestOperation *)operation {
    return (JiveClassDelegatingImageRequestOperation *)[super operation];
}

@end

@implementation JiveClassDelegatingImageRequestOperation

#pragma mark - AFHTTPRequestOperation

+ (NSIndexSet *)acceptableStatusCodes {
    return [JiveRetryingImageRequestOperation acceptableStatusCodes];
}

+ (NSSet *)acceptableContentTypes {
    return [JiveRetryingImageRequestOperation acceptableContentTypes];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    return [JiveRetryingImageRequestOperation canProcessRequest:urlRequest];
}

@end
