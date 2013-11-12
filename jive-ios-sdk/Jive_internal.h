//
//  Jive_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 6/5/13.
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

#import "Jive.h"

@class JAPIRequestOperation;

@interface Jive ()

- (NSMutableURLRequest *) requestWithOptions:(NSObject<JiveRequestOptions>*)options
                                 andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION;
- (NSMutableURLRequest *) requestWithJSONBody:(JiveObject *)bodySource
                                      options:(NSObject<JiveRequestOptions>*)options
                                  andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION;

- (JiveRetryingJAPIRequestOperation *)operationWithRequest:(NSURLRequest *)request
                                                onComplete:(void(^)(id))completeBlock
                                                   onError:(JiveErrorBlock)errorBlock
                                           responseHandler:(id(^)(id JSON)) handler;
- (JAPIRequestOperation<JiveRetryingOperation> *)listOperationForClass:(Class)clazz
                                                               request:(NSURLRequest *)request
                                                            onComplete:(JiveArrayCompleteBlock)completeBlock
                                                               onError:(JiveErrorBlock)errorBlock;
- (AFImageRequestOperation<JiveRetryingOperation> *) imageOperationForPath:(NSString *)path
                                                                   options:(JiveDefinedSizeRequestOptions *)options
                                                                onComplete:(JiveImageCompleteBlock)completeBlock
                                                                   onError:(JiveErrorBlock)errorBlock;

@end
