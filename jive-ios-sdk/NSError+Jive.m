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

NSString * const JiveErrorKeyMultipleErrors = @"JiveMultipleErrors";
NSString * const JiveErrorKeyUnsupportedActivityObjectObjectType = @"JiveUnsupportedActivityObjectObjectType";

@implementation NSError (Jive)

+ (instancetype) jive_errorWithMultipleErrors:(NSArray *)errors {
    return [[self class] errorWithDomain:JiveErrorDomain
                                    code:JiveErrorCodeMultipleErrors
                                userInfo:@{
             JiveErrorKeyMultipleErrors : errors,
            }];
}

+ (instancetype) jive_errorWithUnsupportedActivityObjectObjectType:(NSString *)unsupportedActivityObjectObjectType {
    return [[self class] errorWithDomain:JiveErrorDomain
                                    code:JiveErrorCodeUnsupportedActivityObjectObjectType
                                userInfo:@{
JiveErrorKeyUnsupportedActivityObjectObjectType : JiveErrorKeyUnsupportedActivityObjectObjectType,
            }];
}

@end
