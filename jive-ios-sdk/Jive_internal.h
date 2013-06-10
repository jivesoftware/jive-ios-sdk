//
//  Jive_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 6/5/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Jive/Jive.h>

@class JAPIRequestOperation;

@interface Jive ()

- (NSMutableURLRequest *) requestWithOptions:(NSObject<JiveRequestOptions>*)options
                                 andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION;
- (NSMutableURLRequest *) requestWithJSONBody:(JiveObject *)bodySource
                                      options:(NSObject<JiveRequestOptions>*)options
                                  andTemplate:(NSString*)template, ... NS_REQUIRES_NIL_TERMINATION;

+ (JAPIRequestOperation *)operationWithRequest:(NSURLRequest *)request
                                    onComplete:(void(^)(id))completeBlock
                                       onError:(JiveErrorBlock)errorBlock
                               responseHandler:(id(^)(id JSON)) handler;
- (JAPIRequestOperation *)listOperationForClass:(Class)clazz
                                        request:(NSURLRequest *)request
                                     onComplete:(JiveArrayCompleteBlock)completeBlock
                                        onError:(JiveErrorBlock)errorBlock;

@end
