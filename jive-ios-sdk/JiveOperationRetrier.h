//
//  JiveOperationRetrier.h
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

#import <Foundation/Foundation.h>
#import "JiveRetryingOperation.h"

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

-(NSOperation<JiveRetryingOperation>*)retriableOperationForFailedOperation:(NSOperation<JiveRetryingOperation>*)failedOperation;

@end
