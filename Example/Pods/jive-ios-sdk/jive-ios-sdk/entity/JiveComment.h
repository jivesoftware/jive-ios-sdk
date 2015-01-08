//
//  JiveComment.h
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


extern struct JiveCommentAttributes {
    __unsafe_unretained NSString *externalID;
    __unsafe_unretained NSString *publishedCalendarDate;
    __unsafe_unretained NSString *publishedTime;
    __unsafe_unretained NSString *rootExternalID;
    __unsafe_unretained NSString *rootType;
    __unsafe_unretained NSString *rootURI;
} const JiveCommentAttributes;


extern NSString * const JiveCommentType;


//! \class JiveComment
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/CommentEntity.html
@interface JiveComment : JiveStructuredOutcomeContent

//! A string identifier, such as an Open Graph id, that can be used to identify this comment object in an external system. This property may be set when a comment is created, but cannot be changed. This field is typically used when synchronizing comment streams between Jive and some other system.
@property(nonatomic, readonly, copy) NSString *externalID;

//! Published claendar date
@property(nonatomic, readonly, strong) NSDate *publishedCalendarDate;

//! Published time
@property(nonatomic, readonly, strong) NSDate *publishedTime;

//! A string identifier, such as an Open Graph id, that can be used to identify the root content object of this comment in an external system. This field is typically used when synchronizing comment streams between Jive and some other system.
@property(nonatomic, readonly, copy) NSString *rootExternalID;

//! Object type of the root content object that this comment is a direct or indirect reply to.
@property(nonatomic, readonly, copy) NSString* rootType;

//! URI of the root content object that this comment is a direct or indirect reply to.
@property(nonatomic, readonly, copy) NSString* rootURI;


@end
