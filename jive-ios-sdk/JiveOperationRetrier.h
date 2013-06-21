//
//  JiveOperationRetrier.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JiveOperationRetrierRetryBlock)(void);
typedef void (^JiveOperationRetrierFailBlock)(NSError *error);

// ! \class JiveOperationRetrier
@protocol JiveOperationRetrier <NSObject>

//! Retry a request failed before sending the failure to the SDK consumer
- (void)retryingOperation:(NSOperation *)retryingOperation
     retryFailedOperation:(NSOperation *)failedOperation
      thatFailedWithError:(NSError *)originalError
           withRetryBlock:(JiveOperationRetrierRetryBlock)retryBlock
                failBlock:(JiveOperationRetrierFailBlock)failBlock;

@end
