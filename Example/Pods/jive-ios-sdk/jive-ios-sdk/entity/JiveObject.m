//
//  JiveObject.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

#define JIVE_JSON_DEBUG 0

#import "JiveObject_internal.h"
#import "Jive_internal.h"

#import <objc/runtime.h>
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

struct JiveObjectAttributes const JiveObjectAttributes = {
	.extraFieldsDetected = @"extraFieldsDetected",
	.refreshDate = @"refreshDate",
};

@implementation JiveObject

// Do not synthesize extraFieldsDetected so it will not be auto populated.

+ (id) instanceFromJSON:(NSDictionary*) JSON {
    return [self objectFromJSON:JSON withInstance:nil];
}

+ (id) instanceFromJSON:(NSDictionary*) JSON withJive:(Jive *)jive {
    return [self objectFromJSON:JSON withInstance:jive];
}

+ (NSArray*) instancesFromJSONList:(NSArray*) JSON withJive:(Jive *)jive {
    return [self objectsFromJSONList:JSON withInstance:jive];
}

+ (NSArray*) instancesFromJSONList:(NSArray*) JSON {
    return [self objectsFromJSONList:JSON withInstance:nil];
}

+ (id) objectFromJSON:(NSDictionary *)JSON withInstance:(Jive *)instance {
    id entity = [[self entityClass:JSON] new];
    return [entity deserialize:JSON fromInstance:instance] ? entity : nil;
}

+ (NSArray*) objectsFromJSONList:(NSArray *)JSON withInstance:(Jive *)instance {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:JSON.count];
    for(id objectJSON in JSON) {
        id entity = [[self entityClass:objectJSON] objectFromJSON:objectJSON withInstance:instance];
        if(entity) {
            [items addObject:entity];
        }
    }
    return [NSArray arrayWithArray:items];
}

+ (Class) entityClass:(NSDictionary*) obj {
    return [self class];
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    return nil;
}

