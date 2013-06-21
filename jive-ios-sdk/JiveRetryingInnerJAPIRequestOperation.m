//
//  JiveRetryingInnerJAPIRequestOperation.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/24/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveRetryingInnerJAPIRequestOperation.h"
#import "JAPIRequestOperation.h"
#import "JiveRetryingJAPIRequestOperation.h"

@interface AFJSONRequestOperation ()

@property (readwrite, nonatomic, strong) NSError *JSONError;

@end

@interface JiveClassDelegatingAndJSONErroringJAPIRequestOperation : JAPIRequestOperation

@end

@implementation JiveRetryingInnerJAPIRequestOperation

#pragma mark - AFHTTPRequestOperation

+ (NSIndexSet *)acceptableStatusCodes {
    return [AFJSONRequestOperation acceptableStatusCodes];
}

+ (void)addAcceptableStatusCodes:(NSIndexSet *)statusCodes {
    [AFJSONRequestOperation addAcceptableStatusCodes:statusCodes];
}

+ (NSSet *)acceptableContentTypes {
    return [AFJSONRequestOperation acceptableContentTypes];
}

+ (void)addAcceptableContentTypes:(NSSet *)contentTypes {
    [AFJSONRequestOperation addAcceptableContentTypes:contentTypes];
}

// Don't delegate here. Replicate AFHTTPRequestOperation's default behavior
+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    return [AFJSONRequestOperation canProcessRequest:urlRequest];
}

#pragma mark - AFJSONRequestOperation

- (id)responseJSON {
    return self.operation.responseJSON;
}

- (NSJSONReadingOptions)JSONReadingOptions {
    return self.operation.JSONReadingOptions;
}

- (void)setJSONReadingOptions:(NSJSONReadingOptions)JSONReadingOptions {
    self.operation.JSONReadingOptions = JSONReadingOptions;
}

- (NSError *)JSONError {
    return self.operation.JSONError;
}

/*
 * Not implemented. See Header.
 * + (instancetype)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;
 */

#pragma mark - JiveRetryingURLConnectionOperation

+ (Class)operationClass {
    return [JiveClassDelegatingAndJSONErroringJAPIRequestOperation class];
}

#pragma mark - JiveRetryingInnerHTTPRequestOperation

- (JAPIRequestOperation *)operation {
    return (JiveClassDelegatingAndJSONErroringJAPIRequestOperation *)[super operation];
}

@end

@implementation JiveClassDelegatingAndJSONErroringJAPIRequestOperation

#pragma mark - AFHTTPRequestOperation

+ (NSIndexSet *)acceptableStatusCodes {
    return [JiveRetryingJAPIRequestOperation acceptableStatusCodes];
}

+ (NSSet *)acceptableContentTypes {
    return [JiveRetryingJAPIRequestOperation acceptableContentTypes];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    return [JiveRetryingJAPIRequestOperation canProcessRequest:urlRequest];
}

#pragma mark - AFJSONRequestOperation

- (NSError *)error {
    if (self.JSONError) {
        return self.JSONError;
    } else {
        return [super error];
    }
}

@end
