//
//  JiveGroup.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveGroup.h"

@implementation JiveGroup

@synthesize creator, groupType, memberCount, tags;

- (id)init {
    if ((self = [super init])) {
        self.type = @"group";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:groupType forKey:@"groupType"];
    [dictionary setValue:memberCount forKey:@"memberCount"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (creator)
        [dictionary setValue:[creator toJSONDictionary] forKey:@"creator"];
    
    return dictionary;
}

@end
