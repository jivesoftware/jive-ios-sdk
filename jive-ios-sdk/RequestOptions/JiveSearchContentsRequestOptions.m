//
//  JiveSearchContentsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchContentsRequestOptions.h"

@implementation JiveSearchContentsRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];
    
    if (self.subjectOnly) {
        if (filter)
            filter = [filter stringByAppendingString:@",subjectonly"];
        else
            filter = @"subjectonly";
    }
    
    if (self.authorID) {
        if (filter)
            filter = [filter stringByAppendingFormat:@",author(/people/%@)", self.authorID];
        else
            filter = [NSString stringWithFormat:@"author(/people/%@)", self.authorID];
    }
    else if (self.authorURL) {
        if (filter)
            filter = [filter stringByAppendingFormat:@",author(%@)", self.authorURL];
        else
            filter = [NSString stringWithFormat:@"author(%@)", self.authorURL];
    }
    
    if (self.moreLikeContentID) {
        if (filter)
            filter = [filter stringByAppendingFormat:@",morelike(/content/%@)", self.moreLikeContentID];
        else
            filter = [NSString stringWithFormat:@"morelike(/content/%@)", self.moreLikeContentID];
    }
    
    if (self.places) {
        NSString *placesFilter = [self.places componentsJoinedByString:@","];

        if (filter)
            filter = [filter stringByAppendingFormat:@",place(%@)", placesFilter];
        else
            filter = [NSString stringWithFormat:@"place(%@)", placesFilter];
    }
    
    return filter;
}

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (self.after) {
        if (queryString)
            queryString = [queryString stringByAppendingFormat:@"&after=%@", self.after];
        else
            queryString = [NSString stringWithFormat:@"after=%@", self.after];
    }
    
    if (self.before) {
        if (queryString)
            queryString = [queryString stringByAppendingFormat:@"&before=%@", self.before];
        else
            queryString = [NSString stringWithFormat:@"before=%@", self.before];
    }
    
    return queryString;
}

- (void)addPlaceID:(NSString *)place {
    
    NSString *partialURL = [NSString stringWithFormat:@"/places/%@", place];
    
    if (!self.places)
        self.places = [NSArray arrayWithObject:partialURL];
    else
        self.places = [self.places arrayByAddingObject:partialURL];
}

- (void)addPlaceURL:(NSURL *)place {
    
    if (!self.places)
        self.places = [NSArray arrayWithObject:place];
    else
        self.places = [self.places arrayByAddingObject:place];
}

@end
