//
//  Jive.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@class JiveLevel;

@interface JivePersonJive : JiveObject

// Flag indicating whether this person is allowed to log in. Default is true.
@property(nonatomic, readonly) bool enabled;

// Flag indicating whether this person is simply a representation of an external identity, not an actual person. Default is false.
@property(nonatomic, readonly) bool external;

// Flag indicating that this person is an external contributor. Default is false.
@property(nonatomic, readonly) bool externalContributor;

// Flag indicating that this person is federated (identify is managed outside the Jive application). Default is false.
@property(nonatomic, readonly) bool federated;

// The current status level for this person based on his points. For instance, "Newbie", "Adventurer", etc.
@property(nonatomic, readonly, strong) JiveLevel* level;

// Locale identifier for this user. Will typically be either language (en) or language_variant (en_US).
@property(nonatomic, copy) NSString* locale;

// The login password for this person. This field is never actually returned; instead it is present to allow a password to be set or updated when a person is created or updated, respectively. Password is required for person creation.
@property(nonatomic, copy) NSString* password;

// The Jive profile fields for this person. All profile fields that are not an address, an email, a phone or a location are going to be listed by this entity.
@property(nonatomic, readonly, strong) NSArray* profile;

// Localized description of the time zone for this person.
@property(nonatomic, copy) NSString* timeZone;

// The login username for this person. This field is required for person creation, but cannot be changed on an update.
@property(nonatomic, copy) NSString* username;

// Flag indicating that this person is a regular user, visible to the rest of the system, as opposed to an internal system account.
@property(nonatomic, readonly) bool visible;

- (id)toJSONDictionary;

@end
