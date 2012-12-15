//
//  JiveInboxOptions.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveInboxOptions.h"

@implementation JiveInboxOptions

- (NSString *)createOrAppend:(NSString *)nextFilter toFilter:(NSString *)filter {
    if (!filter)
        return nextFilter;
    
    return [filter stringByAppendingString:nextFilter];
}

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (!self.unread && !self.authorID && !self.authorURL && !self.types)
        return query;
    
    NSString *filter = self.unread ? [NSMutableString stringWithFormat:@"filter=unread&"] : @"";
    
    if (self.authorID)
        filter = [filter stringByAppendingFormat:@"filter=author(/people/%@)&", self.authorID];
    else if (self.authorURL)
        filter = [filter stringByAppendingFormat:@"filter=author(%@)&", self.authorURL];
    
    if (self.types)
        filter = [filter stringByAppendingFormat:@"filter=type(%@)&", [self.types componentsJoinedByString:@","]];
    
    filter = [filter substringToIndex:[filter length] - 1];
    return query ? [query stringByAppendingFormat:@"&%@", filter] : filter;
}

- (void)addType:(NSString *)type {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:type];
    else
        self.types = [self.types arrayByAddingObject:type];
}

@end
