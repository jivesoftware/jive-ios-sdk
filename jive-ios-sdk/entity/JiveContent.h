//
//  JiveContent.h
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

#import "JiveObject.h"
#import "JivePerson.h"
#import "JiveContentBody.h"
#import "JiveSummary.h"

@interface JiveContent : JiveObject

// Author of this content object.
@property(nonatomic, strong) JivePerson* author;

// Content of this content object.
@property(nonatomic, strong) JiveContentBody* content;

// Number of people following this object.
@property(nonatomic, readonly) NSNumber *followerCount;

// Highlight snippet of a search match in the body or description.
@property(nonatomic, readonly, copy) NSString* highlightBody;

// Highlight snippet of a search match in the subject or name.
@property(nonatomic, readonly, copy) NSString* highlightSubject;

// Highlight snippet of a search match in tags.
@property(nonatomic, readonly, copy) NSString* highlightTags;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, copy) NSString* jiveId;

// Number of people who have liked this object.
@property(nonatomic, readonly) NSNumber *likeCount;

// URI of the parent place of this content object. When visibility is place then the URI points to a place (and is required on create). Otherwise, this field is not part of the returned JSON (and must not be included on create).
@property(nonatomic, copy) NSString* parent;

// Summary information about the content object that is the parent of this object.
@property(nonatomic, readonly, strong) JiveSummary* parentContent;

// Summary information about the place that contains this object.
@property(nonatomic, readonly, strong) JiveSummary* parentPlace;

// Date and time when this content object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

// Number of replies to this object.
@property(nonatomic, readonly) NSNumber *replyCount;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

// Published status of this content object.
// * incomplete - Content object is in draft mode
// * pending_approval - Content object is waiting for approval
// * rejected - Content object has been rejected for publication by an approver
// * published - Content object has been published
@property(nonatomic, readonly, copy) NSString* status;

// Subject of this content object.
@property(nonatomic, copy) NSString* subject;

// The object type of this object. This field is required when creating new content.
@property(nonatomic, copy) NSString* type;

// Date and time this content object was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

// Number of times this content object has been viewed.
@property(nonatomic, readonly) NSNumber *viewCount;

@end
