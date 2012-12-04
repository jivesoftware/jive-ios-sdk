//
//  JiveAuthorCommentRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAuthorCommentRequestOptions.h"

@implementation JiveAuthorCommentRequestOptions

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (!self.author)
        return queryString;
    
    if (!queryString)
        return @"author=true";
    
    return [queryString stringByAppendingString:@"&author=true"];
}

@end
