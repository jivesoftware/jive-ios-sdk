
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

@implementation JiveActivity

@synthesize actor, content, generator, icon, jive, jiveId, object, openSocial, provider, published;
@synthesize target, title, updated, url, verb;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:content forKey:@"content"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:title forKey:@"title"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    [dictionary setValue:verb forKey:@"verb"];
    if (actor)
        [dictionary setValue:[actor toJSONDictionary] forKey:@"actor"];
    
    if (icon)
        [dictionary setValue:[icon toJSONDictionary] forKey:@"icon"];
    
    if (jive)
        [dictionary setValue:[jive toJSONDictionary] forKey:@"jive"];
    
    if (object)
        [dictionary setValue:[object toJSONDictionary] forKey:@"object"];
    
    if (openSocial)
        [dictionary setValue:[openSocial toJSONDictionary] forKey:@"openSocial"];
    
    if (target)
        [dictionary setValue:[target toJSONDictionary] forKey:@"target"];
    
    return dictionary;
}

@end
