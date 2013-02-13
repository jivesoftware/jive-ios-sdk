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
#import "JiveObject.h"


@class JivePersonJive;
@class JiveName;


@interface JivePerson : JiveObject

// List of postal JiveAddresses belonging to this person, with standard types home,other,pobox,work and value type of address. JiveAddress[]
@property(nonatomic, strong) NSArray* addresses; // Creation - optional

// Formatted full name of this person, suitable for use in UI presentation. If the person has privacy settings that do not allow you to see his or her name, this will be the Jive username instead.
@property(nonatomic, readonly, strong) NSString* displayName;

// List of JiveEmail addresses belonging to this person, with standard types home, other, work and value type of string. JiveEmail[]
@property(nonatomic, strong) NSArray* emails; // Creation - required

// Number of people following this object.
@property(nonatomic, readonly, strong) NSNumber *followerCount;

// Number of people this person is following.
@property(nonatomic, readonly, strong) NSNumber *followingCount;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, strong) NSString* jiveId;

// Jive extensions to OpenSocial person object.
@property(nonatomic, strong) JivePersonJive* jive; // Creation - required

// Geographic location of this person.
@property(nonatomic, copy) NSString* location; // Creation - optional

// Name components for this person.
@property(nonatomic, strong) JiveName* name; // Creation - required

// JivePhone numbers belonging to this person, with standard types: fax, home, mobile, other, pager, work. JivePhoneNumber[]
@property(nonatomic, strong) NSArray* phoneNumbers; // Creation - optional

// URI(s) of profile images for this person. To manage profile images in REST, use the images resource.
@property(nonatomic, readonly, strong) NSArray* photos;

// Date and time when this person was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

// Resource links (and related permissions for the requesting person) relevant to this object. JiveResourceEntry[]
@property(nonatomic, readonly, strong) NSDictionary* resources;

// Most recent status update for this person.
@property(nonatomic, copy) NSString* status; // Creation - optional

// Defined tags for this person. NSString[]
@property(nonatomic, strong) NSArray* tags; // Creation - optional

// URL of the thumbnail (avatar) image for this person.
@property(nonatomic, readonly, strong) NSString* thumbnailUrl;

// The object type of this object ("person").
@property(nonatomic, readonly) NSString* type;

// Date and time this person was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;


@end
