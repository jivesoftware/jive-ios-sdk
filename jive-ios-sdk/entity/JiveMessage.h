//
//  JiveMessage.h
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

#import "JiveStructuredOutcomeContent.h"
#import "JiveSupportsAttachments.h"


@class JiveVia;
@class JiveGenericPerson;


extern struct JiveMessageAttributes {
    __unsafe_unretained NSString *answer;
    __unsafe_unretained NSString *attachments;
    __unsafe_unretained NSString *discussion;
    __unsafe_unretained NSString *fromQuest;
    __unsafe_unretained NSString *helpful;
    __unsafe_unretained NSString *onBehalfOf;
    __unsafe_unretained NSString *via;
    
    // Deprecated attribute names. Please use the JiveStructuredOutcomeContentAttribute names.
    __unsafe_unretained NSString *outcomeTypeNames;
    __unsafe_unretained NSString *outcomeTypes;
    
    // Deprecated attribute names. Please use the JiveContentAttribute names.
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveMessageAttributes;


extern NSString * const JiveMessageType;


//! \class JiveMessage
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/MessageEntity.html
@interface JiveMessage : JiveStructuredOutcomeContent <JiveSupportsAttachments>

//! Flag indicating that this message contains the correct answer to the question posed in this discussion.
@property(nonatomic, strong) NSNumber *answer;
- (BOOL)correctAnswer;

//! List of attachments to this message (if any). JiveAttachment[]
@property(nonatomic, strong) NSArray* attachments;

//! URI of the discussion that this message belongs to.
@property(nonatomic, readonly, copy) NSString* discussion;

//! Flag indicating that this document was created as part of a quest.
@property(nonatomic, strong) NSString *fromQuest;

//! Flag indicating that this message contains a helpful answer to the question posed in this discussion.
@property(nonatomic, strong) NSNumber *helpful;
- (BOOL)isHelpful;

//! Information that is available when the message was posted by the author on behalf of another person. This person may be an anonymous user, an unknown user with just an email address or another user of Jive.
@property(nonatomic, strong) JiveGenericPerson *onBehalfOf;

//! Information that is available when the message was posted via an external system.
@property(nonatomic, strong) JiveVia *via;


- (NSURL *)correctAnswerRef;
- (BOOL)canMarkAsCorrectAnswer;
- (BOOL)canClearMarkAsCorrectAnswer;
- (NSURL *)helpfulAnswerRef;
- (BOOL)canMarkAsHelpfulAnswer;
- (BOOL)canClearMarkAsHelpfulAnswer;

@end
