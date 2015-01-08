//
//  JiveStatic.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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
#import "JivePerson.h"
#import "JivePlace.h"

//! \class JiveStatic
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/StaticEntity.html
@interface JiveStatic : JiveTypedObject

//! Person that most recently uploaded this static resource.
@property(nonatomic, readonly, strong) JivePerson* author;

//! Description of this static resource.
@property (nonatomic, copy) NSString *jiveDescription;

//! Filename of this static resource (must be unique within static resources for a particular place).
@property(nonatomic, copy) NSString* filename;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, copy) NSString* jiveId;

//! Place (blog, group, project, or space) that this static resource is associated with.
@property(nonatomic, readonly, copy) JivePlace* place;

//! Date and time this object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

//! Date and time this object was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

- (NSURL *)htmlRef;

@end
