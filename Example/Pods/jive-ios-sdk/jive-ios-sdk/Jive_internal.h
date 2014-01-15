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
#import "JiveRetryingJAPIRequestOperation.h"

@class JAPIRequestOperation;

@interface Jive ()

@property(atomic, weak) id<JiveAuthorizationDelegate> delegate;
@property(nonatomic, strong, readwrite) JiveMetadata *instanceMetadata;
@property (nonatomic, strong) JivePlatformVersion *platformVersion;
@property (nonatomic, strong) NSString *baseURI;
@property (nonatomic, strong) NSString *badInstanceURL; // Only used while parsing JSON

- (NSString *)createStringWithInstanceURLValidation:(NSString *)sourceString;
- (NSURL *)createURLWithInstanceValidation:(NSString *)urlString;

- (NSMutableURLRequest *) credentialedRequestWithOptions:(NSObject<JiveRequestOptions>*)options
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

extern struct JiveHTTPMethodTypes {
    __unsafe_unretained NSString *POST;
    __unsafe_unretained NSString *PUT;
    __unsafe_unretained NSString *DELETE;
} const JiveHTTPMethodTypes;

extern struct JiveRequestPathComponents {
    __unsafe_unretained NSString *pushNotification;
    __unsafe_unretained NSString *oauthToken;
    __unsafe_unretained NSString *inbox;
    __unsafe_unretained NSString *people;
    __unsafe_unretained NSString *places;
    __unsafe_unretained NSString *content;
    __unsafe_unretained NSString *contents;
    __unsafe_unretained NSString *recommended;
    __unsafe_unretained NSString *trending;
    __unsafe_unretained NSString *activities;
    __unsafe_unretained NSString *frequent;
    __unsafe_unretained NSString *recent;
    __unsafe_unretained NSString *outcomes;
    __unsafe_unretained NSString *metadata;
    __unsafe_unretained NSString *metadataProperties;
    __unsafe_unretained NSString *me;
    __unsafe_unretained NSString *search;
    __unsafe_unretained NSString *editable;
} const JiveRequestPathComponents;
