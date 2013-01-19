//
//  JiveSearchContentsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchContentsRequestOptions.h"
#import "JiveSearchRequestOptions_internal.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JiveSearchContentsRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    
    if (self.subjectOnly)
        [filter addObject:@"subjectonly"];
    
    if (self.authorID)
        [filter addObject:[NSString stringWithFormat:@"author(/people/%@)", self.authorID]];
    else if (self.authorURL)
        [filter addObject:[NSString stringWithFormat:@"author(%@)", self.authorURL]];
    
    if (self.moreLikeContentID)
        [filter addObject:[NSString stringWithFormat:@"morelike(/content/%@)", self.moreLikeContentID]];
    
    if (self.places) {
        NSString *placesFilter = [self.places componentsJoinedByString:@","];

        [filter addObject:[NSString stringWithFormat:@"place(%@)", placesFilter]];
    }
    
    return filter;
}

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    if (self.after) {
        NSString *formattedAfter = [dateFormatter stringFromDate:self.after];
        
        if (queryString)
            queryString = [queryString stringByAppendingFormat:@"&after=%@", formattedAfter];
        else
            queryString = [NSString stringWithFormat:@"after=%@", formattedAfter];
    }
    
    if (self.before) {
        NSString *formattedBefore = [dateFormatter stringFromDate:self.before];
        
        if (queryString)
            queryString = [queryString stringByAppendingFormat:@"&before=%@", formattedBefore];
        else
            queryString = [NSString stringWithFormat:@"before=%@", formattedBefore];
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
