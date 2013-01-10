
//
//  JiveActivity.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/9/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
