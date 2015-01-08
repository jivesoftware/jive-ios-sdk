//
//  JiveStream.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
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

#import "JiveStream_internal.h"
#import "JiveTypedObject_internal.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"


struct JiveStreamResourceTags const JiveStreamResourceTags = {
    .activity = @"activity",
    .associations = @"associations",
    .html = @"html"
};

struct JiveStreamAttributes const JiveStreamAttributes = {
    .name = @"name",
    .person = @"person",
    .published = @"published",
    .receiveEmails = @"receiveEmails",
    .count = @"count",
    .updatesNew = @"updatesNew",
    .updatesPrevious = @"updatesPrevious",
    .source = @"source",
    .updated = @"updated"
};

struct JiveStreamSourceValues const JiveStreamSourceValues = {
    .all = @"all",
    .communications = @"communications",
    .connections = @"connections",
    .context = @"context",
    .profile = @"profile",
    .watches = @"watches",
    .custom = @"custom"
};

struct JiveStreamJSONAttributes const JiveStreamJSONAttributes = {
    .newUpdates = @"newUpdates",
    .previousUpdates = @"previousUpdates"
};

@implementation JiveStream

@synthesize jiveId, name, person, published, receiveEmails, source, updated, count, updatesNew;
@synthesize updatesPrevious;

- (NSString *)type {
    return @"stream";
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    // prepend "jive" to Objective-C keywords and basic properties/methods
    if([key isEqualToString:JiveStreamJSONAttributes.newUpdates]) {
        [self setValue:value forKey:JiveStreamAttributes.updatesNew];
    } else if ([key isEqualToString:JiveStreamJSONAttributes.previousUpdates]) {
        [self setValue:value forKey:JiveStreamAttributes.updatesPrevious];
    } else {
        [super setValue:value forUndefinedKey:key];
    }
}

- (Class) lookupPropertyClass:(NSString*) propertyName {
    
    Class propertyClass = [super lookupPropertyClass:propertyName];
    
    if (!propertyClass) {
        Ivar ivar = nil;
        
        if ([JiveStreamJSONAttributes.newUpdates isEqualToString:propertyName]) {
            ivar = class_getInstanceVariable([self class],
                                             [JiveStreamAttributes.updatesNew cStringUsingEncoding:NSUTF8StringEncoding]);
        } else if ([JiveStreamJSONAttributes.previousUpdates isEqualToString:propertyName]) {
            ivar = class_getInstanceVariable([self class],
                                             [JiveStreamAttributes.updatesPrevious cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        
        propertyClass = [self lookupClassTypeFromIvar:ivar];
    }
    
    return propertyClass;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:name forKey:JiveStreamAttributes.name];
    [dictionary setValue:receiveEmails forKey:JiveStreamAttributes.receiveEmails];
    if (source)
        [dictionary setValue:source forKey:JiveStreamAttributes.source];
    else if (name)
        [dictionary setValue:JiveStreamSourceValues.custom forKey:JiveStreamAttributes.source];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:count forKey:JiveStreamAttributes.count];
    [dictionary setValue:self.type forKey:JiveTypedObjectAttributes.type];
    [dictionary setValue:jiveId forKey:JiveObjectConstants.id];
    if (person)
        [dictionary setValue:[person persistentJSON] forKey:JiveStreamAttributes.person];
    
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:JiveStreamAttributes.published];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:JiveStreamAttributes.updated];
    
    if (self.updatesNew)
        [dictionary setValue:[dateFormatter stringFromDate:self.updatesNew]
                      forKey:JiveStreamJSONAttributes.newUpdates];
    
    if (self.updatesPrevious)
        [dictionary setValue:[dateFormatter stringFromDate:self.updatesPrevious]
                      forKey:JiveStreamJSONAttributes.previousUpdates];
    
    return dictionary;
}

- (NSURL *)activityRef {
    return [self resourceForTag:JiveStreamResourceTags.activity].ref;
}

- (NSURL *)associationsRef {
    return [self resourceForTag:JiveStreamResourceTags.associations].ref;
}

- (BOOL)canAddAssociation {
    return [self resourceHasPostForTag:JiveStreamResourceTags.associations];
}

- (BOOL)canDeleteAssociation {
    return [self resourceHasDeleteForTag:JiveStreamResourceTags.associations];
}

- (NSURL *)htmlRef {
    return [self resourceForTag:JiveStreamResourceTags.html].ref;
}

@end
