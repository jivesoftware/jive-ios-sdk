//
//  JiveMember.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveMember.h"
#import "NSThread+JiveISO8601DateFormatter.h"
#import "JiveResourceEntry.h"

@implementation JiveMember

@synthesize group, jiveId, person, published, resources, state, updated;

- (NSString *)type {
    return @"member";
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON {
    if ([@"resources" isEqualToString:property]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
        
        for (NSString *key in JSON) {
            JiveResourceEntry *entry = [JiveResourceEntry instanceFromJSON:[JSON objectForKey:key]];
            
            [dictionary setValue:entry forKey:key];
        }
        
        return dictionary.count > 0 ? [NSDictionary dictionaryWithDictionary:dictionary] : nil;
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:state forKey:@"state"];
    [dictionary setValue:self.type forKey:@"type"];
    if (person)
        [dictionary setValue:[person toJSONDictionary] forKey:@"person"];
    
    if (group)
        [dictionary setValue:[group toJSONDictionary] forKey:@"group"];
    
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    return dictionary;
}

@end
