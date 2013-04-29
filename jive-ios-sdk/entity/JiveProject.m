//
//  JiveProject.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
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

#import "JiveProject.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveTypedObject_internal.h"

struct JiveProjectAttributes const JiveProjectAttributes = {
    .creator = @"creator",
    .dueDate = @"dueDate",
    .locale = @"locale",
    .projectStatus = @"projectStatus",
    .startDate = @"startDate",
    .tags = @"tags",
};

@implementation JiveProject

@synthesize creator, dueDate, locale, projectStatus, startDate, tags;

static NSString * const JiveProjectType = @"project";

+ (void)load {
    if (self == [JiveProject class])
        [super registerClass:self forType:JiveProjectType];
}

- (NSString *)type {
    return JiveProjectType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:projectStatus forKey:@"projectStatus"];
    [dictionary setValue:locale forKey:JiveProjectAttributes.locale];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (creator)
        [dictionary setValue:[creator toJSONDictionary] forKey:@"creator"];
    
    if (dueDate)
        [dictionary setValue:[dateFormatter stringFromDate:dueDate] forKey:@"dueDate"];
    
    if (startDate)
        [dictionary setValue:[dateFormatter stringFromDate:startDate] forKey:@"startDate"];
    
    return dictionary;
}

@end
