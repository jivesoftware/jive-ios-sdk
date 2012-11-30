//
//  JivePeopleRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePeopleRequestOptions.h"

@implementation JivePeopleRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];

    if (self.title)
        filter = [self addFilterGroup:@"title" withValue:self.title toFilter:filter];
    
    if (self.department)
        filter = [self addFilterGroup:@"department" withValue:self.department toFilter:filter];
    
    if (self.location)
        filter = [self addFilterGroup:@"location" withValue:self.location toFilter:filter];
    
    if (self.company)
        filter = [self addFilterGroup:@"company" withValue:self.company toFilter:filter];
    
    if (self.office)
        filter = [self addFilterGroup:@"office" withValue:self.office toFilter:filter];
    
    if (self.hiredAfter && self.hiredBefore && [self.hiredAfter compare:self.hiredBefore] == NSOrderedAscending)
        filter = [self addFilterGroup:@"hire-date"
                            withValue:[NSString stringWithFormat:@"%@,%@", self.hiredAfter, self.hiredBefore]
                             toFilter:filter];
    
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
