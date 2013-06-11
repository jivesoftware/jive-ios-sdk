//
//  JiveProperty.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveProperty.h"

@implementation JiveProperty

@synthesize availability, defaultValue, jiveDescription, name, since, type, value;

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:availability forKey:@"availability"];
    [dictionary setValue:defaultValue forKey:@"defaultValue"];
    [dictionary setValue:jiveDescription forKey:@"description"];
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:since forKey:@"since"];
    [dictionary setValue:type forKey:@"type"];
    [dictionary setValue:value forKey:@"value"];
    
    return dictionary;
}

@end
