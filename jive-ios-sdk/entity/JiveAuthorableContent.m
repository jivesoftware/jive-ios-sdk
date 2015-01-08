//
//  JiveAuthorableContent.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/17/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveAuthorableContent.h"
#import "JiveTypedObject_internal.h"


struct JiveAuthorableContentAttributes const JiveAuthorableContentAttributes = {
    .authors = @"authors",
    .authorship = @"authorship",
};


@implementation JiveAuthorableContent

@synthesize authors, authorship;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:authorship forKey:JiveAuthorableContentAttributes.authorship];
    [self addArrayElements:authors
          toJSONDictionary:dictionary
                    forTag:JiveAuthorableContentAttributes.authors];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [self addArrayElements:authors
    toPersistentDictionary:dictionary
                    forTag:JiveAuthorableContentAttributes.authors];
    
    return dictionary;
}

- (Class)arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveAuthorableContentAttributes.authors]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

@end
