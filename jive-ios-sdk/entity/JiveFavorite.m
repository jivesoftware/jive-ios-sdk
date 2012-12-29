//
//  JiveFavorite.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveFavorite.h"

@implementation JiveFavorite

@synthesize favoriteObject, private, tags, visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"favorite";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:private forKey:@"private"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    return dictionary;
}

@end
