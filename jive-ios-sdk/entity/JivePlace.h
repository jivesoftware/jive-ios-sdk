//
//  JivePlace.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@class JiveSummary;

@interface JivePlace : JiveObject

// Blogs can only have Posts. Other content types cannot be added. String[]
@property(nonatomic, readonly, strong) NSArray* contentTypes;

// Human readable description of this place.
@property(nonatomic, copy) NSString* description;

// Display name of this place. It must be unique among places of the same type in this Jive instance. This value is used to compose the URL for the HTML presentation of this place in the Jive user interface.
@property(nonatomic, copy) NSString* displayName;

// Number of people following this object.
@property(nonatomic, readonly) NSNumber* followerCount;

// Highlight snippet of a search match in the body or description.
@property(nonatomic, readonly, copy) NSString* highlightBody;

// Highlight snippet of a search match in the subject or name.
@property(nonatomic, readonly, copy) NSString* highlightSubject;

// Highlight snippet of a search match in tags.
@property(nonatomic, readonly, copy) NSString* highlightTags;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, copy) NSString* jiveId;

// Number of people who have liked this object.
@property(nonatomic, readonly) NSNumber* likeCount;

// Formal name of this place. It must be unique among places of the same type in this Jive instance.
@property(nonatomic, readonly, copy) NSString* name;

// URI of the parent place of this content object. When visibility is place then the URI points to a place (and is required on create). Otherwise, this field is not part of the returned JSON (and must not be included on create).
@property(nonatomic, copy) NSString* parent;

// Summary information about the content object that is the parent of this object.
@property(nonatomic, readonly, strong) JiveSummary* parentContent;

// Summary information about the place that contains this object.
@property(nonatomic, readonly, strong) JiveSummary* parentPlace;

// Date and time when this content object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

// Published status of this content object.
// * incomplete - Content object is in draft mode
// * pending_approval - Content object is waiting for approval
// * rejected - Content object has been rejected for publication by an approver
// * published - Content object has been published
@property(nonatomic, readonly, copy) NSString* status;

// The object type of this object. This field is required when creating new content.
@property(nonatomic, copy) NSString* type;

// Date and time this content object was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

// Number of times this content object has been viewed.
@property(nonatomic, readonly) NSNumber* viewCount;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic) bool visibleToExternalContributors;

@end
