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
    return [self.instance propertyWithNameOperation:@"feature.rtc.enabled"
                                         onComplete:^(JiveProperty *rtcEnabledProperty) {
                                             completeBlock(rtcEnabledProperty.valueAsBOOL);
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

- (void)realTimeChatEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock {
    [[self realTimeChatEnabledOperation:completeBlock onError:errorBlock] start];
}

#pragma mark - Images

- (AFJSONRequestOperation<JiveRetryingOperation> *)imagesEnabledOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                                  onError:(JiveErrorBlock)errorBlock {
    return [self.instance propertyWithNameOperation:@"feature.images.enabled"
                                         onComplete:^(JiveProperty *imagesEnabledProperty) {
                                             completeBlock(imagesEnabledProperty.valueAsBOOL);
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

- (void)imagesEnabled:(JiveBOOLFlagCompletedBlock)completeBlock
              onError:(JiveErrorBlock)errorBlock {
    [[self imagesEnabledOperation:completeBlock onError:errorBlock] start];
}

@end
