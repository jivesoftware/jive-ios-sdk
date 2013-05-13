//
//  JivePerson.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
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

#import <Foundation/Foundation.h>
#import "JiveTypedObject.h"

extern struct JivePersonAttributes {
    __unsafe_unretained NSString *jiveId;
} const JivePersonAttributes;

extern struct JivePersonResourceAttributes {
    __unsafe_unretained NSString *activity;
    __unsafe_unretained NSString *avatar;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *colleagues;
    __unsafe_unretained NSString *extprops;
    __unsafe_unretained NSString *followers;
    __unsafe_unretained NSString *following;
    __unsafe_unretained NSString *followingIn;
    __unsafe_unretained NSString *html;
    __unsafe_unretained NSString *images;
    __unsafe_unretained NSString *manager;
    __unsafe_unretained NSString *members;
    __unsafe_unretained NSString *reports;
    __unsafe_unretained NSString *self;
    __unsafe_unretained NSString *streams;
    __unsafe_unretained NSString *tasks;
} const JivePersonResourceAttributes;

@class JivePersonJive;
@class JiveName;


//! \class JivePerson
//! https://developers.jivesoftware.com/api/v3/rest/PersonEntity.html
@interface JivePerson : JiveTypedObject

//! List of postal JiveAddresses belonging to this person, with standard types home,other,pobox,work and value type of address. JiveAddress[]
//! Creation - optional
@property(nonatomic, strong) NSArray* addresses;

//! Formatted full name of this person, suitable for use in UI presentation. If the person has privacy settings that do not allow you to see his or her name, this will be the Jive username instead.
@property(nonatomic, readonly, strong) NSString* displayName;

//! List of JiveEmail addresses belonging to this person, with standard types home, other, work and value type of string. JiveEmail[]
//! Creation - required
@property(nonatomic, strong) NSArray* emails;

//! Number of people following this object.
@property(nonatomic, readonly, strong) NSNumber *followerCount;

//! Number of people this person is following.
@property(nonatomic, readonly, strong) NSNumber *followingCount;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, strong) NSString* jiveId;

//! Jive extensions to OpenSocial person object.
//! Creation - required
@property(nonatomic, strong) JivePersonJive* jive;

//! Geographic location of this person.
//! Creation - optional
@property(nonatomic, copy) NSString* location;

//! Name components for this person.
//! Creation - required
@property(nonatomic, strong) JiveName* name;

//! JivePhone numbers belonging to this person, with standard types: fax, home, mobile, other, pager, work. JivePhoneNumber[]
//! Creation - optional
@property(nonatomic, strong) NSArray* phoneNumbers;

//! URI(s) of profile images for this person. To manage profile images in REST, use the images resource.
@property(nonatomic, readonly, strong) NSArray* photos;

//! Date and time when this person was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

//! Most recent status update for this person.
//! Creation - optional
@property(nonatomic, copy) NSString* status;

//! Defined tags for this person. NSString[]
//! Creation - optional
@property(nonatomic, strong) NSArray* tags;

//! URL of the thumbnail (avatar) image for this person.
@property(nonatomic, readonly, strong) NSString* thumbnailUrl;

//! Date and time this person was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

@end
