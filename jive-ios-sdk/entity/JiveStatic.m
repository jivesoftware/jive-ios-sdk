//
//  JiveStatic.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveStatic.h"
#import "NSThread+JiveISO8601DateFormatter.h"
#import "JiveResourceEntry.h"

@implementation JiveStatic

@synthesize author, description, filename, jiveId, place, published, resources, updated;

- (id)init {
    if ((self = [super init])) {
        _type = @"static";
    }
    
    return self;
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

@end
