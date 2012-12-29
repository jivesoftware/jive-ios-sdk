//
//  JivePoll.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePoll.h"

@implementation JivePoll

@synthesize categories, options, tags, visibility, visibleToExternalContributors, voteCount, votes;

- (id)init {
    if ((self = [super init])) {
        self.type = @"poll";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:voteCount forKey:@"voteCount"];
    [dictionary setValue:visibility forKey:@"visibility"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (categories)
        [dictionary setValue:categories forKey:@"categories"];
    
    if (options)
        [dictionary setValue:options forKey:@"options"];
    
    if (votes)
        [dictionary setValue:votes forKey:@"votes"];
    
    return dictionary;
}

@end
