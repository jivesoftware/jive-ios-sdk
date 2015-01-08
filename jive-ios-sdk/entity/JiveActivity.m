
//
//  JiveActivity.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/9/13.
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

#import "JiveActivity.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveObject_internal.h"


struct JiveActivityAttributes const JiveActivityAttributes = {
    .actor = @"actor",
    .content = @"content",
    .generator = @"generator",
    .icon = @"icon",
    .jiveId = @"jiveId",
    .jive = @"jive",
    .object = @"object",
    .openSocial = @"openSocial",
    .previewImage = @"previewImage",
    .provider = @"provider",
    .published = @"published",
    .target = @"target",
    .title = @"title",
    .type = @"type",
    .updated = @"updated",
    .url = @"url",
    .verb = @"verb",
};


@implementation JiveActivity

@synthesize actor, content, generator, icon, jive, jiveId, object, openSocial, provider, published;
@synthesize target, title, updated, url, verb, previewImage;

- (NSString *)type {
    return @"activity";
}

- (BOOL)deserializeKey:(NSString *)key fromJSON:(id)JSON fromInstance:(Jive *)jiveInstance {
    if ([JiveTypedObjectAttributes.type isEqualToString:key])
        return NO; // Having a type does not make this a valid JSON response.
    
    return [super deserializeKey:key fromJSON:JSON fromInstance:jiveInstance];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.type forKey:JiveActivityAttributes.type];
    [dictionary setValue:content forKey:JiveActivityAttributes.content];
    [dictionary setValue:jiveId forKey:JiveObjectConstants.id];
    [dictionary setValue:title forKey:JiveActivityAttributes.title];
    [dictionary setValue:[url absoluteString] forKey:JiveActivityAttributes.url];
    [dictionary setValue:verb forKey:JiveActivityAttributes.verb];
    if (icon)
        [dictionary setValue:[icon toJSONDictionary] forKey:JiveActivityAttributes.icon];
    
    if (jive)
        [dictionary setValue:[jive toJSONDictionary] forKey:JiveActivityAttributes.jive];
    
    if (object)
        [dictionary setValue:[object toJSONDictionary] forKey:JiveActivityAttributes.object];
    
    if (openSocial)
        [dictionary setValue:[openSocial toJSONDictionary] forKey:JiveActivityAttributes.openSocial];
    
    if (target)
        [dictionary setValue:[target toJSONDictionary] forKey:JiveActivityAttributes.target];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    if (actor) {
        [dictionary setValue:[actor persistentJSON] forKey:JiveActivityAttributes.actor];
    }
    
    if (generator) {
        [dictionary setValue:[generator persistentJSON] forKey:JiveActivityAttributes.generator];
    }
    
    if (jive)
        [dictionary setValue:[jive persistentJSON] forKey:JiveActivityAttributes.jive];
    
    if (object)
        [dictionary setValue:[object persistentJSON] forKey:JiveActivityAttributes.object];
    
    if (previewImage) {
        [dictionary setValue:[previewImage persistentJSON] forKey:JiveActivityAttributes.previewImage];
    }
    
    if (provider) {
        [dictionary setValue:[provider persistentJSON] forKey:JiveActivityAttributes.provider];
    }
    
    if (published) {
        [dictionary setValue:[dateFormatter stringFromDate:published]
                      forKey:JiveActivityAttributes.published];
    }
    
    if (target)
        [dictionary setValue:[target persistentJSON] forKey:JiveActivityAttributes.target];
    
    if (updated) {
        [dictionary setValue:[dateFormatter stringFromDate:updated]
                      forKey:JiveActivityAttributes.updated];
    }
    
    return dictionary;
}

@end
