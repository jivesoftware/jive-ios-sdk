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

#import "JiveCategorizedContent.h"
#import "JiveImage.h"


extern struct JivePollAttributes {
    __unsafe_unretained NSString *options;
    __unsafe_unretained NSString *voteCount;
    __unsafe_unretained NSString *votes;
    __unsafe_unretained NSString *optionsImages;
    
    // Deprecated attribute names. Please use the JiveCategorizedContentAttributes names.
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
} const JivePollAttributes;


extern NSString * const JivePollType;


//! \class JivePoll
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/PollEntity.html
@interface JivePoll : JiveCategorizedContent

//! The options available to be voted on for this poll. String[]
@property(nonatomic, strong) NSArray* options;

//! The current number of votes on this poll.
@property(nonatomic, readonly) NSNumber *voteCount;

//! The options voted by the user making the request. String[]
@property(nonatomic, readonly, strong) NSArray* votes;

//! The images associated with the poll options. @{option : JiveImage} where option is a value from options[]
@property(nonatomic, strong) NSDictionary* optionsImages;

//! Whether the user making the request can vote on this poll
-(BOOL)canVote;

//! Whether the user making the request has voted on this poll
-(BOOL)hasVoted;

@end
