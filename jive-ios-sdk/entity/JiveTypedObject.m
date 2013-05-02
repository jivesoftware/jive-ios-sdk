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

struct JiveTypedObjectAttributes const JiveTypedObjectAttributes = {
	.type = @"type",
	.resources = @"resources"
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

- (BOOL)deserializeKey:(NSString *)key fromJSON:(id)JSON {
    if ([JiveTypedObjectAttributes.type isEqualToString:key])
        return NO; // Having a type does not make this a valid JSON response.
    
    return [super deserializeKey:key fromJSON:JSON];
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

@end
