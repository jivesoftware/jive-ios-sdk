//
//  JiveVideo.h
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/20/13.
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

extern struct JiveVideoAttributes {
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
    __unsafe_unretained NSString *visibleToExternalContributors;
    __unsafe_unretained NSString *externalID;
    __unsafe_unretained NSString *playerBaseURL;
    __unsafe_unretained NSString *width;
    __unsafe_unretained NSString *height;
    __unsafe_unretained NSString *authtoken;
    __unsafe_unretained NSString *videoSource;
} const JiveVideoAttributes;


extern NSString * const JiveVideoType;

//! \class JiveVideo
//! https://developers.jivesoftware.com/api/v3/rest/VideoEntity.html
@interface JiveVideo : JiveContent

//! Categories associated with this object. Places define the list of possible categories. String[]
@property(nonatomic, strong) NSArray* categories;

//! Tags associated with this object.
@property(nonatomic, strong) NSArray* tags;

//! The list of users that can see the content. On create or update, provide a list of Person URIs or Person entities. On get, returns a list of Person entities. This value is used only when visibility is people. String[] or Person[]
@property(nonatomic, strong) NSArray* users;

//! The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * hidden - only the author can see the content.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, readonly, strong) NSNumber *visibleToExternalContributors;

//! Video provider's ID
@property(nonatomic, strong, readonly) NSString* externalID;

//! URL of video service
@property(nonatomic, strong, readonly) NSURL* playerBaseURL;

//! Video height
@property(nonatomic, readonly) NSNumber* height;

//! Video width
@property(nonatomic, readonly) NSNumber* width;

//! Video provider's authentication token, required for playing video
@property(nonatomic, strong, readonly) NSString* authtoken;

//! HTML source for an external link to video (e.g. YouTube, Vimeo)
@property(nonatomic, strong, readonly) NSString* videoSource;

@end
