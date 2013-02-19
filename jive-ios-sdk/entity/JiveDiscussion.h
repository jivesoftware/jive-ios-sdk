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

#import "JiveContent.h"

//! \class JiveDiscussion
//! https://developers.jivesoftware.com/api/v3/rest/DiscussionEntity.html
@interface JiveDiscussion : JiveContent

//! Categories associated with this object. Places define the list of possible categories. Strings
@property(nonatomic, strong) NSArray* categories;

//! Flag indicating that this discussion is a question.
@property(nonatomic, strong) NSNumber *question;

//! Tags associated with this object. String[]
@property(nonatomic, readonly, strong) NSArray* tags;

//! The list of users that can see the content. On create or update, provide a list of Person URIs or Person entities. On get, returns a list of Person entities. This value is used only when visibility is people. String[] or Person[]
@property(nonatomic, readonly, strong) NSArray* users;

//! The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;


@end
