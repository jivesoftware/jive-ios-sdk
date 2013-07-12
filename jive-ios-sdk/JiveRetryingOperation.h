//
//  JiveRetryingOperation.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JiveOperationRetrier;

@protocol JiveRetryingOperation <NSObject>

@property (atomic) id<JiveOperationRetrier> retrier;
@property (nonatomic, assign) dispatch_queue_t retryCallbackQueue;

@end
