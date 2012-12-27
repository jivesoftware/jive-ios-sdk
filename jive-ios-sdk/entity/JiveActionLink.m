//
//  JiveActionLink.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveActionLink.h"

@implementation JiveActionLink

@synthesize caption, httpVerb, target;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:caption forKey:@"caption"];
    [dictionary setValue:httpVerb forKey:@"httpVerb"];
    [dictionary setValue:[target absoluteString] forKey:@"target"];
    
    return dictionary;
}

@end
