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
#import "JiveGenericPerson.h"


@class JiveActivityObject;
@class JiveVia;

extern struct JiveExtensionAttributes {
    __unsafe_unretained NSString *answer;
    __unsafe_unretained NSString *canComment;
    __unsafe_unretained NSString *canLike;
    __unsafe_unretained NSString *canReply;
    __unsafe_unretained NSString *collection;
    __unsafe_unretained NSString *collectionRead;
    __unsafe_unretained NSString *collectionUpdated;
    __unsafe_unretained NSString *display;
    __unsafe_unretained NSString *discovery;
    __unsafe_unretained NSString *followingInStream;
    __unsafe_unretained NSString *iconCss;
    __unsafe_unretained NSString *imagesCount;
    __unsafe_unretained NSString *likeCount;
    __unsafe_unretained NSString *liked;
    __unsafe_unretained NSString *mentioned;
    __unsafe_unretained NSString *objectID;
    __unsafe_unretained NSString *objectType;
    __unsafe_unretained NSString *objectViewed;
    __unsafe_unretained NSString *onBehalfOf;
    __unsafe_unretained NSString *outcomeComment;
    __unsafe_unretained NSString *outcomeTypeName;
    __unsafe_unretained NSString *parent;
    __unsafe_unretained NSString *parentActor;
    __unsafe_unretained NSString *parentLikeCount;
    __unsafe_unretained NSString *parentLiked;
    __unsafe_unretained NSString *parentOnBehalfOf;
    __unsafe_unretained NSString *parentReplyCount;
    __unsafe_unretained NSString *productIcon;
    __unsafe_unretained NSString *question;
    __unsafe_unretained NSString *read;
    __unsafe_unretained NSString *replyCount;
    __unsafe_unretained NSString *resolved;
    __unsafe_unretained NSString *state;
    __unsafe_unretained NSString *update;
    __unsafe_unretained NSString *updateCollection;
    __unsafe_unretained NSString *via;
} const JiveExtensionAttributes;

extern struct JiveExtensionDisplay {
    __unsafe_unretained NSString *digest;
    __unsafe_unretained NSString *grouped;
    __unsafe_unretained NSString *update;
} const JiveExtensionDisplay;

extern struct JiveExtensionStateValues {
    __unsafe_unretained NSString *awaitingAction;
    __unsafe_unretained NSString *accepted;
    __unsafe_unretained NSString *rejected;
    __unsafe_unretained NSString *ignored;
    __unsafe_unretained NSString *hidden;
} const JiveExtensionStateValues;


//! \class JiveExtension
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/JiveExtensionEntity.html
@interface JiveExtension : JiveObject

//! URI of the correct answer (if any), if this object is a discussion marked as a question. Availability: Only present if the object field contains a discussion marked as a question, with a message marked as the correct answer
@property(nonatomic, readonly, strong) NSURL *answer;

//! Flag indicating that this content can be commented on
@property(nonatomic, readonly, strong) NSNumber *canComment;
- (BOOL)commentAllowed;

//! Flag indicating whether the requesting user can like this object.
@property(nonatomic, readonly, strong) NSNumber *canLike;
- (BOOL)likeAllowed;

//! Flag indicating whether the requesting user can reply to this object.
@property(nonatomic, readonly, strong) NSNumber *canReply;
- (BOOL)replyAllowed;

//! Identifier that groups several activities around the same topic. Activities within such a collection are ordered newest to oldest by activity date.
@property(nonatomic, readonly, strong) NSString* collection;

//! Boolean indicating if the Acclaim collection is read or unread. Availability: Only present if the containing activity appears in the inbox as Acclaim, e.g. an activity with a verb field of "jive:liked".
@property(nonatomic, readonly, strong) NSNumber *collectionRead;
- (BOOL)isCollectionRead;

//! Date of latest activity of the identifier that groups several activities.
@property(nonatomic, readonly, strong) NSDate* collectionUpdated;

//! Value describing the grouping style to be applied to this activity stream entry. Valid values are
//! update - Each activity is presented as a separate update (default value)
//! grouped - Activities are grouped by common generator (i.e. which app created this) and verb
//! digest - Specialized format (Jive internal use only)
@property(nonatomic, copy) NSString* display;

//! Flag indicating whether the requesting user is following the content object in the stream that was requested.
@property(nonatomic, readonly, strong) NSNumber *followingInStream;
- (BOOL)isFollowingInStream;

//! CSS Style to locate icon within sprite.
@property(nonatomic, readonly, strong) NSString *iconCss;

//! Number of people who have liked this object.
@property(nonatomic, readonly, strong) NSNumber *likeCount;

