//
//  JivePerson.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"


@class JivePersonJive;
@class Name;


@interface JivePerson : JiveObject


// List of postal JiveAddresses belonging to this person, with standard types home,other,pobox,work and value type of address. JiveAddress[]
@property(nonatomic, readonly, strong) NSArray* addresses;

// Formatted full name of this person, suitable for use in UI presentation. If the person has privacy settings that do not allow you to see his or her name, this will be the Jive username instead.
@property(nonatomic, copy) NSString* displayName;

// List of JiveEmail addresses belonging to this person, with standard types home, other, work and value type of string. JiveEmail[]
@property(nonatomic, readonly, strong) NSArray* emails;

// Number of people following this object.
@property(nonatomic, readonly) NSInteger followerCount;

// Number of people this person is following.
@property(nonatomic, readonly) NSInteger followingCount;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, copy) NSString* jiveId;

// Jive extensions to OpenSocial person object.
@property(nonatomic, readonly, strong) JivePersonJive* jive;

// Geographic location of this person.
@property(nonatomic, copy) NSString* location;

// Name components for this person.
@property(nonatomic, readonly, strong) Name* name;

// JivePhone numbers belonging to this person, with standard types: fax, home, mobile, other, pager, work. JivePhoneNumber[]
@property(nonatomic, readonly, strong) NSArray* phoneNumbers;

// URI(s) of profile images for this person. To manage profile images in REST, use the images resource.
@property(nonatomic, readonly, strong) NSArray* photos;

// Date and time when this person was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

// Most recent status update for this person.
@property(nonatomic, copy) NSString* status;

// Defined tags for this person. NSString[]
@property(nonatomic, readonly, strong) NSArray* tags;

// URL of the thumbnail (avatar) image for this person.
@property(nonatomic, copy) NSString* thumbnailUrl;

// The object type of this object ("person").
@property(nonatomic, copy) NSString* type;

// Date and time this person was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;




@end
