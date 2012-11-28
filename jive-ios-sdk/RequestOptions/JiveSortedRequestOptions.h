//
//  JiveSortedRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptions.h"

enum JiveSortOrder {

    dateCreatedDesc,    // Sort by the date this content object was created, in descending order. Default if none was specified.
    dateCreatedAsc,     // Sort by the date this content object was created, in ascending order
    latestActivityDesc, // Sort by the date this content object had the most recent activity, in descending order
    latestActivityAsc,  // Sort by the date this content object had the most recent activity, in ascending order
    titleAsc,           // Sort by content object subject, in ascending order
};

@interface JiveSortedRequestOptions : JivePagedRequestOptions

@property (nonatomic) enum JiveSortOrder sort;

@end
