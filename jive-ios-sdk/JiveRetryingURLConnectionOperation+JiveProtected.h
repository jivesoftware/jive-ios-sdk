//
//  JiveRetryingURLConnectionOperation+JivePrivate.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveRetryingURLConnectionOperation.h"

@interface JiveRetryingURLConnectionOperation ()

- (AFURLConnectionOperation *)outerOperation;
- (AFURLConnectionOperation *)operation;

+ (Class)operationClass;

- (id)initWithRequest:(NSURLRequest *)urlRequest
       outerOperation:(AFURLConnectionOperation *)outerOperation;

@end
