//
//  NSThread+JiveISO8601DateFormatter.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/12/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "NSThread+JiveISO8601DateFormatter.h"
#import <objc/runtime.h>

static NSString * const JiveISO8601DateFormatterKey = @"JiveISO8601DateFormatter";

@implementation NSThread (JiveISO8601DateFormatter)

- (NSDateFormatter *)jive_ISO8601DateFormatter {
    NSDateFormatter *ISO8601DateFormatter = objc_getAssociatedObject(self,
                                                                     (__bridge void *)JiveISO8601DateFormatterKey);
    if (!ISO8601DateFormatter) {
        ISO8601DateFormatter = [NSDateFormatter new];
        [ISO8601DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [ISO8601DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        objc_setAssociatedObject(self,
                                 (__bridge void *)JiveISO8601DateFormatterKey,
                                 ISO8601DateFormatter,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return ISO8601DateFormatter;
}

@end
