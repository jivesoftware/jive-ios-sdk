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


struct JiveObjectMetadataAttributes const JiveObjectMetadataAttributes = {
    .associatable = @"associatable",
    .availability = @"availability",
    .commentable = @"commentable",
    .content = @"content",
    .example = @"example",
    .fields = @"fields",
    .name = @"name",
    .objectType = @"objectType",
    .outcomeTypes = @"outcomeTypes",
    .place = @"place",
    .plural = @"plural",
    .resourceLinks = @"resourceLinks",
    .since = @"since"
};


@implementation JiveObjectMetadata

@synthesize associatable, availability, commentable, content, jiveDescription, example, fields, name;
@synthesize place, plural, resourceLinks, since;

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveObjectMetadataAttributes.fields]) {
        return [JiveField class];
    }
    
    if ([propertyName isEqualToString:JiveObjectMetadataAttributes.resourceLinks]) {
        return [JiveResource class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:associatable forKey:JiveObjectMetadataAttributes.associatable];
    [dictionary setValue:availability forKey:JiveObjectMetadataAttributes.availability];
    [dictionary setValue:commentable forKey:JiveObjectMetadataAttributes.commentable];
    [dictionary setValue:content forKey:JiveObjectMetadataAttributes.content];
    [dictionary setValue:jiveDescription forKey:JiveObjectConstants.description];
    [dictionary setValue:example forKey:JiveObjectMetadataAttributes.example];
    [dictionary setValue:name forKey:JiveObjectMetadataAttributes.name];
    [dictionary setValue:place forKey:JiveObjectMetadataAttributes.place];
    [dictionary setValue:plural forKey:JiveObjectMetadataAttributes.plural];
    [dictionary setValue:since forKey:JiveObjectMetadataAttributes.since];
    
    if (fields)
        [self addArrayElements:fields
        toPersistentDictionary:dictionary
                        forTag:JiveObjectMetadataAttributes.fields];
    
    if (resourceLinks)
        [self addArrayElements:resourceLinks
        toPersistentDictionary:dictionary
                        forTag:JiveObjectMetadataAttributes.resourceLinks];
    
    return dictionary;
}

- (BOOL)isAssociatable {
    return [associatable boolValue];
}

- (BOOL)isCommentable {
    return [commentable boolValue];
}

- (BOOL)isContent {
    return [content boolValue];
}

- (BOOL)isAPlace {
    return [place boolValue];
}

@end
