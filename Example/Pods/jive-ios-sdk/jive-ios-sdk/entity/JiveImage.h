//
//  JiveImage.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 2/27/13.
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

#import "JiveTypedObject.h"

//! \class JiveImage
//! https://developers.jivesoftware.com/api/v3/rest/ImageEntity.html
@interface JiveImage : JiveTypedObject

//! Unique identifier of this image
@property(nonatomic, readonly, strong) NSString* jiveId;

//! Length of image data
@property(nonatomic, readonly) NSNumber* size;

//! Content type of this image
@property(nonatomic, readonly, strong) NSString* contentType;

//! URI that can be used to reference this image within content
@property(nonatomic, readonly) NSURL* ref;

//! Filename of this image
@property(nonatomic, readonly, strong) NSString* name;

@end
