//
//  NSError+Jive.h
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

#import <Foundation/Foundation.h>

@class JivePlatformVersion;

extern NSString * const JiveErrorDomain;

extern NSInteger const JiveErrorCodeMultipleErrors;
extern NSInteger const JiveErrorCodeUnsupportedActivityObjectObjectType;
extern NSInteger const JiveErrorCodeNilUnderlyingError;
extern NSInteger const JiveErrorCodeUnsupportedJivePlatformVersion;
extern NSInteger const JiveErrorCodeInvalidJSON;
extern NSInteger const JiveErrorCodeUnauthorizedActivityObjectType;
extern NSInteger const JiveErrorCodeRequiresTermsAndConditionsAccpetance;

extern NSString * const JiveErrorKeyMultipleErrors;
extern NSString * const JiveErrorKeyUnsupportedActivityObjectObjectType;
extern NSString * const JiveErrorKeyJSON;
extern NSString * const JiveErrorKeyHTTPStatusCode;
extern NSString * const JiveErrorKeyJivePlatformVersion;
extern NSString * const JiveErrorKeyUnauthorizedActivityObjectType;
extern NSString * const JiveErrorKeyTermsAndConditionsAPI;

extern NSString * const JiveErrorMessageUnauthorizedUserMarkCorrectAnswer;

@interface NSError (Jive)

@property (nonatomic, readonly) NSArray *jive_multipleErrors;
@property (nonatomic, readonly) NSString *jive_unsupportedActivityObjectObjectType;
@property (nonatomic, readonly) id jive_JSON;
@property (nonatomic, readonly) NSNumber *jive_HTTPStatusCode;

+ (instancetype) jive_errorWithUnderlyingError:(NSError *)underlyingError;
+ (instancetype) jive_errorWithUnderlyingError:(NSError *)underlyingError JSON:(id)JSON;
+ (instancetype) jive_errorWithMultipleErrors:(NSArray *)errors;
+ (instancetype) jive_errorWithUnsupportedActivityObjectObjectType:(NSString *)unsupportedActivityObjectObjectType;
+ (instancetype) jive_errorWithUnsupportedJivePlatformVersion:(JivePlatformVersion *)jivePlatformVersion;
+ (instancetype) jive_errorWithUnauthorizedActivityObjectType:(NSString *)unauthorizedActivityObjectType;
+ (instancetype) jive_errorWithInvalidJSON:(id)JSON;
+ (instancetype) jive_errorRequiresTermsAndConditionsAcceptance:(NSString *)termsAndConditionsPath;

@end
