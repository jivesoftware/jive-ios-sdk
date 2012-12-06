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
NSString * const JiveErrorKeyMultipleErrors = @"JiveMultipleErrors";

@implementation NSError (Jive)

+ (instancetype) jive_errorWithMultipleErrors:(NSArray *)errors {
    return [NSError errorWithDomain:JiveErrorDomain
                               code:JiveErrorCodeMultipleErrors
                           userInfo:@{
        JiveErrorKeyMultipleErrors : errors,
            }];
}

@end
