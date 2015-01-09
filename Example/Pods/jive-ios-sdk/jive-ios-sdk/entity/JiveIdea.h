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

#import "JiveAuthorableContent.h"


extern struct JiveIdeaAttributes {
    __unsafe_unretained NSString *authorshipPolicy;
    __unsafe_unretained NSString *commentCount;
    __unsafe_unretained NSString *score;
    __unsafe_unretained NSString *stage;
    __unsafe_unretained NSString *voteCount;
    __unsafe_unretained NSString *voted;
    
    // Deprecated attribute names. Please use the JiveAuthorableContentAttributes names.
    __unsafe_unretained NSString *authors;
    __unsafe_unretained NSString *authorship;
    
    // Deprecated attribute names. Please use the JiveCategorizedContentAttributes names.
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
} const JiveIdeaAttributes;

extern struct JiveIdeaAuthorshipPolicy {
    __unsafe_unretained NSString *open;
    __unsafe_unretained NSString *single;
    __unsafe_unretained NSString *multiple;
} const JiveIdeaAuthorshipPolicy;


extern NSString * const JiveIdeaType;


//! \class JiveIdea
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/IdeaEntity.html
@interface JiveIdea : JiveAuthorableContent

//! Authorship policy for this idea (open, single, or multiple).
@property(nonatomic, readonly, copy) NSString *authorshipPolicy;

//! Number of comments (included nested comments) associated with this idea.
@property(nonatomic, readonly, strong) NSNumber *commentCount;

//! Current score for this idea.
@property(nonatomic, readonly, strong) NSNumber *score;

//! Current stage for this idea.
@property (nonatomic, readonly, copy) NSString *stage;

//! Number of votes on this idea so far.
@property(nonatomic, readonly, strong) NSNumber *voteCount;

//! Flag indicating whether or not the requesting user has voted on this idea or not.
@property(nonatomic, readonly, strong) NSNumber *voted;
- (BOOL)didVote;

@end
