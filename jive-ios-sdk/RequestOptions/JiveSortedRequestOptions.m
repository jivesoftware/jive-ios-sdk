//
//  JiveSortedRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
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

#import "JiveSortedRequestOptions.h"

@implementation JiveSortedRequestOptions

- (NSString *)toQueryString {
    
    static const NSString *sortStrings[] = { nil,
        @"dateCreatedDesc",
        @"dateCreatedAsc",
        @"latestActivityDesc",
        @"latestActivityAsc",
        @"titleAsc",
        @"firstNameAsc",
        @"lastNameAsc",
        @"dateJoinedDesc",
        @"dateJoinedAsc",
        @"statusLevelDesc",
        @"relevanceDesc",
        @"updatedAsc",
        @"updatedDesc",
        @"lastProfileUpdateDesc",
        @"lastProfileUpdateAsc"
   };
    int sort = self.sort;
    NSString *queryString = [super toQueryString];
    
    if (sort < JiveSortOrderDateCreatedDesc || sort > JiveSortOrderLastProfileUpdateAsc)
        return queryString;
    
    if (queryString)
        return [NSString stringWithFormat:@"%@&sort=%@", queryString, sortStrings[sort]];
    
    return [NSString stringWithFormat:@"sort=%@", sortStrings[sort]];
}

@end
