//
//  JiveStateRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveStateRequestOptions.h"

@implementation JiveStateRequestOptions

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (self.states)
    {
        NSString *statesString = [self.states componentsJoinedByString:@","];

        if (query)
            query = [query stringByAppendingFormat:@"&state=%@", statesString];
        else
            query = [NSString stringWithFormat:@"state=%@", statesString];
    }

    return query;
}

- (void)addState:(NSString *)state {
    
    if (!self.states)
        self.states = [NSArray arrayWithObject:state];
    else
        self.states = [self.states arrayByAddingObject:state];
}

@end
