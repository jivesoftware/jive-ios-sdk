//
//  JiveStatic.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveStatic.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveTypedObject_internal.h"

@implementation JiveStatic

@synthesize author, description, filename, jiveId, place, published, updated;

static NSString * const JiveStaticType = @"static";

+ (void)load {
    if (self == [JiveStatic class])
        [super registerClass:self forType:JiveStaticType];
}

- (NSString *)type {
    return JiveStaticType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:description forKey:@"description"];
    [dictionary setValue:filename forKey:@"filename"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:self.type forKey:@"type"];
    
    if (author)
        [dictionary setValue:[author toJSONDictionary] forKey:@"author"];
    
    if (place)
        [dictionary setValue:[place toJSONDictionary] forKey:@"place"];
    
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    return dictionary;
}

- (NSURL *)htmlRef {
    return [self resourceForTag:@"html"].ref;
}

@end
