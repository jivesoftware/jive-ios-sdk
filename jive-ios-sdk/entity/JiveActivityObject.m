//
//  JiveActivityObject.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

#import "JiveActivityObject.h"
#import "JiveMediaLink.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JiveActivityObject

@synthesize author, content, displayName, jiveId, image, objectType, published, summary, updated, url;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:content forKey:@"content"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:displayName forKey:@"displayName"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    [dictionary setValue:objectType forKey:@"objectType"];
    [dictionary setValue:summary forKey:@"summary"];
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    if (author)
        [dictionary setValue:[author toJSONDictionary] forKey:@"author"];
    
    if (image)
        [dictionary setValue:[image toJSONDictionary] forKey:@"image"];
    
    return dictionary;
}

@end
