//
//  JiveRetryingInnerImageRequestOperation.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
