//
//  JiveNotSoGeneralObject.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObjectMetadata.h"
#import "JiveField.h"
#import "JiveResource.h"

@implementation JiveObjectMetadata

@synthesize associatable, availability, commentable, content, description, example, fields, name;
@synthesize place, plural, resourceLinks, since;

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:@"fields"]) {
        return [JiveField class];
    }
    
    if ([propertyName isEqualToString:@"resourceLinks"]) {
        return [JiveResource class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:associatable forKey:@"associatable"];
    [dictionary setValue:availability forKey:@"availability"];
    [dictionary setValue:commentable forKey:@"commentable"];
    [dictionary setValue:content forKey:@"content"];
    [dictionary setValue:description forKey:@"description"];
    [dictionary setValue:example forKey:@"example"];
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:place forKey:@"place"];
    [dictionary setValue:plural forKey:@"plural"];
    [dictionary setValue:since forKey:@"since"];
    
    if (fields)
        [self addArrayElements:fields toJSONDictionary:dictionary forTag:@"fields"];
    
    if (resourceLinks)
        [self addArrayElements:resourceLinks toJSONDictionary:dictionary forTag:@"resourceLinks"];
    
    return dictionary;
}

@end
