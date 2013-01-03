//
//  JiveCategory.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveCategory.h"
#import "JiveResourceEntry.h"

@implementation JiveCategory

@synthesize description, followerCount, jiveId, likeCount, name, place, published, resources, tags, updated;

- (NSString *)type {
    return @"category";
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
    
    [dictionary setValue:description forKey:@"description"];
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:self.type forKey:@"type"];
    
    return dictionary;
}

@end
