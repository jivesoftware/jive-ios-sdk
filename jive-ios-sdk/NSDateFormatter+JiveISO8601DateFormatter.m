//
//  NSDateFormatter+JiveISO8601DateFormatter.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 1/18/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import <objc/runtime.h>

static void * const NSDateFormatterJiveISO8601DateFormatterKey = @"JiveISO8601DateFormatter";

@implementation NSDateFormatter (JiveISO8601DateFormatter)

+ (instancetype) jive_threadLocalISO8601DateFormatter {
    NSThread *currentThread = [NSThread currentThread];
    NSDateFormatter *ISO8601DateFormatter = objc_getAssociatedObject(currentThread,
                                                                     NSDateFormatterJiveISO8601DateFormatterKey);
    if (!ISO8601DateFormatter) {
        ISO8601DateFormatter = [self new];
        [ISO8601DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [ISO8601DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        objc_setAssociatedObject(currentThread,
                                 NSDateFormatterJiveISO8601DateFormatterKey,
                                 ISO8601DateFormatter,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return ISO8601DateFormatter;
}

@end
