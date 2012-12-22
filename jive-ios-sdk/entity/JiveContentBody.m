//
//  JiveContentBody.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContentBody.h"

@implementation JiveContentBody

@synthesize text, type;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:type forKey:@"type"];
    
    return dictionary;
}

@end
