//
//  JiveExtension.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

#import <Foundation/Foundation.h>
#import "JiveObject.h"
#import "JivePerson.h"

@class JiveActivityObject;

extern struct JiveExtensionAttributes {
    __unsafe_unretained NSString *collection;
    __unsafe_unretained NSString *collectionUpdated;
    __unsafe_unretained NSString *display;
    __unsafe_unretained NSString *parent;
    __unsafe_unretained NSString *read;
    __unsafe_unretained NSString *state;
    __unsafe_unretained NSString *update;
    __unsafe_unretained NSString *updateCollection;
    __unsafe_unretained NSString *collectionRead;
    __unsafe_unretained NSString *outcomeTypeName;
    __unsafe_unretained NSString *question;
    __unsafe_unretained NSString *resolved;
    __unsafe_unretained NSString *answer;
    __unsafe_unretained NSString *productIcon;
    __unsafe_unretained NSString *parentLikeCount;
    __unsafe_unretained NSString *parentReplyCount;
    __unsafe_unretained NSString *replyCount;
    __unsafe_unretained NSString *likeCount;
    __unsafe_unretained NSString *liked;
    __unsafe_unretained NSString *parentLiked;
    __unsafe_unretained NSString *parentActor;
    __unsafe_unretained NSString *canReply;
    __unsafe_unretained NSString *canComment;
} const JiveExtensionAttributes;

//! \class JiveExtension
//! https://developers.jivesoftware.com/api/v3/rest/JiveExtensionEntity.html
@interface JiveExtension : JiveObject

//! Identifier that groups several activities around the same topic. Activities within such a collection are ordered newest to oldest by activity date.
@property(nonatomic, copy) NSString* collection;


//! Date of latest activity of the identifier that groups several activities.
@property(nonatomic, readonly, strong) NSDate* collectionUpdated;

//! Value describing the grouping style to be applied to this activity stream entry. Valid values are
//! update - Each activity is presented as a separate update (default value)
//! grouped - Activities are grouped by common generator (i.e. which app created this) and verb
//! digest - Specialized format (Jive internal use only)
@property(nonatomic, copy) NSString* display;

//! Parent content object for this comment or message.
//! Only present on Jive creation activities related to comments or messages.
@property(nonatomic, readonly, strong) JiveActivityObject* parent;

//! Flag indicating the inbox entry corresponding to this activity has been read.
//! Only present on activities that correspond to inbox entries
@property(nonatomic, readonly) NSNumber *read;

//! Flag indicating the current state of an action. Valid values are:
//! awaiting_action
//! accepted
//! rejected
//! ignored
//! hidden
//! Only present on activities that correspond to actions, when accessed via GET /actions (REST) or osapi.jive.corev3.actions.get() (JavaScript)
@property(nonatomic, copy) NSString* state;

//! URI to update the read/unread state of the content object associated with this inbox entry. If the read field value is true, send a DELETE to this URI to mark it as unread. If the read field value is false, send a POST to this URI to mark it as read. Only present on activities that correspond to inbox entries
@property(nonatomic, readonly) NSURL* update;

@property(nonatomic, copy) NSURL *updateCollection;

@property(nonatomic) BOOL collectionRead;

@property (nonatomic) NSString *outcomeTypeName;

//! Flag indicating that this discussion is marked as a question, if object is a discussion.
@property (nonatomic) NSNumber *question;

//! If the object field contains a discussion marked as a question, this field will contain the resolution state ("open", "resolved", or "assumed_resolved").
@property (nonatomic) NSString *resolved;

//! URI of the correct answer (if any), if this object is a discussion marked as a question.
@property (nonatomic) NSURL *answer;

//! If applicable, the location of the product icon for this object
@property (nonatomic) NSURL *productIcon;

//! The like count of the parent item. You should only see "parentLikeCount" on a message (i.e. reply to a discussion) or a comment (i.e. a comment on some commentable parent object).
@property (nonatomic) NSNumber *parentLikeCount;

//! The reply count of the parent item, which is not necessarily the root item
@property (nonatomic) NSNumber *parentReplyCount;

//! The reply count of the item
@property (nonatomic) NSNumber *replyCount;

//! The like count of the item
@property (nonatomic) NSNumber *likeCount;

//! Flag indicating that this user has liked the content
@property (nonatomic) BOOL liked;

//! Flag indicating that this user has liked the parent/root content
@property (nonatomic) BOOL parentLiked;

//! The number of images in a status update.
@property (nonatomic, readonly) NSNumber *imagesCount;

//! Author of the parent item.
@property(nonatomic, readonly, strong) JivePerson *parentActor;

//! Flag indicating that this content can be replied to
@property(nonatomic, readonly) NSNumber *canReply;

//! Flag indicating that this content can be commented on
@property(nonatomic, readonly) NSNumber *canComment;

@end
