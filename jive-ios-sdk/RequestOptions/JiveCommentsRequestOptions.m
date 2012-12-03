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
    
    if (!self.anchor)
        return query;
    
    if (!query)
        return [NSString stringWithFormat:@"anchor=%@", self.anchor];
    
    return [query stringByAppendingFormat:@"&anchor=%@", self.anchor];
}

@end
