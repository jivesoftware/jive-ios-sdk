//
//  JiveObject.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

#import <objc/runtime.h>

@implementation JiveObject

+ (id) instanceFromJSON:(NSDictionary*) JSON {
    id entity = [[[self class] alloc] init];
    return [entity deserialize:JSON] ? entity : nil;
}

+ (NSArray*) instancesFromJSONList:(NSArray*) JSON; {
    NSMutableArray *instances = [[NSMutableArray alloc] init];
    for(id obj in JSON) {
        id inst = [[self class] instanceFromJSON:obj];
        if(inst) {
            [instances addObject:inst];
        } else {
            return nil;
        }
    }
    return [NSArray arrayWithArray:instances];
}

- (NSDateFormatter*) dateFormatter {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter) {
        dateFormatter   = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"]; 
    }
    return dateFormatter;
}

- (BOOL) deserialize:(id) JSON {
    for(NSString* key in JSON) {
        Class cls = [self lookupPropertyClass:key];
        if(cls) {
            id property = [self getObjectOfType:cls FromJSON:[JSON objectForKey:key]];
            [self setValue:property forKey:key];
        } else {
            return NO;
        }
    }
    return YES;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    
    // Convert id property to jiveId for all Jive entities
    if([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"jiveId"];
    }
}

- (id) getObjectOfType:(Class) cls FromJSON:(id) JSON {
    
    if(cls == [NSString class] && [JSON isKindOfClass:[NSString class]]) {
        return [[NSString alloc] initWithString:JSON];
    }
    
    if(cls == [NSDate class] && [JSON isKindOfClass:[NSString class]]) {
        return [[self dateFormatter] dateFromString:JSON];
    }
    
    if(cls == [NSURL class] && [JSON isKindOfClass:[NSString class]]) {
        return [[NSURL alloc] initWithString:JSON];
    }
    
    id obj = [[cls alloc] init];

    if([JSON isKindOfClass:[NSDictionary class]]) {
        
         for(NSString* key in JSON) {
            
             if([obj respondsToSelector:@selector(lookupPropertyClass:)]) {
                
                Class cls = [obj lookupPropertyClass:key];
                
                // Set property to new instance of cls or a primitive
                id property = (cls) ? [self getObjectOfType:cls FromJSON:[JSON objectForKey:key]] :[JSON objectForKey:key];
                
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
    
    Ivar ivar = class_getInstanceVariable([self class], [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
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
