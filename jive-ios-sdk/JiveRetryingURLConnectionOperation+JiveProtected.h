//
//  JiveRetryingURLConnectionOperation+JivePrivate.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
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

#import "JiveRetryingURLConnectionOperation.h"
#import "JiveKVOAdapter.h"

@interface JiveRetryingURLConnectionOperation ()

- (AFURLConnectionOperation *)outerOperation;
- (AFURLConnectionOperation *)operation;

+ (Class)operationClass;

- (id)initWithRequest:(NSURLRequest *)urlRequest
       outerOperation:(AFURLConnectionOperation *)outerOperation;

@end

@interface JiveKVOAdapter (JiveRetryingURLConnectionOperation)

+ (instancetype)retryingOperationKVOAdapterWithSourceObject:(id)sourceObject
                                               targetObject:(id)targetObject;

@end
