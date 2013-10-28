//
//  JiveMetadata.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 8/15/13.
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
#import "JiveResponseBlocks.h"

@protocol JiveRetryingOperation;

typedef void (^JiveBOOLFlagCompletedBlock)(BOOL flagValue);

@interface JiveMetadata : NSObject

- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)hasVideo:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock;
- (AFJSONRequestOperation<JiveRetryingOperation> *)hasVideoOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                             onError:(JiveErrorBlock)errorBlock;

- (void)realTimeChatEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock;
- (AFJSONRequestOperation<JiveRetryingOperation> *)realTimeChatEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                        onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)imagesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                  onError:(JiveErrorBlock)errorBlock;
- (void)imagesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
              onError:(JiveErrorBlock)errorBlock;

@end
