//
//  JiveContentSearchParams.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/12/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
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

