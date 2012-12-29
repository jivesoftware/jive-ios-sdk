//
//  JiveAnnouncement.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveAnnouncement : JiveContent

// The date and time after which this announcement should no longer be displayed. If no end date is specified during creation then it will default to a week since publish date.
@property(nonatomic, strong) NSDate* endDate;

// The display URL for the image associated with this Announcement. May be null for announcements that don't have an image.
@property(nonatomic, copy) NSURL* image;

// The date and time after which the announcement should start being displayed. If no publish date is specified during creation then it will default to now.
@property(nonatomic, strong) NSDate* publishDate;

// An integer. When several unexpired announcements are displayed, they'll be ordered by descending sortKey.
@property(nonatomic, strong) NSNumber* sortKey;

// The URI that the subject should link to when displayed. May be null.
@property(nonatomic, copy) NSString* subjectURI;

// The entity type that the subjectURI property links to. Null if the link target is external, unknown to the CoreObjectTypeProvider, or if subjectURI is null.
@property(nonatomic, readonly, copy) NSString* subjectURITargetType;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;

@end
