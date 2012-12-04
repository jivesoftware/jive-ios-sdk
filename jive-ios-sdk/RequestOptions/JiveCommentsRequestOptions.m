//
//  JiveCommentsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveCommentsRequestOptions.h"

@implementation JiveCommentsRequestOptions

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (!self.anchor && !self.excludeReplies && !self.hierarchical)
        return query;
    
    if (self.anchor) {
        if (!query)
            query = [NSString stringWithFormat:@"anchor=%@", self.anchor];
        else
            query = [query stringByAppendingFormat:@"&anchor=%@", self.anchor];
    }
    
    if (self.excludeReplies) {
        if (!query)
            query = [NSString stringWithFormat:@"excludeReplies=true"];
        else
            query = [query stringByAppendingFormat:@"&excludeReplies=true"];
    }
    
    if (self.hierarchical) {
        if (!query)
            query = [NSString stringWithFormat:@"hierarchical=true"];
        else
            query = [query stringByAppendingFormat:@"&hierarchical=true"];
    }
    
    return query;
}

@end
