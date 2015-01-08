//
//  JiveIdea.h
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/25/13.
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


extern struct JiveIdeaAttributes {
    __unsafe_unretained NSString *authors;
    __unsafe_unretained NSString *authorship;
    __unsafe_unretained NSString *authorshipPolicy;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *commentCount;
    __unsafe_unretained NSString *score;
    __unsafe_unretained NSString *stage;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
    __unsafe_unretained NSString *voteCount;
    __unsafe_unretained NSString *voted;
} const JiveIdeaAttributes;

extern struct JiveIdeaAuthorshipPolicy {
    __unsafe_unretained NSString *open;
    __unsafe_unretained NSString *single;
    __unsafe_unretained NSString *multiple;
} const JiveIdeaAuthorshipPolicy;


extern NSString * const JiveIdeaType;


//! \class JiveIdea
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/IdeaEntity.html
@interface JiveIdea : JiveStructuredOutcomeContent

//! List of people who are authors on this content. Authors are allowed to edit the content. This value is used only when authorship is limited. Person[]
@property(nonatomic, strong) NSArray *authors;

//! The authorship policy for this content.
// * open - anyone with appropriate permissions can edit the content. Default when visibility is place.
// * author - only the author can edit the content. Default when visibility is hidden or all.
// * limited - only those users specified by authors can edit the content. If authors was not specified then users will be used instead when visibility is people. Default when visibility is people.
@property(nonatomic, copy) NSString *authorship;

//! Authorship policy for this idea (open, single, or multiple).
@property(nonatomic, readonly, copy) NSString *authorshipPolicy;

//! Categories associated with this object. Places define the list of possible categories. NSString[]
@property(nonatomic, strong) NSArray *categories;

//! Number of comments (included nested comments) associated with this idea.
@property(nonatomic, readonly, strong) NSNumber *commentCount;

//! Current score for this idea.
@property(nonatomic, readonly, strong) NSNumber *score;

//! Current stage for this idea.
@property (nonatomic, readonly, copy) NSString *stage;

//! The list of users that can see the content. On create or update, provide a list of Person URIs or Person entities. On get, returns a list of Person entities. This value is used only when visibility is people. String[] or Person[]
@property(nonatomic, strong) NSArray *users;

//! The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * hidden - only the author can see the content.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString *visibility;

//! Number of votes on this idea so far.
@property(nonatomic, readonly, strong) NSNumber *voteCount;

//! Flag indicating whether or not the requesting user has voted on this idea or not.
@property(nonatomic, readonly, strong) NSNumber *voted;
- (BOOL)didVote;

@end
