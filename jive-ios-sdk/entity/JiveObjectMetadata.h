//
//  JiveNotSoGeneralObject.h
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

//! \class JiveObjectMetadata
//! The metadata describing an object type, including the fields it includes.
//! https://developers.jivesoftware.com/api/v3/rest/ObjectEntity.html
@interface JiveObjectMetadata : JiveObject

//! Flag indicating whether objects of this type can be associated to (followed in) an activity stream. Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSNumber *associatable;

//! Comments regarding when objects of this type will be available.
@property(nonatomic, readonly, copy) NSString* availability;

//! Flag indicating whether objects of this type can have comments added to them. Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSNumber *commentable;

//! Flag indicating whether this object type represents a Jive content object. Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSNumber *content;

//! Description of this object type.
@property(nonatomic, readonly, copy) NSString* description;

//! A usage example for this object type.
@property(nonatomic, readonly, copy) NSString* example;

//! Metadata about the fields that may be present in the JSON representation of this object type. Field[]
@property(nonatomic, readonly, strong) NSArray* fields;

//! The name of this object type.
@property(nonatomic, readonly, copy) NSString* name;

//! Flag indicating whether or not objects of this type are a Jive place (blog, group, project, or space). Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSNumber *place;

//! The plural name of this object type. Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSString* plural;

//! Metadata about the resources that may be present in the JSON representation of this object type. Resource[]
@property(nonatomic, readonly, strong) NSArray* resourceLinks;

//! Comments about the first version of the API in which this object became available.
@property(nonatomic, readonly, copy) NSString* since;


@end
