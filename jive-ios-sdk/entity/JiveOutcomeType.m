//
//  JiveOutcomeType.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveOutcomeType.h"

struct JiveOutcomeTypeAttributes const JiveOutcomeTypeAttributes = {
	.fields = @"fields",
	.jiveId = @"jiveId",
	.name = @"name",
	.resources = @"resources"
};

@implementation JiveOutcomeType

@synthesize fields, jiveId, name, resources;

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:jiveId forKey:@"id"];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    [dictionary setValue:[fields copy] forKey:JiveOutcomeTypeAttributes.fields];
    [dictionary setValue:name forKey:JiveOutcomeTypeAttributes.name];
    [dictionary setValue:[resources copy] forKey:JiveOutcomeTypeAttributes.resources];
    
    return dictionary;
}

@end
