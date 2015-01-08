//
//  ContentVideo.h
//  jive-ios-sdk
//
//    Created by Orson Bushnell on 5/22/14.
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

#import "JiveObject.h"


extern struct JiveContentVideoAttributes {
    __unsafe_unretained NSString *height;
    __unsafe_unretained NSString *stillImageURL;
    __unsafe_unretained NSString *videoSourceURL;
    __unsafe_unretained NSString *width;
} const JiveContentVideoAttributes;

//! \class JiveContentVideo
//! https://developers.jivesoftware.com/api/v3/cloud/rest/ContentVideoEntity.html
@interface JiveContentVideo : JiveObject

//! The height of the video.
@property(nonatomic, readonly, strong) NSNumber *height;

//! The URL of the still image to display while the video is loading.
@property(nonatomic, readonly, strong) NSURL *stillImageURL;

//! The URL to this video's binary stream
@property(nonatomic, readonly, strong) NSURL *videoSourceURL;

//! The width of the video.
@property(nonatomic, readonly, strong) NSNumber *width;

@end
