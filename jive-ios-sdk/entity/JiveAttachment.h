//
//  JiveAttachment.h
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

#import "JiveObject.h"

extern struct JiveAttachmentAttributes {
    __unsafe_unretained NSString *contentType;
    __unsafe_unretained NSString *doUpload;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *resources;
    __unsafe_unretained NSString *size;
    __unsafe_unretained NSString *url;
} const JiveAttachmentAttributes;

//! \class JiveAttachment
//! https://developers.jivesoftware.com/api/v3/rest/AttachmentEntity.html
@interface JiveAttachment : JiveObject

//! The content type of this attachment.
@property(nonatomic, copy) NSString* contentType;

//! An indicator of whether an attachment is new and should be uploaded.
@property(nonatomic, strong) NSNumber *doUpload;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, copy) NSString* jiveId;

//! Filename of this attachment.
@property(nonatomic, copy) NSString* name;

//! Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

//! The size (in bytes) of this attachment.
@property(nonatomic, readonly, strong) NSNumber* size;

//! The URL to retrieve the binary content of this attachment.
@property(nonatomic, copy) NSURL* url;


@end
