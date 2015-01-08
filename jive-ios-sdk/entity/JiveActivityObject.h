//
//  JiveActivityObject.h
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
#import "JivePersonJive.h"


extern struct JiveActivityObjectAttributes {
    __unsafe_unretained NSString *answer;
    __unsafe_unretained NSString *author;
    __unsafe_unretained NSString *canComment;
    __unsafe_unretained NSString *canReply;
    __unsafe_unretained NSString *content;
    __unsafe_unretained NSString *contentImages;
    __unsafe_unretained NSString *contentVideos;
    __unsafe_unretained NSString *displayName;
    __unsafe_unretained NSString *helpfulCount;
    __unsafe_unretained NSString *image;
    __unsafe_unretained NSString *jive;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *objectType;
    __unsafe_unretained NSString *published;
    __unsafe_unretained NSString *question;
    __unsafe_unretained NSString *resolved;
    __unsafe_unretained NSString *summary;
    __unsafe_unretained NSString *updated;
    __unsafe_unretained NSString *url;
} const JiveActivityObjectAttributes;


@class JiveMediaLink;

//! \class JiveActivityObject
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/ActivityObjectEntity.html
@interface JiveActivityObject : JiveObject

//! The person (or other entity) that created or authored this object.
@property(nonatomic, readonly, strong) JiveActivityObject *author;

//! Natural language description of this object (may contain HTML markup).
@property(nonatomic, copy) NSString* content;

//! Image data for embedded images. JiveImage[]
@property(nonatomic, readonly, strong) NSArray *contentImages;

//! Video data for embedded videos. JiveContentVideo[]
@property(nonatomic, readonly, strong) NSArray *contentVideos;

//Natural language, human readable, and plain text name of this object.
@property(nonatomic, copy) NSString* displayName;

//Permanent and universally unique identifier for this object. For standard Jive objects (those for which the objectType field starts with "jive:"), this will be an IRI that resolves to the Jive Core API endpoint to retrieve this particular object.
@property(nonatomic, copy) NSString* jiveId;

//! Description of a resource providing a visual representation of this object, intended for human consumption
@property(nonatomic, readonly, strong) JiveMediaLink* image;

@property(nonatomic, readonly, strong) JivePersonJive *jive;

//! The type of this object. Standard Jive objects will all have a prefix of jive:.
@property(nonatomic, copy) NSString* objectType;

//! Date and time when this object was initally published.
@property(nonatomic, readonly, strong) NSDate* published;

//! Natural language summarization of this object, which may contain HTML markup.
@property(nonatomic, copy) NSString* summary;

//! Date and time at which a previously published object was modified.
@property(nonatomic, readonly, strong) NSDate* updated;

//! URI identifying a resource that provides an HTML representation of the object.
@property(nonatomic, readonly, strong) NSURL* url;

//! Flag indicating that this discussion is marked as a question, if object is a discussion.
@property (nonatomic) NSNumber *question;

//! If the object field contains a discussion marked as a question, this field will contain the resolution state ("open", "resolved", or "assumed_resolved").
@property (nonatomic) NSString *resolved;

//! URI of the correct answer (if any), if this object is a discussion marked as a question.
@property (nonatomic) NSURL *answer;

//! Flag indicating that this content can be replied to
@property (nonatomic, readonly) NSNumber *canReply;

//! Flag indicating that this content can be commented on
@property (nonatomic, readonly) NSNumber *canComment;

//! Helpful count NSNumber
@property(nonatomic, readonly, strong) NSNumber *helpfulCount;

@end
