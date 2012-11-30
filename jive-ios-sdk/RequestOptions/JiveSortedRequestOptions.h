//
//  JiveSortedRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptions.h"

// Not all sort order values are valid for all calls. Check the call documentation.
enum JiveSortOrder {

    JiveSortOrderDefault,   // Use the default sort order.
    JiveSortOrderDateCreatedDesc,        // Sort by the date this content object was created, in descending order.
    JiveSortOrderDateCreatedAsc,         // Sort by the date this content object was created, in ascending order
    JiveSortOrderLatestActivityDesc,     // Sort by the date this content object had the most recent activity, in descending order
    JiveSortOrderLatestActivityAsc,      // Sort by the date this content object had the most recent activity, in ascending order
    JiveSortOrderTitleAsc,               // Sort by content object subject, in ascending order
    JiveSortOrderFirstNameAsc,           // Sort by first name in ascending order
    JiveSortOrderLastNameAsc,            // Sort by last name in ascending order
    JiveSortOrderDateJoinedDesc,         // Sort by joined date in ascending order
    JiveSortOrderDateJoinedAsc,          // Sort by joined date in descending order
    JiveSortOrderStatusLevelDesc,        // Sort by status level in descending order
};

@interface JiveSortedRequestOptions : JivePagedRequestOptions

@property (nonatomic) enum JiveSortOrder sort;

@end
