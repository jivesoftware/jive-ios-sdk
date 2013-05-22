//
//  JiveCategory.h
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

//! \class JiveCategory
//! https://developers.jivesoftware.com/api/v3/rest/CategoryEntity.html
@interface JiveCategory : JiveTypedObject

//! Description of the category.
@property(nonatomic, copy) NSString* description;

//! Number of people following this object. Availability: Will be present only for object types that support being followed.
@property(nonatomic, readonly, strong) NSNumber *followerCount;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, strong) NSString* jiveId;

//! Number of people who have liked this object. Availability: Will be present only for object types that support being liked.
@property(nonatomic, readonly, strong) NSNumber *likeCount;

//! Name of the category.
@property(nonatomic, copy) NSString* name;

//! URI of the place where this category belongs.
@property(nonatomic, readonly, strong) NSString* place;

//! Date and time this object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

//! Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

//! Date and time this person was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

@end
