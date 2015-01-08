//
//  JiveCategorizedContent.m
//  
//
//  Created by Orson Bushnell on 11/19/14.
//
//

#import "JiveCategorizedContent.h"
#import "JiveTypedObject_internal.h"


struct JiveCategorizedContentAttributes const JiveCategorizedContentAttributes = {
    .categories = @"categories",
    .extendedAuthors = @"extendedAuthors",
    .users = @"users",
    .visibility = @"visibility",
};


@implementation JiveCategorizedContent

@synthesize categories, extendedAuthors, users, visibility;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:visibility forKey:JiveCategorizedContentAttributes.visibility];
    [self addArrayElements:extendedAuthors
          toJSONDictionary:dictionary
                    forTag:JiveCategorizedContentAttributes.extendedAuthors];
    
    if (users.count > 0 && [[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]])
        [dictionary setValue:users forKey:JiveCategorizedContentAttributes.users];
    else
        [self addArrayElements:users
              toJSONDictionary:dictionary
                        forTag:JiveCategorizedContentAttributes.users];
    
    if (categories)
        [dictionary setValue:categories forKey:JiveCategorizedContentAttributes.categories];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [self addArrayElements:extendedAuthors
    toPersistentDictionary:dictionary
                    forTag:JiveCategorizedContentAttributes.extendedAuthors];
    if (users.count > 0 && ![[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]])
        [self addArrayElements:users
        toPersistentDictionary:dictionary
                        forTag:JiveCategorizedContentAttributes.users];
    
    return dictionary;
}

- (Class)arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveCategorizedContentAttributes.extendedAuthors]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (id)parseArrayNamed:(NSString *)propertyName fromJSON:(id)JSON jiveInstance:(Jive *)jiveInstance {
    if (![propertyName isEqualToString:JiveCategorizedContentAttributes.users]) {
        return [super parseArrayNamed:propertyName fromJSON:JSON jiveInstance:jiveInstance];
    }
    
    if ([JSON count] > 0 && ![[JSON[0] class] isSubclassOfClass:[NSString class]]) {
        return [JivePerson objectsFromJSONList:JSON withInstance:jiveInstance];
    }
    
    return JSON;
}

@end
