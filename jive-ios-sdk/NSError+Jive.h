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
extern NSString * const JiveErrorKeyMultipleErrors;

@interface NSError (Jive)

+ (instancetype) jive_errorWithMultipleErrors:(NSArray *)errors;

@end
