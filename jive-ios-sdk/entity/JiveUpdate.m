//
//  JiveUpdate.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveUpdate.h"

@implementation JiveUpdate

@synthesize latitude, longitude, tags, visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"update";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:latitude forKey:@"latitude"];
    [dictionary setValue:longitude forKey:@"longitude"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    return dictionary;
}

@end
