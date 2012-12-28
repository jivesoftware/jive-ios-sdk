//
//  JiveAttachment.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAttachment.h"
#import "JiveResourceEntry.h"

@implementation JiveAttachment

@synthesize contentType, doUpload, jiveId, name, resources, size, url;

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON {
    if ([@"resources" isEqualToString:property]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
        
        for (NSString *key in JSON) {
            JiveResourceEntry *entry = [JiveResourceEntry instanceFromJSON:[JSON objectForKey:key]];
            
            [dictionary setValue:entry forKey:key];
        }
        
        if (dictionary.count > 0)
            return [NSDictionary dictionaryWithDictionary:dictionary];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:contentType forKey:@"contentType"];
    [dictionary setValue:doUpload forKey:@"doUpload"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:size forKey:@"size"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    
    return dictionary;
}
@end
