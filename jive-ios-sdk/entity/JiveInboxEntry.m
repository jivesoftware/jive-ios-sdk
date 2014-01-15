//
//  JiveInboxEntry.m
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

#import "JiveInboxEntry.h"
#import "JiveActivityObject.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveMediaLink.h"
#import "JiveExtension.h"
#import "JiveOpenSocial.h"

@implementation JiveInboxEntry

@synthesize actor, onBehalfOf, content, generator, icon, jiveId, jive, object, openSocial, provider, published, target, title, updated, url, verb;

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@ -'%@'", self.object.url, self.verb, self.object.displayName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:content forKey:@"content"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:title forKey:@"title"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    [dictionary setValue:verb forKey:@"verb"];
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    if (actor)
        [dictionary setValue:[actor toJSONDictionary] forKey:@"actor"];
    
    if (onBehalfOf)
        [dictionary setValue:[onBehalfOf toJSONDictionary] forKey:@"onBehalfOf"];
    
    if (generator)
        [dictionary setValue:[generator toJSONDictionary] forKey:@"generator"];
    
    if (icon)
        [dictionary setValue:[icon toJSONDictionary] forKey:@"icon"];
    
    if (jive)
        [dictionary setValue:[jive toJSONDictionary] forKey:@"jive"];
    
    if (object)
        [dictionary setValue:[object toJSONDictionary] forKey:@"object"];
    
    if (openSocial)
        [dictionary setValue:[openSocial toJSONDictionary] forKey:@"openSocial"];
    
    if (provider)
        [dictionary setValue:[provider toJSONDictionary] forKey:@"provider"];
    
    if (target)
        [dictionary setValue:[target toJSONDictionary] forKey:@"target"];
    
    return dictionary;
}




@end
