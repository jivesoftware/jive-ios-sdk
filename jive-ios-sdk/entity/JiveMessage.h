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

#import "JiveContent.h"

//! \class JiveMessage
//! https://developers.jivesoftware.com/api/v3/rest/MessageEntity.html
@interface JiveMessage : JiveContent

//! Flag indicating that this message contains the correct answer to the question posed in this discussion.
@property(nonatomic, strong) NSNumber *answer;

//! List of attachments to this message (if any).
@property(nonatomic, strong) NSArray* attachments;

//! URI of the discussion that this message belongs to.
@property(nonatomic, readonly, copy) NSString* discussion;

//! Flag indicating that this message contains a helpful answer to the question posed in this discussion.
@property(nonatomic, strong) NSNumber *helpful;

//! Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, readonly) NSNumber *visibleToExternalContributors;


@end
