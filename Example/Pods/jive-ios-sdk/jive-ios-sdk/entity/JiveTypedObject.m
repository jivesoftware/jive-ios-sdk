//
//  JiveTypedObject.m
//  
//
//  Created by Orson Bushnell on 2/25/13.
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

#import "JiveTypedObject_internal.h"
#import "JiveResourceEntry.h"
#import "JiveObjcRuntime.h"

struct JiveTypedObjectResourceAllowed {
    __unsafe_unretained NSString *get;
    __unsafe_unretained NSString *put;
    __unsafe_unretained NSString *post;
    __unsafe_unretained NSString *delete;
};

struct JiveTypedObjectAttributes const JiveTypedObjectAttributes = {
	.type = @"type",
};

struct JiveTypedObjectAttributesHidden const JiveTypedObjectAttributesHidden = {
	.resources = @"resources"
};

struct JiveTypedObjectResourceTags const JiveTypedObjectResourceTags = {
    .selfResourceTag = @"self"
};

struct JiveTypedObjectResourceAllowed const JiveTypedObjectResourceAllowed = {
    .get = @"GET",
    .put = @"PUT",
    .post = @"POST",
    .delete = @"DELETE"
};

@implementation JiveTypedObject

@synthesize resources;

static NSMutableDictionary *typedClasses;

+ (void)registerClass:(Class)clazz forType:(NSString *)type {
    if (!typedClasses)
        typedClasses = [NSMutableDictionary dictionary];
    
    [typedClasses setValue:clazz forKey:type];
}

- (NSString *)type {
    return nil;
}

+ (Class) entityClass:(NSDictionary*) obj {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *subclasses = JiveClassGetSubclasses(self);
        // guarantees that +[Subclass initialize] is called
        [subclasses makeObjectsPerformSelector:@selector(self)];
    });
    
    NSString* type = [obj objectForKey:@"type"];
    if (!type)
        return [self class];
    
    return [[typedClasses objectsForKeys:[NSArray arrayWithObject:type]
                          notFoundMarker:[self class]] objectAtIndex:0];
}

+ (id) objectFromJSON:(NSDictionary *)JSON withInstance:(Jive *)instance {
    id resources = JSON[JiveTypedObjectAttributesHidden.resources];
    
    if (resources) {
        id resource = resources[JiveTypedObjectResourceTags.selfResourceTag];
        
        if (resource) {
            // Initalize the instance with the correct badInstanctURL if there is one.
            [JiveResourceEntry objectFromJSON:resource withInstance:instance];
        }
    }
    
    return [super objectFromJSON:JSON withInstance:instance];
}

- (BOOL)deserializeKey:(NSString *)key fromJSON:(id)JSON fromInstance:(Jive *)jiveInstance {
    if ([JiveTypedObjectAttributes.type isEqualToString:key])
        return NO; // Having a type does not make this a valid JSON response.
    
    return [super deserializeKey:key fromJSON:JSON fromInstance:jiveInstance];
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property
                                     fromJSON:(id)JSON
                                 fromInstance:(Jive *)instance {
    if ([JiveTypedObjectAttributesHidden.resources isEqualToString:property]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
        
        for (NSString *key in JSON) {
            JiveResourceEntry *entry = [JiveResourceEntry objectFromJSON:[JSON objectForKey:key]
                                                              withInstance:instance];
            
            [dictionary setValue:entry forKey:key];
        }
        
        return dictionary.count > 0 ? [NSDictionary dictionaryWithDictionary:dictionary] : nil;
    }
    
    return nil;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    if (resources.count > 0) {
        NSMutableDictionary *resourcesJSON = [NSMutableDictionary dictionaryWithCapacity:resources.count];
        
        for (NSString *key in resources.allKeys) {
            resourcesJSON[key] = [[resources valueForKey:key] persistentJSON];
        }
    
        dictionary[JiveTypedObjectAttributesHidden.resources] = resourcesJSON;
    }
    
    return dictionary;
}

- (JiveResourceEntry *)resourceForTag:(NSString *)tag {
    return self.resources[tag];
}

- (BOOL)resourceHasDeleteForTag:(NSString *)tag {
    return [[self resourceForTag:tag].allowed containsObject:JiveTypedObjectResourceAllowed.delete];
}

- (BOOL)resourceHasGetForTag:(NSString *)tag {
    return [[self resourceForTag:tag].allowed containsObject:JiveTypedObjectResourceAllowed.get];
}

- (BOOL)resourceHasPutForTag:(NSString *)tag {
    return [[self resourceForTag:tag].allowed containsObject:JiveTypedObjectResourceAllowed.put];
}

- (BOOL)resourceHasPostForTag:(NSString *)tag {
    return [[self resourceForTag:tag].allowed containsObject:JiveTypedObjectResourceAllowed.post];
}

- (NSURL *)selfRef {
    return [self resourceForTag:JiveTypedObjectResourceTags.selfResourceTag].ref;
}

- (BOOL)canDelete {
    return [self resourceHasDeleteForTag:JiveTypedObjectResourceTags.selfResourceTag];
}

- (BOOL)isUpdateable {
    return [self resourceHasPutForTag:JiveTypedObjectResourceTags.selfResourceTag];
}

@end
