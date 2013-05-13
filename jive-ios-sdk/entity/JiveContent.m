//
//  JiveContent.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
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

#import "JiveContent.h"
#import "JiveTypedObject_internal.h"

#import "NSDateFormatter+JiveISO8601DateFormatter.h"

struct JiveContentAttributes const JiveContentAttributes = {
        .author = @"author",
        .content = @"content",
        .followerCount = @"followerCount",
        .highlightBody = @"highlightBody",
        .highlightSubject = @"highlightSubject",
        .highlightTags = @"highlightTags",
        .likeCount = @"likeCount",
        .parent = @"parent",
        .parentContent = @"parentContent",
        .parentPlace = @"parentPlace",
        .published = @"published",
        .replyCount = @"replyCount",
        .status = @"status",
        .subject = @"subject",
        .updated = @"updated",
        .viewCount = @"viewCount"
};

struct JiveContentResourceAttributes const JiveContentResourceAttributes = {
    .childOutcomeTypes = @"childOutcomeTypes",
    .extprops = @"extprops",
    .followingIn = @"followingIn",
    .html = @"html",
    .outcomes = @"outcomes",
    .outcomeTypes = @"outcomeTypes",
    .self = @"self"
};

@implementation JiveContent

@synthesize author, content, followerCount, highlightBody, highlightSubject, highlightTags, jiveId, likeCount, parent, parentContent, parentPlace, published, replyCount, status, subject, updated, viewCount;

static NSMutableDictionary *contentClasses;

+ (void)registerClass:(Class)clazz forType:(NSString *)type {
    [super registerClass:clazz forType:type];
    if (!contentClasses)
        contentClasses = [NSMutableDictionary dictionary];
    
    [contentClasses setValue:clazz forKey:type];
}

+ (Class) entityClass:(NSDictionary*) obj {
    NSString* type = [obj objectForKey:@"type"];
    
    if (!type)
        return [self class];
    
    return [[contentClasses objectsForKeys:[NSArray arrayWithObject:type]
                            notFoundMarker:[self class]] objectAtIndex:0];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:followerCount forKey:@"followerCount"];
    [dictionary setValue:highlightBody forKey:@"highlightBody"];
    [dictionary setValue:highlightSubject forKey:@"highlightSubject"];
    [dictionary setValue:highlightTags forKey:@"highlightTags"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:likeCount forKey:@"likeCount"];
    [dictionary setValue:parent forKey:@"parent"];
    [dictionary setValue:replyCount forKey:@"replyCount"];
    [dictionary setValue:status forKey:@"status"];
    [dictionary setValue:subject forKey:@"subject"];
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:viewCount forKey:@"viewCount"];
    
    if (author)
        [dictionary setValue:[author toJSONDictionary] forKey:@"author"];
    
    if (content)
        [dictionary setValue:[content toJSONDictionary] forKey:@"content"];
    
    if (parentContent)
        [dictionary setValue:[parentContent toJSONDictionary] forKey:@"parentContent"];
    
    if (parentPlace)
        [dictionary setValue:[parentPlace toJSONDictionary] forKey:@"parentPlace"];
    
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    return dictionary;
}

@end