//! Flag indicating whether the requesting user has liked this object.
@property(nonatomic, readonly, strong) NSNumber *liked;
- (BOOL)isLiked;

//! The object that was actually mentioned (typically a Person or a Place). Availability: Only present when this activity stream entry or inbox entry represents a mention (i.e. the verb field contains "jive.mentioned").
@property(nonatomic, readonly, strong) JiveActivityObject *mentioned;

//! Jive Object ID
@property(nonatomic, readonly, strong) NSNumber *objectID;

//! Jive Object Type
@property(nonatomic, readonly, strong) NSNumber *objectType;

//! Information that is available when the message or external stream entry was posted by the author on behalf of another person. This person may be an anonymous user, an unknown user with just an email address or another user of Jive.
@property(nonatomic, strong) JiveGenericPerson *onBehalfOf;

//! If this activity stream or inbox entry represents setting a Structured Outcome, this field contains the associated comment (if any).
@property(nonatomic, readonly, strong) NSString *outcomeComment;

//! If this activity stream or inbox entry represents setting a Structured Outcome, this field contains the type name of the outcome type that was set.
@property(nonatomic, readonly, strong) NSString *outcomeTypeName;

//! Parent content object for this comment or message. Availability: Only present on Jive creation activities related to comments or messages.
@property(nonatomic, readonly, strong) JiveActivityObject* parent;

//! Actor who created the parent content object for this comment or message. Availability: Only present on Jive creation activities related to comments or messages
@property(nonatomic, readonly, strong) JiveActivityObject *parentActor;

//! The like count of the parent item. You should only see "parentLikeCount" on a message (i.e. reply to a discussion) or a comment (i.e. a comment on some commentable parent object).
@property(nonatomic, readonly, strong) NSNumber *parentLikeCount;

//! Flag indicating whether the requesting user has liked the parent content object for this comment or message. Availability: Only present on Jive creation activities related to comments or messages
@property(nonatomic, readonly, strong) NSNumber *parentLiked;
- (BOOL)isParentLiked;

//! Information that is available when the message or external stream entry was posted by the author on behalf of another person. This person may be an anonymous user, an unknown user with just an email address or another user of Jive.
@property(nonatomic, strong) JiveGenericPerson *parentOnBehalfOf;

//! Number of replies to the parent content object for this comment or message. Availability: Only preseent on Jive creation activities related to comments or messages
@property(nonatomic, readonly, strong) NSNumber *parentReplyCount;

//! Flag indicating that this discussion is marked as a question, if object is a discussion.
@property(nonatomic, readonly, strong) NSNumber *question;
- (BOOL)isQuestion;

//! Flag indicating the inbox entry corresponding to this activity has been read. Availability: Only present on activities that correspond to inbox entries
@property(nonatomic, readonly, strong) NSNumber *read;
- (BOOL)isRead;

//! The number of comments on or replies to the Jive object represented by the "object" field of the containing activity. Availability: Only present for supported content types, e.g. direct messages, updates, blog posts, and discussions.
@property(nonatomic, readonly, strong) NSNumber *replyCount;

//! If the object field contains a discussion marked as a question, this field will contain the resolution state ("open", "resolved", or "assumed_resolved").
@property(nonatomic, readonly, strong) NSString *resolved;

//! Flag indicating the current state of an action. Valid values are:
//! awaiting_action
//! accepted
//! rejected
//! ignored
//! hidden
//! Only present on activities that correspond to actions, when accessed via GET /actions (REST) or osapi.jive.corev3.actions.get() (JavaScript)
@property(nonatomic, copy) NSString* state;

//! URI to update the read/unread state of the content object associated with this inbox entry. If the read field value is true, send a DELETE to this URI to mark it as unread. If the read field value is false, send a POST to this URI to mark it as read. Only present on activities that correspond to inbox entries
@property(nonatomic, readonly, strong) NSURL* update;

//! URI of the REST endpoint to mark the acclaim inbox entry as read or unread. Availability: Only present if the containing activity appears in the inbox as Acclaim, e.g. an activity with a verb field of "jive:liked".
@property(nonatomic, readonly, strong) NSURL *updateCollection;

//! Information that is available when the message or external stream entry was posted via an external system.
@property(nonatomic, strong) JiveVia *via;

//! If applicable, the location of the product icon for this object
@property(nonatomic, readonly, strong) NSURL *productIcon;

//! The number of images in a status update.
@property(nonatomic, readonly, strong) NSNumber *imagesCount;

@property(nonatomic, readonly, strong) NSArray *discovery;

//! The has the content been viewed by this user.
@property(nonatomic, readonly, strong) NSNumber *objectViewed;
- (BOOL)hasBeenViewed;

@end
