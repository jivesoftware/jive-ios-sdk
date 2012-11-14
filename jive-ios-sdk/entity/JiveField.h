//
//  JiveField.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveField : JiveObject

// Flag indicating whether this field is represented as a JSON array, as opposed to an individual value.
@property(atomic, readonly) bool array;

// Comments regarding when this field will be present in an object representation.
@property(atomic, readonly, copy) NSString* availability;

// Description of this field (for profile fields, this information is localized).
@property(atomic, readonly, copy) NSString* description;

// Display name of this field (for profile fields, this information is localized).
@property(atomic, readonly, copy) NSString* displayName;

// Flag indicating that this field can be included on a create request, or modified on an update request.
@property(atomic, readonly) bool editable;

// The name of this field, as it will appear in a JSON representation.
@property(atomic, readonly, copy) NSString* name;

// Flag indicating that this field MUST be included on a create or update request.
@property(atomic, readonly) bool required;

// Comments about the first version of the API in which this object became available.
@property(atomic, readonly, copy) NSString* since;

// The data type for values in this field.
@property(atomic, readonly, copy) NSString* type;

// Flag indicating that this field is present for internal use only, and should not be considered to be generally available or documented.
@property(atomic, readonly) bool unpublished;


@end
