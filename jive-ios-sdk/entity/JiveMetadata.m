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

- (AFJSONRequestOperation<JiveRetryingOperation> *)hasVideoOperation:(JiveBOOLFlagCompletedBlock)completeBlock
                                                             onError:(JiveErrorBlock)errorBlock {
    return [self.instance objectsOperationOnComplete:^(NSDictionary *objects) {
        completeBlock(NO);
    } onError:errorBlock];
}

- (void)hasVideo:(JiveBOOLFlagCompletedBlock)completeBlock onError:(JiveErrorBlock)errorBlock {
    [[self hasVideoOperation:completeBlock onError:errorBlock] start];
}

@end
