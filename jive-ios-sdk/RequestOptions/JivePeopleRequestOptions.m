//
//  JivePeopleRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePeopleRequestOptions.h"

@implementation JivePeopleRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];

    if (self.title)
        [filter addObject:[NSString stringWithFormat:@"title(%@)", self.title]];
    
    if (self.department)
        [filter addObject:[NSString stringWithFormat:@"department(%@)", self.department]];
    
    if (self.location)
        [filter addObject:[NSString stringWithFormat:@"location(%@)", self.location]];
    
    if (self.company)
        [filter addObject:[NSString stringWithFormat:@"company(%@)", self.company]];
    
    if (self.office)
        [filter addObject:[NSString stringWithFormat:@"office(%@)", self.office]];
    
    if (self.hiredAfter && self.hiredBefore && [self.hiredAfter compare:self.hiredBefore] == NSOrderedAscending)
        [filter addObject:[NSString stringWithFormat:@"hire-date(%@,%@)", self.hiredAfter, self.hiredBefore]];
    
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
        if (queryString)
            queryString = [queryString stringByAppendingFormat:@"&query=%@", self.query];
        else
            queryString = [NSString stringWithFormat:@"query=%@", self.query];
    }
    
    return queryString;
}

- (void)addID:(NSString *)personID {
    
    if (self.ids)
        self.ids = [self.ids arrayByAddingObject:personID];
    else
        self.ids = [NSArray arrayWithObject:personID];
}

@end
