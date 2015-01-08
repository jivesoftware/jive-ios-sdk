//
//  JivePost.h
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


extern NSString * const JivePostType;


extern struct JivePostAttributes {
    __unsafe_unretained NSString *attachments;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *permalink;
    __unsafe_unretained NSString *publishDate;
    __unsafe_unretained NSString *restrictComments;
} const JivePostAttributes;


extern struct JivePostStatusValues {
    __unsafe_unretained NSString *incomplete; // Post is in draft mode
    __unsafe_unretained NSString *pendingApproval; // Post is waiting for approval
    __unsafe_unretained NSString *rejected; // Post has been rejected for publication by an approver;
    __unsafe_unretained NSString *scheduled; // Post has been scheduled to be published on a given date
    __unsafe_unretained NSString *published; // Post has been published
} const JivePostStatusValues DEPRECATED_ATTRIBUTE; // Use the JiveContentStatusValues


//! \class JivePost
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/PostEntity.html
@interface JivePost : JiveStructuredOutcomeContent

//! List of attachments to this message (if any). JiveAttachment[]
@property(nonatomic, strong) NSArray* attachments;

//! Categories associated with this object. Places define the list of possible categories. String[]
@property(nonatomic, strong) NSArray* categories;

//! Permanent URI for the HTML version of this post.
@property(nonatomic, readonly, copy) NSString* permalink;

//! Date and time at which this post should be made visible.
@property(nonatomic, strong) NSDate* publishDate;

//! Flag indicating that old comments will be visible but new comments are not allowed. If not restricted then anyone with appropriate permissions can comment on the content.
@property(nonatomic, strong) NSNumber *restrictComments;

@end
