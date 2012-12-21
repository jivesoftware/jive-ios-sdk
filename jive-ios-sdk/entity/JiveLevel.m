//
//  JiveLevel.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveLevel.h"

@implementation JiveLevel

@synthesize description, name, points;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.description forKey:@"description"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.points forKey:@"points"];
    
    return dictionary;
}

@end
