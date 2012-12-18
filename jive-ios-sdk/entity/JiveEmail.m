//
//  JiveEmail.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveEmail.h"

@implementation JiveEmail

@synthesize jive_label, value, type, primary;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.jive_label forKey:@"jive_label"];
    [dictionary setValue:self.value forKey:@"value"];
    [dictionary setValue:self.type forKey:@"type"];
    
    return dictionary;
}

@end
