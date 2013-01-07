//
//  JiveStream.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveStream.h"
#import "JiveResourceEntry.h"

@implementation JiveStream

@synthesize jiveId, name, person, published, receiveEmails, resources, source, type, updated;

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
    
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:receiveEmails forKey:@"receiveEmails"];
    if (source)
        [dictionary setValue:source forKey:@"source"];
    else if (name)
        [dictionary setValue:@"custom" forKey:@"source"];
    
    return dictionary;
}

@end
