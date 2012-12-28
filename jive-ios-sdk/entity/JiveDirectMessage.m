//
//  JiveDirectMessage.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDirectMessage.h"

@implementation JiveDirectMessage

@synthesize visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"dm";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    
    return dictionary;
}

@end
