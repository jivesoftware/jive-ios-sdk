//
//  JiveAnnouncement.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
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

#import "JiveContent.h"

//! Inbox content type for including announcements when filtering on content type.
extern NSString * const JiveAnnouncementType;

//! \class JiveAnnouncement
//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementEntity.html
@interface JiveAnnouncement : JiveContent

//! The date and time after which this announcement should no longer be displayed. If no end date is specified during creation then it will default to a week since publish date.
@property(nonatomic, strong) NSDate* endDate;

//! The display URL for the image associated with this Announcement. May be null for announcements that don't have an image.
@property(nonatomic, copy) NSURL* image;

//! The date and time after which the announcement should start being displayed. If no publish date is specified during creation then it will default to now.
@property(nonatomic, strong) NSDate* publishDate;

//! An integer. When several unexpired announcements are displayed, they'll be ordered by descending sortKey.
@property(nonatomic, strong) NSNumber* sortKey;

//! The URI that the subject should link to when displayed. May be null.
@property(nonatomic, copy) NSString* subjectURI;

//! The entity type that the subjectURI property links to. Null if the link target is external, unknown to the CoreObjectTypeProvider, or if subjectURI is null.
@property(nonatomic, readonly, copy) NSString* subjectURITargetType;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;

@end
