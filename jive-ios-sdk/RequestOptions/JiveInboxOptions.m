//
//  JiveInboxOptions.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveInboxOptions.h"

@implementation JiveInboxOptions

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (!self.unread && !self.authorID && !self.authorURL && !self.types)
        return query;
    
    NSMutableString *filter = [NSMutableString stringWithFormat:@"filter=%@", self.unread ? @"unread" : @""];
    BOOL insertComma = self.unread;
    
    if (self.authorID)
    {
        [filter appendFormat:(insertComma ? @",author(/people/%@)" : @"author(/people/%@)"), self.authorID];
        insertComma = YES;
    }
    else if (self.authorURL)
    {
        [filter appendFormat:(insertComma ? @",author(%@)" : @"author(%@)"), self.authorURL];
        insertComma = YES;
    }

    if (self.types)
        [filter appendFormat:(insertComma ? @",type(%@)" : @"type(%@)"), [self.types componentsJoinedByString:@","]];
    
    return query ? [query stringByAppendingFormat:@"&%@", filter] : filter;
}

- (void)addType:(NSString *)type {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:type];
    else
        self.types = [self.types arrayByAddingObject:type];
}

@end
