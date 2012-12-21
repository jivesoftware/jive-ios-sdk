//
//  JiveAddress.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAddress.h"

@implementation JiveAddress

@synthesize jive_label, value, type, primary;

- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)propertyValue {
    if ([property isEqualToString:@"primary"])
        primary = CFBooleanGetValue((__bridge CFBooleanRef)(propertyValue));
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.jive_label forKey:@"jive_label"];
    [dictionary setValue:self.value forKey:@"value"];
    [dictionary setValue:self.type forKey:@"type"];
    
    if (primary)
        [dictionary setValue:(__bridge id)kCFBooleanTrue forKey:@"primary"];
    
    return dictionary;
}

@end
