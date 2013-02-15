//
//  JiveExtension.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveExtension.h"
#import "JiveActivityObject.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JiveExtension

@synthesize collection, collectionUpdated, display, parent, read, state, update, updateCollection, collectionRead;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:collection forKey:@"collection"];
    [dictionary setValue:display forKey:@"display"];
    [dictionary setValue:read forKey:@"read"];
    [dictionary setValue:[update absoluteString] forKey:@"update"];
    [dictionary setValue:[updateCollection absoluteString] forKey:@"updateCollection"];
    [dictionary setValue:state forKey:@"state"];
    if (collectionUpdated)
        [dictionary setValue:[dateFormatter stringFromDate:collectionUpdated] forKey:@"collectionUpdated"];
    
    if (parent)
        [dictionary setValue:[parent toJSONDictionary] forKey:@"parent"];
    
    return dictionary;
}

@end
