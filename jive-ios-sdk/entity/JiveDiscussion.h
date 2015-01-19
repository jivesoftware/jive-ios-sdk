//
//  JiveDiscusson.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JiveCategorizedContent.h"
#import "JiveSupportsAttachments.h"

@class JiveGenericPerson;
@class JiveVia;


extern struct JiveDiscussionAttributes {
    __unsafe_unretained NSString *answer;
    __unsafe_unretained NSString *attachments;
    __unsafe_unretained NSString *helpful;
    __unsafe_unretained NSString *onBehalfOf;
    __unsafe_unretained NSString *question;
    __unsafe_unretained NSString *resolved;
    __unsafe_unretained NSString *restrictReplies;
    __unsafe_unretained NSString *via;
    
    // Deprecated attribute names. Please use the JiveCategorizedContentAttributes names.
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
    
    // Deprecated attribute names. Please use the JiveContentAttribute names.
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveDiscussionAttributes;

extern struct JiveDiscussionResolvedState {
    __unsafe_unretained NSString *open;
    __unsafe_unretained NSString *resolved;
    __unsafe_unretained NSString *assumed_resolved;
} const JiveDiscussionResolvedState;


extern NSString * const JiveDiscussionType;


//! \class JiveDiscussion
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/DiscussionEntity.html
@interface JiveDiscussion : JiveCategorizedContent <JiveSupportsAttachments>

//! URI of the correct answer (if any) to this discussion, if it is a question.
@property(nonatomic, strong) NSString *answer;

//! List of attachments to this message (if any). JiveAttachment[]
@property(nonatomic, strong) NSArray* attachments;

//! NSString URIs of messages that have been marked "helpful", if this discussion is a question. String[]
@property(nonatomic, strong) NSArray *helpful;

//! Information that is available when the discussion was posted by the author on behalf of another person. This person may be an anonymous user, an unknown user with just an email address or another user of Jive.
@property(nonatomic, strong) JiveGenericPerson *onBehalfOf;

//! Flag indicating that this discussion is a question.
@property(nonatomic, strong) NSNumber *question;
- (BOOL)isAQuestion;

//! If this discussion is a question, this field will contain the resolution state ("open", "resolved", "assumed_resolved"). If the current state is "open", it may be changed to "assumed_resolved" by the author or a moderator. Availability: Only present on a discussion marked as a question
@property(nonatomic, copy) NSString *resolved;

//! Flag indicating that old messages replying to this discussion will be visible, but new messages (or changes to the structured outcome settings on messages) will not be allowed.
@property(nonatomic, readonly, strong) NSNumber *restrictReplies;
- (BOOL)repliesRestricted;

//! Information that is available when the discussion was posted via an external system.
@property(nonatomic, strong) JiveVia *via;

@end
