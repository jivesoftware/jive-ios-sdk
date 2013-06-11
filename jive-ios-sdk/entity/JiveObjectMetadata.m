//
//  JiveNotSoGeneralObject.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JiveObjectMetadata.h"
#import "JiveField.h"
#import "JiveResource.h"
#import "JiveObject_internal.h"

@implementation JiveObjectMetadata

@synthesize associatable, availability, commentable, content, jiveDescription, example, fields, name;
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
    [dictionary setValue:jiveDescription forKey:@"description"];
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
