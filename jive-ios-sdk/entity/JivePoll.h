//
//  JivePoll.h
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

//! \class JivePoll
//! https://developers.jivesoftware.com/api/v3/rest/PollEntity.html
@interface JivePoll : JiveContent

//! Categories associated with this object. Places define the list of possible categories. String[]
@property(nonatomic, strong) NSArray* categories;

//! The options available to be voted on for this poll. String[]
@property(nonatomic, strong) NSArray* options;

//! Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

//! The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * hidden - only the author can see the content.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;

//! The current number of votes on this poll.
@property(nonatomic, readonly) NSNumber *voteCount;

//! The options voted by the user making the request. String[]
@property(nonatomic, readonly, strong) NSArray* votes;

@end
