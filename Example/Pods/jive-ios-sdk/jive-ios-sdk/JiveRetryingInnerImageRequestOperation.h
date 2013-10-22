//
//  JiveRetryingInnerImageRequestOperation.h
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

#import "JiveRetryingInnerHTTPRequestOperation.h"

@interface JiveRetryingInnerImageRequestOperation : JiveRetryingInnerHTTPRequestOperation

#pragma mark - AFImageRequestOperation

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
@property (readonly, nonatomic, strong) UIImage *responseImage;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
@property (readonly, nonatomic, strong) NSImage *responseImage;
#endif

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
@property (nonatomic, assign) CGFloat imageScale;
#endif

#pragma mark - JiveRetryingInnerHTTPRequestOperation

- (AFImageRequestOperation *)operation;

@end
