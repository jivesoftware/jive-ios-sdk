//
//  JiveSpace.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSpace.h"

@implementation JiveSpace

@synthesize childCount, tags;

- (id)init {
    if ((self = [super init])) {
        self.type = @"space";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:childCount forKey:@"childCount"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    return dictionary;
}

@end
