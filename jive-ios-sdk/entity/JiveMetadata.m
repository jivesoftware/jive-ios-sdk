//
//  JiveMetadata.m
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

#import "JiveMetadata_internal.h"
#import "Jive.h"
#import "NSError+Jive.h"

@interface JiveMetadata ()

@end

@implementation JiveMetadata

- (id)init {
    return nil;
}

- (id)initWithInstance:(Jive *)instance {
    self = [super init];
    if (self) {
        self.instance = instance;
    }
    
    return self;
}

- (AFJSONRequestOperation<JiveRetryingOperation> *)boolPropertyOperation:(NSString *)propertySpecifier
                                                              onComplete:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                 onError:(JiveErrorBlock)errorBlock {
    return [self.instance propertyWithNameOperation:propertySpecifier
                                         onComplete:^(JiveProperty *property) {
                                             completeBlock(property.valueAsBOOL);
                                         }
                                            onError:^(NSError *error) {
                                                NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
                                                
                                                if ([[localizedDescription substringFromIndex:localizedDescription.length - 4]
                                                     isEqualToString:@" 404"] ||
                                                    [error.userInfo[JiveErrorKeyHTTPStatusCode] isEqualToNumber:@404]) {
                                                    
                                                    completeBlock(NO);
                                                } else {
                                                    errorBlock(error);
                                                }
                                            }];
}

#pragma mark - Video

- (AFJSONRequestOperation<JiveRetryingOperation> *)hasVideoOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                             onError:(JiveErrorBlock)errorBlock {
    return [self.instance objectsOperationOnComplete:^(NSDictionary *objects) {
        NSString *videoURL = [objects objectForKey:JiveVideoType];
        
        completeBlock(videoURL.length > 0);
    } onError:errorBlock];
}

- (void)hasVideo:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self hasVideoOperation:completeBlock onError:errorBlock] start];
}

#pragma mark - Real time chat

- (AFJSONRequestOperation<JiveRetryingOperation> *)realTimeChatEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                        onError:(JiveErrorBlock)errorBlock {
    return [self boolPropertyOperation:@"feature.rtc.enabled"
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (void)realTimeChatEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock {
    [[self realTimeChatEnabledOperation:completeBlock onError:errorBlock] start];
}

#pragma mark - Images

- (AFJSONRequestOperation<JiveRetryingOperation> *)imagesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                  onError:(JiveErrorBlock)errorBlock {
    return [self boolPropertyOperation:@"feature.images.enabled"
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (void)imagesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
              onError:(JiveErrorBlock)errorBlock {
    [[self imagesEnabledOperation:completeBlock onError:errorBlock] start];
}

#pragma mark - Status Updates

- (AFJSONRequestOperation<JiveRetryingOperation> *)statusUpdatesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                         onError:(JiveErrorBlock)errorBlock {
    return [self boolPropertyOperation:@"jive.coreapi.enable.statusupdates"
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (void)statusUpdatesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self statusUpdatesEnabledOperation:completeBlock onError:errorBlock] start];
}

#pragma mark - Personal Status Updates

- (AFJSONRequestOperation<JiveRetryingOperation> *)personalStatusUpdatesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                                 onError:(JiveErrorBlock)errorBlock {
    return [self boolPropertyOperation:@"feature.status_update.enabled"
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (void)personalStatusUpdatesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self personalStatusUpdatesEnabledOperation:completeBlock onError:errorBlock] start];
}

#pragma mark - Place Status Updates

- (AFJSONRequestOperation<JiveRetryingOperation> *)placeStatusUpdatesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                              onError:(JiveErrorBlock)errorBlock {
    return [self boolPropertyOperation:@"feature.status_update_place.enabled"
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (void)placeStatusUpdatesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self placeStatusUpdatesEnabledOperation:completeBlock onError:errorBlock] start];
}

#pragma mark - Repost Status Updates

- (AFJSONRequestOperation<JiveRetryingOperation> *)repostStatusUpdatesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                               onError:(JiveErrorBlock)errorBlock {
    return [self boolPropertyOperation:@"feature.status_update_repost.enabled"
                            onComplete:completeBlock
                               onError:errorBlock];
}

- (void)repostStatusUpdatesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self repostStatusUpdatesEnabledOperation:completeBlock onError:errorBlock] start];
}

#pragma mark - Status Update Max Characters

- (AFJSONRequestOperation<JiveRetryingOperation> *)statusUpdateMaxCharactersOperation:(JiveNumericCompletedBlock)completeBlock
                                                                              onError:(JiveErrorBlock)errorBlock {
    return [self.instance propertyWithNameOperation:@"feature.status_update.characters"
                                         onComplete:^(JiveProperty *property) {
                                             completeBlock(property.valueAsNumber);
                                         }
                                            onError:errorBlock];
}

- (void)statusUpdateMaxCharacters:(JiveNumericCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self statusUpdateMaxCharactersOperation:completeBlock onError:errorBlock] start];
}

@end
