//
//  JiveTypedObject.m
//  
//
//  Created by Orson Bushnell on 2/25/13.
//
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
