//
//  JivePeopleRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePeopleRequestOptions.h"
#import "NSString+JiveUTF8PercentEscape.h"
#import "NSThread+JiveISO8601DateFormatter.h"

@implementation JivePeopleRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;

    if (self.title)
        [filter addObject:[NSString stringWithFormat:@"title(%@)", [self.title jive_encodeWithUTF8PercentEscaping]]];
    
    if (self.department)
        [filter addObject:[NSString stringWithFormat:@"department(%@)", [self.department jive_encodeWithUTF8PercentEscaping]]];
    
    if (self.location)
        [filter addObject:[NSString stringWithFormat:@"location(%@)", [self.location jive_encodeWithUTF8PercentEscaping]]];
    
    if (self.company)
        [filter addObject:[NSString stringWithFormat:@"company(%@)", [self.company jive_encodeWithUTF8PercentEscaping]]];
    
    if (self.office)
        [filter addObject:[NSString stringWithFormat:@"office(%@)", [self.office jive_encodeWithUTF8PercentEscaping]]];
    
    if (self.hiredAfter && self.hiredBefore && [self.hiredAfter compare:self.hiredBefore] == NSOrderedAscending)
        [filter addObject:[NSString stringWithFormat:@"hire-date(%@,%@)",
                           [dateFormatter stringFromDate:self.hiredAfter],
                           [dateFormatter stringFromDate:self.hiredBefore]]];
    
    return filter;
}

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (self.ids) {
        NSString *idQuery = [self.ids componentsJoinedByString:@","];
        
        if (queryString)
            queryString = [queryString stringByAppendingFormat:@"&ids=%@", idQuery];
        else
            queryString = [NSString stringWithFormat:@"ids=%@", idQuery];
    }
    
    if (self.query) {
        NSString *encodedQuery = [self.query jive_encodeWithUTF8PercentEscaping];
        
        if (queryString)
            queryString = [queryString stringByAppendingFormat:@"&query=%@", encodedQuery];
        else
            queryString = [NSString stringWithFormat:@"query=%@", encodedQuery];
    }
    
    return queryString;
}

- (void)addID:(NSString *)personID {
    
    if (self.ids)
        self.ids = [self.ids arrayByAddingObject:personID];
    else
        self.ids = [NSArray arrayWithObject:personID];
}

- (void)setHireDateBetween:(NSDate *)after and:(NSDate *)before {
    _hiredAfter = [after copy];
    _hiredBefore = [before copy];
}

@end
