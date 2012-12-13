//
//  NSError+Jive.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/5/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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
