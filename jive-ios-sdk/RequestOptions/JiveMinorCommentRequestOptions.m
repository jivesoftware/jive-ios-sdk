//
//  JiveMinorCommentRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveMinorCommentRequestOptions.h"

@implementation JiveMinorCommentRequestOptions

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (!self.minor)
        return queryString;
    
    if (!queryString)
        return @"minor=true";
    
    return [queryString stringByAppendingString:@"&minor=true"];
}

@end
