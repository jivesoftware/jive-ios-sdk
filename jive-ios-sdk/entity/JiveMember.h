//
//  JiveMember.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JiveGroup.h"
#import "JivePerson.h"

@interface JiveMember : JiveObject

// Group to which this member belongs.
@property (nonatomic, readonly, strong) JiveGroup *group;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, strong) NSString* jiveId;

// Jive person that is a member of the specified group.
@property(nonatomic, readonly, strong) JivePerson *person;

// Date and time when this content object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

// Current state of this membership.
// * banned - Previously accepted member has been banned from further involvement.
// * invited - Person has been invited but has not yet accepted the invitation.
// * member - Current member with standard permissions.
// * owner - Current member with place owner permissions.
// * pending - Person has requested membership but has not yet been accepted.
@property(nonatomic, strong) NSString* state;

// The object type of this object.
@property(nonatomic, readonly, strong) NSString* type;

// Date and time this content object was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

@end
