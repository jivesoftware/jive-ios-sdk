//
//  JiveContentSearchParams.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/12/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchContentParams.h"


@implementation JiveSearchContentParams

@synthesize after, author, before, morelike, place, search, subjectonly, type, collapse, sort, startindex, count, fields;


- (NSString *) facet {
    return @"content";
}

// a list of the properties in the params class which are filters
- (NSArray *)filterParams
{
    static NSArray *filters = nil;
    if (!filters) {
        filters = [NSArray arrayWithObjects:@"after", @"author", @"before", @"morelike", @"place", @"search", @"subjectonly", @"type", nil];
    }
    return filters;
}

@end

