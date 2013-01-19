//
//  NSDateFormatter+JiveISO8601DateFormatter.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 1/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (JiveISO8601DateFormatter)

+ (instancetype) jive_threadLocalISO8601DateFormatter;

@end
