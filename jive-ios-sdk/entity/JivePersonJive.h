//
//  Jive.h
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

@class JiveLevel;

@interface JivePersonJive : JiveObject

// Flag indicating whether this person is allowed to log in. Default is true.
@property(nonatomic, copy) NSNumber *enabled; // Creation - optional

// Flag indicating whether this person is simply a representation of an external identity, not an actual person. Default is false.
@property(nonatomic, copy) NSNumber *external; // Creation - optional

// Flag indicating that this person is an external contributor. Default is false.
@property(nonatomic, copy) NSNumber *externalContributor; // Creation - optional

// Flag indicating that this person is federated (identify is managed outside the Jive application). Default is false.
@property(nonatomic, copy) NSNumber *federated; // Creation - optional

// The current status level for this person based on his points. For instance, "Newbie", "Adventurer", etc.
@property(nonatomic, readonly, strong) JiveLevel* level;

// Locale identifier for this user. Will typically be either language (en) or language_variant (en_US).
@property(nonatomic, copy) NSString* locale; // Creation - optional

// The login password for this person. This field is never actually returned; instead it is present to allow a password to be set or updated when a person is created or updated, respectively. Password is required for person creation.
@property(nonatomic, copy) NSString* password; // Creation - required

// The Jive profile fields for this person. All profile fields that are not an address, an email, a phone or a location are going to be listed by this entity.
@property(nonatomic, readonly, strong) NSArray* profile;

// Localized description of the time zone for this person.
@property(nonatomic, copy) NSString* timeZone; // Creation - optional

// The login username for this person. This field is required for person creation, but cannot be changed on an update.
@property(nonatomic, copy) NSString* username; // Creation - required

// Flag indicating that this person is a regular user, visible to the rest of the system, as opposed to an internal system account.
@property(nonatomic, readonly) NSNumber *visible;

@end
