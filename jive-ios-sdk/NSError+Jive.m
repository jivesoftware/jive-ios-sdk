//
//  NSError+Jive.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/5/12.
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

#import "NSError+Jive.h"

NSString * const JiveErrorDomain = @"Jive";

NSInteger const JiveErrorCodeMultipleErrors = 1;
NSInteger const JiveErrorCodeUnsupportedActivityObjectObjectType = 2;
NSInteger const JiveErrorCodeNilUnderlyingError = 3;

NSString * const JiveErrorKeyMultipleErrors = @"JiveMultipleErrors";
NSString * const JiveErrorKeyUnsupportedActivityObjectObjectType = @"JiveUnsupportedActivityObjectObjectType";
NSString * const JiveErrorKeyJSON = @"JiveErrorJSON";
NSString * const JiveErrorKeyHTTPStatusCode = @"JiveErrorHTTPStatusCode";

@implementation NSError (Jive)

+ (instancetype) jive_errorWithUnderlyingError:(NSError *)underlyingError {
    return [self jive_errorWithUnderlyingError:underlyingError
                                      withJSON:nil];
}

+ (instancetype) jive_errorWithUnderlyingError:(NSError *)underlyingError withJSON:(id)JSON {
    NSInteger code;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
    if (underlyingError) {
        code = underlyingError.code;
        userInfo[NSUnderlyingErrorKey] = underlyingError;
        userInfo[NSLocalizedDescriptionKey] = [underlyingError localizedDescription];
    } else {
        code = JiveErrorCodeNilUnderlyingError;
    }
    
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        id errorJSON = JSON[@"error"];
        if (errorJSON) {
            userInfo[JiveErrorKeyJSON] = errorJSON;
            if ([errorJSON isKindOfClass:[NSDictionary class]]) {
                id message = errorJSON[@"message"];
                if ([message isKindOfClass:[NSString class]]) {
                    userInfo[NSLocalizedRecoverySuggestionErrorKey] = message;
                }
                id status = errorJSON[@"status"];
                if ([status isKindOfClass:[NSNumber class]]) {
                    userInfo[JiveErrorKeyHTTPStatusCode] = status;
                }
            }
        } else {
            userInfo[JiveErrorKeyJSON] = JSON;
        }
    } else if (JSON) {
        userInfo[JiveErrorKeyJSON] = JSON;
    }
    
    NSError *error = [[self alloc] initWithDomain:JiveErrorDomain
                                             code:code
                                         userInfo:userInfo];
    return error;
}

+ (instancetype) jive_errorWithMultipleErrors:(NSArray *)errors {
    if ([errors count] > 1) {
        return [self errorWithDomain:JiveErrorDomain
                                code:JiveErrorCodeMultipleErrors
                            userInfo:(@{
                                      JiveErrorKeyMultipleErrors : errors,
                                      })];
    } else {
        return [self jive_errorWithUnderlyingError:[errors lastObject]];
    }
}

+ (instancetype) jive_errorWithUnsupportedActivityObjectObjectType:(NSString *)unsupportedActivityObjectObjectType {
    return [[self class] errorWithDomain:JiveErrorDomain
                                    code:JiveErrorCodeUnsupportedActivityObjectObjectType
                                userInfo:(@{
                                          JiveErrorKeyUnsupportedActivityObjectObjectType : JiveErrorKeyUnsupportedActivityObjectObjectType,
                                          })];
}

- (NSArray *)jive_multipleErrors {
    NSArray *multipleErrors = [self userInfo][JiveErrorKeyMultipleErrors];
    return multipleErrors;
}

- (NSString *)jive_unsupportedActivityObjectObjectType {
    NSString *unsupportedActivityObjectObjectType = [self userInfo][JiveErrorKeyUnsupportedActivityObjectObjectType];
    return unsupportedActivityObjectObjectType;
}

- (id)jive_JSON {
    id JSON = [self userInfo][JiveErrorKeyJSON];
    return JSON;
}

- (NSString *)jive_HTTPStatusCode {
    NSString *status = [self userInfo][JiveErrorKeyHTTPStatusCode];
    return status;
}

@end
