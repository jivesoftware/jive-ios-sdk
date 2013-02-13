//
//  JiveSortedRequestOptions.h
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

#import "JivePagedRequestOptions.h"

// Not all sort order values are valid for all calls. Check the call documentation.
enum JiveSortOrder {

    JiveSortOrderDefault,   // Use the default sort order.
    JiveSortOrderDateCreatedDesc,       // Sort by the date this content object was created, in descending order.
    JiveSortOrderDateCreatedAsc,        // Sort by the date this content object was created, in ascending order
    JiveSortOrderLatestActivityDesc,    // Sort by the date this content object had the most recent activity, in descending order
    JiveSortOrderLatestActivityAsc,     // Sort by the date this content object had the most recent activity, in ascending order
    JiveSortOrderTitleAsc,              // Sort by content object subject, in ascending order
    JiveSortOrderFirstNameAsc,          // Sort by first name in ascending order
    JiveSortOrderLastNameAsc,           // Sort by last name in ascending order
    JiveSortOrderDateJoinedDesc,        // Sort by joined date in ascending order
    JiveSortOrderDateJoinedAsc,         // Sort by joined date in descending order
    JiveSortOrderStatusLevelDesc,       // Sort by status level in descending order
    JiveSortOrderRelevanceDesc,         // Sort by relevance, in descending order.
    JiveSortOrderUpdatedAsc,            // Sort by the date this content object was most recently updated, in ascending order.
    JiveSortOrderUpdatedDesc,           // Sort by the date this content object was most recently updated, in descending order.
};

@interface JiveSortedRequestOptions : JivePagedRequestOptions

@property (nonatomic) enum JiveSortOrder sort;

@end
