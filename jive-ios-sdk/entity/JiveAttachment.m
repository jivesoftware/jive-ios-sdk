//
//  JiveAttachment.m
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

#import "JiveAttachment.h"
#import "JiveResourceEntry.h"

struct JiveAttachmentResourceTags {
    __unsafe_unretained NSString *selfResourceTag;
} const JiveAttachmentResourceTags;

struct JiveAttachmentAttributes const JiveAttachmentAttributes = {
	.contentType = @"contentType",
	.doUpload = @"doUpload",
	.jiveId = @"jiveId",
	.name = @"name",
	.resources = @"resources",
	.size = @"size",
	.url = @"url",
};

struct JiveAttachmentResourceTags const JiveAttachmentResourceTags = {
    .selfResourceTag = @"self"
};

@implementation JiveAttachment

@synthesize contentType, doUpload, jiveId, name, resources, size, url;

+ (id) objectFromJSON:(NSDictionary *)JSON withInstance:(Jive *)instance {
    id resources = JSON[JiveAttachmentAttributes.resources];
    
    if (resources) {
        id resource = resources[JiveAttachmentResourceTags.selfResourceTag];
        
        if (resource) {
            // Initalize the instance with the correct badInstanctURL if there is one.
            [JiveResourceEntry objectFromJSON:resource withInstance:instance];
        }
    }
    
    return [super objectFromJSON:JSON withInstance:instance];
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property
                                     fromJSON:(id)JSON
                                 fromInstance:(Jive *)instance {
    if ([@"resources" isEqualToString:property]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
        
        for (NSString *key in JSON) {
            JiveResourceEntry *entry = [JiveResourceEntry objectFromJSON:[JSON objectForKey:key]
                                                              withInstance:instance];
            
            [dictionary setValue:entry forKey:key];
        }
        
        if (dictionary.count > 0)
            return [NSDictionary dictionaryWithDictionary:dictionary];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:contentType forKey:JiveAttachmentAttributes.contentType];
    [dictionary setValue:doUpload forKey:JiveAttachmentAttributes.doUpload];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:name forKey:JiveAttachmentAttributes.name];
    [dictionary setValue:size forKey:JiveAttachmentAttributes.size];
    [dictionary setValue:[url absoluteString] forKey:JiveAttachmentAttributes.url];
    
    return dictionary;
}
@end
