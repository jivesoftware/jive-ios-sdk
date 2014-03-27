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
#import "JiveObject_internal.h"

struct JiveInboxEntryAttributes const JiveInboxEntryAttributes = {
    .actor = @"actor",
    .content = @"content",
    .generator = @"generator",
    .icon = @"icon",
    .jive = @"jive",
    .jiveId = @"jiveId",
    .object = @"object",
    .openSocial = @"openSocial",
    .provider = @"provider",
    .published = @"published",
    .target = @"target",
    .title = @"title",
    .url = @"url",
    .updated = @"updated",
    .verb = @"verb",
};

@implementation JiveInboxEntry

@synthesize actor, content, generator, icon, jiveId, jive, object, openSocial, provider, published, target, title, updated, url, verb;

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@ -'%@'", self.object.url, self.verb, self.object.displayName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:content forKey:JiveInboxEntryAttributes.content];
    [dictionary setValue:jiveId forKey:JiveObjectConstants.id];
    [dictionary setValue:title forKey:JiveInboxEntryAttributes.title];
    [dictionary setValue:verb forKey:JiveInboxEntryAttributes.verb];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    if (actor)
        [dictionary setValue:[actor persistentJSON] forKey:JiveInboxEntryAttributes.actor];
    
    if (generator)
        [dictionary setValue:[generator persistentJSON] forKey:JiveInboxEntryAttributes.generator];
    
    if (icon)
        [dictionary setValue:[icon persistentJSON] forKey:JiveInboxEntryAttributes.icon];
    
    if (jive)
        [dictionary setValue:[jive persistentJSON] forKey:JiveInboxEntryAttributes.jive];
    
    if (object)
        [dictionary setValue:[object persistentJSON] forKey:JiveInboxEntryAttributes.object];
    
    if (openSocial)
        [dictionary setValue:[openSocial persistentJSON] forKey:JiveInboxEntryAttributes.openSocial];
    
    if (provider)
        [dictionary setValue:[provider persistentJSON] forKey:JiveInboxEntryAttributes.provider];
    
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:JiveInboxEntryAttributes.published];
    
    if (target)
        [dictionary setValue:[target persistentJSON] forKey:JiveInboxEntryAttributes.target];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:JiveInboxEntryAttributes.updated];
    
    [dictionary setValue:[url absoluteString] forKey:JiveInboxEntryAttributes.url];
    
    return dictionary;
}


@end
