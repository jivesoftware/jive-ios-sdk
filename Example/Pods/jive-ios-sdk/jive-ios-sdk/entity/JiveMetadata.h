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
typedef void (^JiveNumericCompletedBlock)(NSNumber *numericValue);

@interface JiveMetadata : NSObject

- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)hasVideo:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock;
- (AFJSONRequestOperation<JiveRetryingOperation> *)hasVideoOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                             onError:(JiveErrorBlock)errorBlock;

- (void)blogsEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock;
- (AFJSONRequestOperation<JiveRetryingOperation> *)blogsEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                        onError:(JiveErrorBlock)errorBlock;

- (void)realTimeChatEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock;
- (AFJSONRequestOperation<JiveRetryingOperation> *)realTimeChatEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                        onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)imagesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                  onError:(JiveErrorBlock)errorBlock;
- (void)imagesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
              onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)statusUpdatesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                         onError:(JiveErrorBlock)errorBlock;
- (void)statusUpdatesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                     onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)personalStatusUpdatesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                                 onError:(JiveErrorBlock)errorBlock;
- (void)personalStatusUpdatesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                             onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)placeStatusUpdatesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                              onError:(JiveErrorBlock)errorBlock;
- (void)placeStatusUpdatesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                          onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)repostStatusUpdatesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                               onError:(JiveErrorBlock)errorBlock;
- (void)repostStatusUpdatesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                           onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)statusUpdateMaxCharactersOperation:(JiveNumericCompletedBlock)completeBlock
                                                                              onError:(JiveErrorBlock)errorBlock;
- (void)statusUpdateMaxCharacters:(JiveNumericCompletedBlock)completeBlock
                          onError:(JiveErrorBlock)errorBlock;


- (AFJSONRequestOperation<JiveRetryingOperation> *)binaryDownloadsDisabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                            onError:(JiveErrorBlock)errorBlock;
- (void)binaryDownloadsDisabled:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)maxAttachmentSizeInKBOperation:(JiveNumericCompletedBlock)completeBlock
                                                                          onError:(JiveErrorBlock)errorBlock;

- (AFJSONRequestOperation<JiveRetryingOperation> *)shareEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                 onError:(JiveErrorBlock)errorBlock;
- (void)shareEnabled:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock;

- (void)maxAttachmentSizeInKB:(JiveNumericCompletedBlock)completeBlock
                      onError:(JiveErrorBlock)errorBlock;

@end
