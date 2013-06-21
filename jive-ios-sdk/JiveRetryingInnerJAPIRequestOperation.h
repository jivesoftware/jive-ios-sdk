//
//  JiveRetryingInnerJAPIRequestOperation.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/24/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiveRetryingInnerHTTPRequestOperation.h"

@class JAPIRequestOperation;

@interface JiveRetryingInnerJAPIRequestOperation : JiveRetryingInnerHTTPRequestOperation

#pragma mark - AFJSONRequestOperation

@property (readonly, nonatomic) id responseJSON;
@property (nonatomic, assign) NSJSONReadingOptions JSONReadingOptions;
@property (readonly, nonatomic, strong) NSError *JSONError;
/*
 * Not implemented.
 * JiveRetryingJSONRequestOperation shouldn't delegate this method because
 * JiveRetryingJSONRequestOperation should already have implemented the dependencies
 * this method requires.
 * + (instancetype)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;
 */

#pragma mark - JiveRetryingInnerHTTPRequestOperation

- (JAPIRequestOperation *)operation;

@end
