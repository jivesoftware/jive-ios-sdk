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

    jiveDefaultSortOrder,   // Use the default sort order.
    dateCreatedDesc,        // Sort by the date this content object was created, in descending order.
    dateCreatedAsc,         // Sort by the date this content object was created, in ascending order
    latestActivityDesc,     // Sort by the date this content object had the most recent activity, in descending order
    latestActivityAsc,      // Sort by the date this content object had the most recent activity, in ascending order
    titleAsc,               // Sort by content object subject, in ascending order
    firstNameAsc,           // Sort by first name in ascending order
    lastNameAsc,            // Sort by last name in ascending order
    dateJoinedDesc,         // Sort by joined date in ascending order
    dateJoinedAsc,          // Sort by joined date in descending order
    statusLevelDesc,        // Sort by status level in descending order
};

@interface JiveSortedRequestOptions : JivePagedRequestOptions

@property (nonatomic) enum JiveSortOrder sort;

@end