- (Ivar) lookupPropertyIvar:(NSString*) propertyName {
    
    if(![propertyName isKindOfClass:[NSString class]])
        return nil;
    
    return class_getInstanceVariable([self class], [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)value {
    
}

- (BOOL)deserializeKey:(NSString *)key fromJSON:(id)JSON fromInstance:(Jive *)jiveInstance {
    Class cls = [self lookupPropertyClass:key];
    if(cls) {
        id property = [self getObjectOfType:cls
                                forProperty:key
                                   fromJSON:[JSON objectForKey:key]
                               fromInstance:jiveInstance];
        [self setValue:property forKey:key];
        return YES;
    }
    
    Ivar ivar = [self lookupPropertyIvar:key];
    
    if (ivar) {
        [self handlePrimitiveProperty:key fromJSON:[JSON objectForKey:key]];
    } else {
#if JIVE_JSON_DEBUG
        NSLog(@"Extra field - %@", key);
#endif
        _extraFieldsDetected = YES;
    }
    
    return NO;
}

- (BOOL) deserialize:(id)JSON fromInstance:(Jive *)jiveInstance {
    BOOL validResponse = NO;
    
    for(NSString* key in JSON) {
        if ([self deserializeKey:key fromJSON:JSON fromInstance:jiveInstance])
            validResponse = YES;
    }
    
    if (validResponse) {
        [self setValue:[NSDate date] forKey:JiveObjectAttributes.refreshDate];
    }
    
    return validResponse;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    // prepend "jive" to Objective-C keywords and basic properties/methods
    if([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"jiveId"];
    } else if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"jiveDescription"];
    }
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property
                                     fromJSON:(id)JSON
                                 fromInstance:(Jive *)jiveInstance {
#if JIVE_JSON_DEBUG
    NSLog(@"Warning: NSDictionary not parsed.");
    NSLog(@"%@", JSON);
    NSLog(@"Figure it out.");
#endif
    return nil;
}

- (id)parseArrayNamed:(NSString *)propertyName fromJSON:(id)JSON jiveInstance:(Jive *)jiveInstance
{
    // lookup the class this array is populated with, the default is NSString
    // TODO check if this is valid, using subcls to send a static message
    Class subcls = [self arrayMappingFor:propertyName];
    if (subcls) {
        return [subcls objectsFromJSONList:JSON withInstance:jiveInstance];
    } else {
#if JIVE_JSON_DEBUG
        // should be an array of strings if not mapped to an entity
        if ([JSON count] > 0 && ![[JSON objectAtIndex:0] isKindOfClass:[NSString class]]) {
            NSLog(@"Warning: Encountered an array, '%@', which is not strings and is not mapped to an entity type.",
                  propertyName);
        }
#endif
        return JSON;
    }
}

- (id) getObjectOfType:(Class) clazz
           forProperty:(NSString*) propertyName
              fromJSON:(id) JSON
          fromInstance:(Jive *)jiveInstance {
    
    if(clazz == [NSNumber class] && [JSON isKindOfClass:[NSNumber class]]) {
        return [JSON copy];
    }
    
    if(clazz == [NSString class] && [JSON isKindOfClass:[NSString class]]) {
        return (jiveInstance ?
                [jiveInstance createStringWithInstanceURLValidation:JSON] :
                [NSString stringWithString:JSON]);
    }
    
    if(clazz == [NSDate class] && [JSON isKindOfClass:[NSString class]]) {
        return [[NSDateFormatter jive_threadLocalISO8601DateFormatter] dateFromString:JSON];
    }
    
    if(clazz == [NSURL class] && [JSON isKindOfClass:[NSString class]]) {
        return (jiveInstance ?
                [jiveInstance createURLWithInstanceValidation:JSON] :
                [NSURL URLWithString:JSON]);
    }
    
    if(clazz == [NSArray class] && [JSON isKindOfClass:[NSArray class]]) {
        return [self parseArrayNamed:propertyName fromJSON:JSON jiveInstance:jiveInstance];
    }
    
    id obj;
    
    if ([clazz isSubclassOfClass:[JiveObject class]]) {
        obj = [[clazz entityClass:JSON] new];
    } else {
        obj = [clazz new];
    }
    
    if([JSON isKindOfClass:[NSDictionary class]]) {
        
        if([obj respondsToSelector:@selector(lookupPropertyClass:)]) {
            
            for(NSString* key in JSON) {
                
                Class propertyClass = [obj lookupPropertyClass:key];
                id property = [JSON objectForKey:key];
                
                if (propertyClass) {
                    // Set property to new instance of cls
                    property = [obj getObjectOfType:propertyClass
                                        forProperty:key
                                           fromJSON:property
                                       fromInstance:jiveInstance];
                }
                
                [obj setValue:property forKey:key];
            }
            
        } else if ([clazz isSubclassOfClass:[NSDictionary class]]) {
            obj = [self parseDictionaryForProperty:propertyName
                                          fromJSON:JSON
                                      fromInstance:jiveInstance];
        } else {
#if JIVE_JSON_DEBUG
            NSLog(@"Warning: Unable to deserialize types of %@. This is not yet supported.", clazz);
#endif
        }
        
    } else {
#if JIVE_JSON_DEBUG
        // We don't yet handle lists for example
        NSLog(@"Warning: Unable to process JSON types of %@. This is not yet supported.", [JSON class]);
#endif
    }
    
    return obj;
}

- (Class) lookupPropertyClass:(NSString*) propertyName {
    
    if(![propertyName isKindOfClass:[NSString class]])
        return nil;
    
    Ivar ivar = [self lookupPropertyIvar:propertyName];
    if (!ivar) {
        if ([propertyName isEqualToString:@"id"]) {
            ivar = class_getInstanceVariable([self class], "jiveId");
        } else if ([propertyName isEqualToString:@"description"]) {
            ivar = class_getInstanceVariable([self class], "jiveDescription");
        }
    }
    
    return [self lookupClassTypeFromIvar:ivar];
}

- (Class) lookupClassTypeFromIvar:(Ivar) ivar {
    
    if(!ivar) {
        return nil;
    }
    
    const char* typeCStr = ivar_getTypeEncoding(ivar);
    
    NSString* type = [NSString stringWithCString:typeCStr encoding:NSUTF8StringEncoding];
    
    if([type length] > 0 && [type length] <= 3) {
        // Probably a primitive
        return nil;
    }
    
    // Clean up leading '@"' and trailing '"' that will make NSClassFromString fail
    type = [type substringWithRange:NSMakeRange(2, [type length]-3)];
    
    return NSClassFromString(type);
    
}

- (NSDictionary *)toJSONDictionary {
    return [NSMutableDictionary dictionary];
}

- (void)addArrayElements:(NSArray *)array toJSONDictionary:(NSMutableDictionary *)dictionary forTag:(NSString *)tag {
    if (array.count > 0) {
        NSMutableArray *JSONArray = [NSMutableArray arrayWithCapacity:array.count];
        
        for (JiveObject *object in array)
            [JSONArray addObject:object.toJSONDictionary];
        
        [dictionary setValue:[NSArray arrayWithArray:JSONArray] forKey:tag];
    }
}

- (id)persistentJSON {
    return [self toJSONDictionary];
}

- (void)addArrayElements:(NSArray *)array
  toPersistentDictionary:(NSMutableDictionary *)dictionary
                  forTag:(NSString *)tag {
    
    if (array.count > 0) {
        NSMutableArray *JSONArray = [NSMutableArray arrayWithCapacity:array.count];
        
        for (JiveObject *object in array)
            [JSONArray addObject:object.persistentJSON];
        
        [dictionary setValue:[NSArray arrayWithArray:JSONArray] forKey:tag];
    }
}

@end
