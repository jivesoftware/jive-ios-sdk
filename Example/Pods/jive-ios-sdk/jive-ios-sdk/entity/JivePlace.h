//
//  JivePlace.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
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

#import "JiveTypedObject.h"

extern struct JivePlaceAttributes {
    __unsafe_unretained NSString *contentTypes;
    __unsafe_unretained NSString *jiveDescription;
    __unsafe_unretained NSString *displayName;
    __unsafe_unretained NSString *followerCount;
    __unsafe_unretained NSString *highlightBody;
    __unsafe_unretained NSString *highlightSubject;
    __unsafe_unretained NSString *highlightTags;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *likeCount;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *parent;
    __unsafe_unretained NSString *parentContent;
    __unsafe_unretained NSString *parentPlace;
    __unsafe_unretained NSString *published;
    __unsafe_unretained NSString *status;
    __unsafe_unretained NSString *updated;
    __unsafe_unretained NSString *viewCount;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JivePlaceAttributes;

extern struct JivePlaceContentTypeValues {
    __unsafe_unretained NSString *documents;
    __unsafe_unretained NSString *discussions;
    __unsafe_unretained NSString *files;
    __unsafe_unretained NSString *polls;
    __unsafe_unretained NSString *projects;
    __unsafe_unretained NSString *tasks;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *updates;
    __unsafe_unretained NSString *events;
    __unsafe_unretained NSString *videos;
    __unsafe_unretained NSString *ideas;
} const JivePlaceContentTypeValues;


@class JiveSummary;

//! \class JivePlace
//! https://developers.jivesoftware.com/api/v3/rest/PlaceEntity.html
@interface JivePlace : JiveTypedObject

//! Blogs can only have Posts. Other content types cannot be added. String[]
@property(nonatomic, readonly, strong) NSArray* contentTypes;

//! Human readable description of this place.
@property(nonatomic, copy) NSString* jiveDescription;

//! Display name of this place. It must be unique among places of the same type in this Jive instance. This value is used to compose the URL for the HTML presentation of this place in the Jive user interface.
@property(nonatomic, copy) NSString* displayName;

//! Number of people following this object.
@property(nonatomic, readonly) NSNumber* followerCount;

//! Highlight snippet of a search match in the body or description.
@property(nonatomic, readonly, copy) NSString* highlightBody;

//! Highlight snippet of a search match in the subject or name.
@property(nonatomic, readonly, copy) NSString* highlightSubject;

//! Highlight snippet of a search match in tags.
@property(nonatomic, readonly, copy) NSString* highlightTags;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, copy) NSString* jiveId;

//! Number of people who have liked this object.
@property(nonatomic, readonly) NSNumber* likeCount;

//! Formal name of this place. It must be unique among places of the same type in this Jive instance.
@property(nonatomic, copy) NSString* name;

//! URI of the parent place of this content object. When visibility is place then the URI points to a place (and is required on create). Otherwise, this field is not part of the returned JSON (and must not be included on create).
@property(nonatomic, copy) NSString* parent;

//! Summary information about the content object that is the parent of this object.
@property(nonatomic, readonly, strong) JiveSummary* parentContent;

//! Summary information about the place that contains this object.
@property(nonatomic, readonly, strong) JiveSummary* parentPlace;

//! Date and time when this content object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

//! Published status of this content object.
// * incomplete - Content object is in draft mode
// * pending_approval - Content object is waiting for approval
// * rejected - Content object has been rejected for publication by an approver
// * published - Content object has been published
@property(nonatomic, readonly, copy) NSString* status;

//! Date and time this content object was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

//! Number of times this content object has been viewed.
@property(nonatomic, readonly) NSNumber* viewCount;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic) bool visibleToExternalContributors;

- (NSURL *)activityRef;
- (NSURL *)contentsRef;
- (NSURL *)extpropsRef;
- (BOOL)canAddExtProps;
- (BOOL)canDeleteExtProps;
- (NSURL *)featuredContentRef;
- (NSURL *)followingInRef;
- (NSURL *)htmlRef;
- (NSURL *)staticsRef;
- (BOOL)canAddStatic;

- (NSURL *)announcementsRef;
- (BOOL)canCreateAnnouncement;
- (NSURL *)avatarRef;
- (BOOL)canDeleteAvatar;
- (BOOL)canUpdateAvatar;
- (NSURL *)blogRef;
- (NSURL *)categoriesRef;
- (BOOL)canAddCategory;
- (NSURL *)invitesRef;
- (BOOL)canCreateInvite;
- (NSURL *)membersRef;
- (BOOL)canCreateMember;
- (NSURL *)childPlacesRef;

- (NSURL *)checkPointsRef;
- (BOOL)canUpdateCheckPoints;
- (NSURL *)tasksRef;
- (BOOL)canCreateTask;

- (BOOL)canCreateContent;

@end
