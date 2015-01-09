//
//  JiveNewsStream.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/26/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveNewsStream.h"
#import "JiveObject_internal.h"
#import "JiveActivity.h"


struct JiveNewsStreamAttributes const JiveNewsStreamAttributes = {
    .activities = @"activities",
    .stream = @"stream",
    .type = @"type",
};


@implementation JiveNewsStream

@synthesize activities, stream, type;

- (NSString *)type {
    return @"newsStream";
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([JiveNewsStreamAttributes.activities isEqualToString:propertyName]) {
        return [JiveActivity class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    dictionary[JiveNewsStreamAttributes.type] = self.type;
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:[self.stream persistentJSON] forKey:JiveNewsStreamAttributes.stream];
    [self addArrayElements:self.activities
    toPersistentDictionary:dictionary
                    forTag:JiveNewsStreamAttributes.activities];
    
    return dictionary;
}

@end
