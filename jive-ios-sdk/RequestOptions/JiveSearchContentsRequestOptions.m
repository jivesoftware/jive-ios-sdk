//
//  JiveSearchContentsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
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
