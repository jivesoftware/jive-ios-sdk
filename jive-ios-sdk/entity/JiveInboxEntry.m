//
//  JiveInboxEntry.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveInboxEntry.h"
#import "JiveActivityObject.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveMediaLink.h"
#import "JiveExtension.h"
#import "JiveOpenSocial.h"

@implementation JiveInboxEntry

@synthesize actor, content, generator, icon, jiveId, jive, object, openSocial, provider, published, target, title, updated, url, verb;

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
