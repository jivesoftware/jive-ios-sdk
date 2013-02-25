//
//  JiveTypedObject.m
//  
//
//  Created by Orson Bushnell on 2/25/13.
//
//

#import "JiveTypedObject_internal.h"

@implementation JiveTypedObject

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
    NSString* type = [obj objectForKey:@"type"];
    if (!type)
        return [self class];
    
    return [[typedClasses objectsForKeys:[NSArray arrayWithObject:type]
                          notFoundMarker:[self class]] objectAtIndex:0];
}

@end
