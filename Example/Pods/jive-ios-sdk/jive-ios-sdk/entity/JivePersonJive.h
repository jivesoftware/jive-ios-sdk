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

extern struct JivePersonJiveAttributes {
    __unsafe_unretained NSString *enabled;
    __unsafe_unretained NSString *external;
    __unsafe_unretained NSString *externalContributor;
    __unsafe_unretained NSString *federated;
    __unsafe_unretained NSString *lastProfileUpdate;
    __unsafe_unretained NSString *level;
    __unsafe_unretained NSString *locale;
    __unsafe_unretained NSString *password;
    __unsafe_unretained NSString *sendable;
    __unsafe_unretained NSString *profile;
    __unsafe_unretained NSString *termsAndConditionsRequired;
    __unsafe_unretained NSString *timeZone;
    __unsafe_unretained NSString *username;
    __unsafe_unretained NSString *viewContent;
    __unsafe_unretained NSString *visible;
} const JivePersonJiveAttributes;

@class JiveLevel;

//! \class JivePersonJive
//! https://developers.jivesoftware.com/api/v3/rest/JiveEntity.html
@interface JivePersonJive : JiveObject

//! Flag indicating whether this person is allowed to log in. Default is true.
//! Creation - optional
@property(nonatomic, copy) NSNumber *enabled;

//! Flag indicating whether this person is simply a representation of an external identity, not an actual person. Default is false.
//! Creation - optional
@property(nonatomic, copy) NSNumber *external;

//! Flag indicating that this person is an external contributor. Default is false.
//! Creation - optional
//! Can only be set to true if the external contributors feature has been enabled on this Jive instance.
@property(nonatomic, copy) NSNumber *externalContributor;

//! Flag indicating that this person is federated (identify is managed outside the Jive application). Default is false.
//! Creation - optional
@property(nonatomic, copy) NSNumber *federated;

//! Date and time of the last change to any profile field (addresses, emails, jive.profile, phoneNumbers) as well as jive.enabled, jive.external, jive.federated, jive.locale, jive.timeZone, jive.visible, and tags.
@property(nonatomic, readonly) NSDate *lastProfileUpdate;

//! The current status level for this person based on his points. For instance, "Newbie", "Adventurer", etc.
@property(nonatomic, readonly, strong) JiveLevel* level;

//! Locale identifier for this user. Will typically be either language (en) or language_variant (en_US).
//! Creation - optional
//! Only present when this Jive instance allows users to manage their own locale settings
@property(nonatomic, copy) NSString* locale;

//! The login password for this person. This field is never actually returned; instead it is present to allow a password to be set or updated when a person is created or updated, respectively. Password is required for person creation.
//! Creation - required
@property(nonatomic, copy) NSString* password;

//! Flag indicating whether the requesting person is allowed to send messages or shares to this person.
//! The absence of this flag cannot be assumed false or true.
@property(nonatomic, readonly) NSNumber *sendable;

//! The Jive profile fields for this person. All profile fields that are not an address, an email, a phone or a location are going to be listed by this entity. JiveProfileEntry.
@property(nonatomic, readonly, strong) NSArray* profile;

//! Localized description of the time zone for this person.
//! Creation - optional
//! Only present when this Jive instance allows users to manage their own time zone settings
@property(nonatomic, copy) NSString* timeZone;

//! The login username for this person. This field is required for person creation, but cannot be changed on an update.
//! Creation - required
@property(nonatomic, copy) NSString* username;

//! Flag indicating that this person is allowed to see the requested content.
@property(nonatomic, readonly) NSNumber *viewContent;

//! Flag indicating that this person is a regular user, visible to the rest of the system, as opposed to an internal system account.
@property(nonatomic, readonly) NSNumber *visible;

//! Flag in the me response indicating that the user needs to accept the terms and conditions before further access can be allowed.
@property(nonatomic, readonly) NSNumber *termsAndConditionsRequired;

@end
