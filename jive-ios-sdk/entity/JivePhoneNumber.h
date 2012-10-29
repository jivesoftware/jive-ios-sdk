//
//  JivePhoneNumber.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@interface JivePhoneNumber : JiveObject

// For primary phone numbers the value must be "Phone Number". To learn the list of phone number fields available in a Jive instance do a GET to /metadata/objects/phoneNumbers. When using the Javascript API then execute metadata.getObjectMetadata("phoneNumbers").
@property(nonatomic, copy) NSString* jive_label;

// A valid phone number.
@property(nonatomic, copy) NSString* value;

// Possible values are home, other, fax, mobile, pager or work.
@property(nonatomic, copy) NSString* type;

// True if this is the primary phone number.
@property(nonatomic, readonly) bool primary;

@end
