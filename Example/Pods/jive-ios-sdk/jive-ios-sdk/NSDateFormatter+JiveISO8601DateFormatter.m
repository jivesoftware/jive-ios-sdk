//
//  NSDateFormatter+JiveISO8601DateFormatter.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 1/18/13.
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
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [ISO8601DateFormatter setLocale:enUSPOSIXLocale];
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
