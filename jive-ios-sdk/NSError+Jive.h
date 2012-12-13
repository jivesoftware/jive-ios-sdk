//
//  NSError+Jive.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/5/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const JiveErrorDomain;

extern NSInteger const JiveErrorCodeMultipleErrors;
extern NSInteger const JiveErrorCodeUnsupportedActivityObjectObjectType;

extern NSString * const JiveErrorKeyMultipleErrors;
extern NSString * const JiveErrorKeyUnsupportedActivityObjectObjectType;

@interface NSError (Jive)

+ (instancetype) jive_errorWithMultipleErrors:(NSArray *)errors;
+ (instancetype) jive_errorWithUnsupportedActivityObjectObjectType:(NSString *)unsupportedActivityObjectObjectType;

@end
