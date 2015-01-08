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

#import "JiveStructuredOutcomeContent.h"

extern struct JiveVideoAttributes {
    __unsafe_unretained NSString *authtoken;
    __unsafe_unretained NSString *autoplay;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *duration;
    __unsafe_unretained NSString *embedded;
    __unsafe_unretained NSString *externalID;
    __unsafe_unretained NSString *height;
    __unsafe_unretained NSString *hours;
    __unsafe_unretained NSString *iframeSource;
    __unsafe_unretained NSString *minutes;
    __unsafe_unretained NSString *playerBaseURL;
    __unsafe_unretained NSString *playerName;
    __unsafe_unretained NSString *seconds;
    __unsafe_unretained NSString *stillImageURL;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *videoSource;
    __unsafe_unretained NSString *videoThumbnail;
    __unsafe_unretained NSString *videoType;
    __unsafe_unretained NSString *visibility;
    __unsafe_unretained NSString *watermarkURL;
    __unsafe_unretained NSString *width;
    
    // Deprecated attribute names. Please use the JiveContentAttribute names.
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveVideoAttributes;


extern NSString * const JiveVideoType;

//! \class JiveVideo
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/VideoEntity.html
@interface JiveVideo : JiveStructuredOutcomeContent

//! Categories associated with this object. Places define the list of possible categories. String[]
@property(nonatomic, strong) NSArray* categories;

//! The list of users that can see the content. On create or update, provide a list of Person URIs or Person entities. On get, returns a list of Person entities. This value is used only when visibility is people. String[] or Person[]
@property(nonatomic, strong) NSArray* users;

//! The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * hidden - only the author can see the content.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

//! Video provider's ID
@property(nonatomic, readonly, strong) NSString* externalID;

//! URL of video service
@property(nonatomic, readonly, strong) NSURL* playerBaseURL;

//! The name of the player view.
@property(nonatomic, readonly, strong) NSString *playerName;

//! Video height
@property(nonatomic, readonly, strong) NSNumber* height;

//! Video width
@property(nonatomic, readonly, strong) NSNumber* width;

//! Video provider's authentication token, required for playing video
@property(nonatomic, readonly, strong) NSString* authtoken;

//! HTML source for an external link to video (e.g. YouTube, Vimeo)
@property(nonatomic, readonly, strong) NSString* videoSource;

//! Flag indicating if the video should start playing automatically.
@property(nonatomic, readonly, strong) NSNumber *autoplay;
- (BOOL)shouldAutoPlay;

//! The still image that should be displayed while the video is being loaded.
@property(nonatomic, readonly, strong) NSURL *stillImageURL;

//! Watermark URL.
@property(nonatomic, readonly, strong) NSURL *watermarkURL;

//! The total length of the video.
@property(nonatomic, readonly, strong) NSNumber *duration;

//! The length of the video in hours.
@property(nonatomic, readonly, strong) NSNumber *hours;

//! The length of the video in minutes.
@property(nonatomic, readonly, strong) NSNumber *minutes;

//! The length of the video in seconds.
@property(nonatomic, readonly, strong) NSNumber *seconds;

@property(nonatomic, readonly, strong) NSString *iframeSource;

//! Flag indicating if the video is embedded
@property(nonatomic, readonly, strong) NSNumber *embedded;
- (BOOL)isEmbeddedVideo;

//! Thumbnail image of the video.
@property(nonatomic, readonly, strong) NSURL *videoThumbnail;

//! The type of video.
@property(nonatomic, readonly, strong) NSString *videoType;

@end

