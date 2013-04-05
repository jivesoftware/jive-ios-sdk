//
//  JiveOutcomeType.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveOutcomeType.h"

@implementation JiveOutcomeType

@synthesize fields, jiveId, name, resources;

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:[fields copy] forKey:@"fields"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:[resources copy] forKey:@"resources"];
    
    return dictionary;
}

@end
