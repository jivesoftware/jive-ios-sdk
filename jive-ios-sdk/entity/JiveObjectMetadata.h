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


extern struct JiveObjectMetadataAttributes {
    __unsafe_unretained NSString *associatable;
    __unsafe_unretained NSString *availability;
    __unsafe_unretained NSString *commentable;
    __unsafe_unretained NSString *content;
    __unsafe_unretained NSString *example;
    __unsafe_unretained NSString *fields;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *objectType;
    __unsafe_unretained NSString *outcomeTypes;
    __unsafe_unretained NSString *place;
    __unsafe_unretained NSString *plural;
    __unsafe_unretained NSString *resourceLinks;
    __unsafe_unretained NSString *since;
} const JiveObjectMetadataAttributes;


//! \class JiveObjectMetadata
//! The metadata describing an object type, including the fields it includes.
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/ObjectEntity.html
@interface JiveObjectMetadata : JiveObject

//! Flag indicating whether objects of this type can be associated to (followed in) an activity stream. Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSNumber *associatable;
- (BOOL)isAssociatable;

//! Comments regarding when objects of this type will be available.
@property(nonatomic, readonly, copy) NSString* availability;

//! Flag indicating whether objects of this type can have comments added to them. Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSNumber *commentable;
- (BOOL)isCommentable;

//! Flag indicating whether this object type represents a Jive content object. Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSNumber *content;
- (BOOL)isContent;

//! Description of this object type.
@property(nonatomic, readonly, copy) NSString* jiveDescription;

//! A usage example for this object type.
@property(nonatomic, readonly, copy) NSString* example;

//! Metadata about the fields that may be present in the JSON representation of this object type. JiveField[]
@property(nonatomic, readonly, strong) NSArray* fields;

//! The name of this object type.
@property(nonatomic, readonly, copy) NSString* name;

//! Internal (to Jive) identifier for the object type of this object.
@property(nonatomic, readonly, copy) NSNumber *objectType;

//! Names of structured outcome types that are possible for this object type (if any). JiveOutcomeType[]
@property(nonatomic, readonly, strong) NSArray *outcomeTypes;

//! Flag indicating whether or not objects of this type are a Jive place (blog, group, project, or space). Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSNumber *place;
- (BOOL)isAPlace;

//! The plural name of this object type. Present on Jive core object types only.
@property(nonatomic, readonly, copy) NSString* plural;

//! Metadata about the resources that may be present in the JSON representation of this object type. JiveResource[]
@property(nonatomic, readonly, strong) NSArray* resourceLinks;

//! Comments about the first version of the API in which this object became available.
@property(nonatomic, readonly, copy) NSString* since;


@end
