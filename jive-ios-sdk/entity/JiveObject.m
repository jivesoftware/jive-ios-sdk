//
//  JiveObject.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

#import <objc/runtime.h>
#import "NSThread+JiveISO8601DateFormatter.h"

@implementation JiveObject

// Do not synthesize extraFieldsDetected so it will not be auto populated.

+ (id) instanceFromJSON:(NSDictionary*) JSON {
    id entity = [[[self entityClass:JSON] alloc] init];
    return [entity deserialize:JSON] ? entity : nil;
}

+ (NSArray*) instancesFromJSONList:(NSArray*) JSON {
    NSMutableArray *instances = [[NSMutableArray alloc] init];
    for(id obj in JSON) {
        id inst = [[self entityClass:obj] instanceFromJSON:obj];
        if(inst) {
            [instances addObject:inst];
        } else {
            return nil;
        }
    }
    return [NSArray arrayWithArray:instances];
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

- (BOOL) deserialize:(id) JSON {
    BOOL validResponse = NO;
    
    for(NSString* key in JSON) {
        Class cls = [self lookupPropertyClass:key];
        if(cls) {
            id property = [self getObjectOfType:cls forProperty:key FromJSON:[JSON objectForKey:key]];
            [self setValue:property forKey:key];
            validResponse = YES;
        } else {
            Ivar ivar = [self lookupPropertyIvar:key];
            
            if (ivar) {
                [self handlePrimitiveProperty:key fromJSON:[JSON objectForKey:key]];
            } else {
                NSLog(@"Extra field - %@", key);
               _extraFieldsDetected = YES;
            }
        }
    }
    
    return validResponse;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    
    // Convert id property to jiveId for all Jive entities
    if([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"jiveId"];
    }
}

- (id) getObjectOfType:(Class) cls forProperty:(NSString*) property FromJSON:(id) JSON {
    
    if(cls == [NSNumber class] && [JSON isKindOfClass:[NSNumber class]]) {
        return [JSON copy];
    }
    
    if(cls == [NSString class] && [JSON isKindOfClass:[NSString class]]) {
        return [[NSString alloc] initWithString:JSON];
    }
    
    if(cls == [NSDate class] && [JSON isKindOfClass:[NSString class]]) {
        return [[NSThread currentThread].jive_ISO8601DateFormatter dateFromString:JSON];
    }
    
    if(cls == [NSURL class] && [JSON isKindOfClass:[NSString class]]) {
        return [[NSURL alloc] initWithString:JSON];
    }
    
    if(cls == [NSArray class] && [JSON isKindOfClass:[NSArray class]]) {
        // lookup the class this array is populated with, the default is NSString
        // TODO check if this is valid, using subcls to send a static message
        Class subcls = [self arrayMappingFor:property];
        if (subcls) {
            return [subcls instancesFromJSONList:JSON];
        } else {
            // should be an array of strings if not mapped to an entity
            if ([JSON count] > 0 && ![[JSON objectAtIndex:0] isKindOfClass:[NSString class]]) {
                NSLog(@"Warning: Encountered an array, '%@', which is not strings and is not mapped to an entity type.", property);
            }
            return JSON;
        }
    }
    
    id obj = [[cls alloc] init];

    if([JSON isKindOfClass:[NSDictionary class]]) {
        
         for(NSString* key in JSON) {
            
             if([obj respondsToSelector:@selector(lookupPropertyClass:)]) {
                
                Class cls = [obj lookupPropertyClass:key];
                
                // Set property to new instance of cls or a primitive
                id property = (cls) ? [self getObjectOfType:cls forProperty:key FromJSON:[JSON objectForKey:key]] :[JSON objectForKey:key];
                
                [obj setValue:property forKey:key];
             
             } else {
                 NSLog(@"Warning: Unable to deserialize types of %@. This is not yet supported.", cls);
             }
         }
        
    } else {
        // We don't yet handle lists for example
        NSLog(@"Warning: Unable to process JSON types of %@. This is not yet supported.", [JSON class]);
    }
    
    return obj;
}

- (Class) lookupPropertyClass:(NSString*) propertyName {
    
    if(![propertyName isKindOfClass:[NSString class]])
        return nil;
    
    Ivar ivar = [self lookupPropertyIvar:propertyName];
    if (!ivar && [propertyName isEqual:@"id"])
        ivar = class_getInstanceVariable([self class], "jiveId");

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




@end
