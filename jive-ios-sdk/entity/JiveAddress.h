//
//  JiveAddress.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@interface JiveAddress : JiveObject

// For primary addresses the value must be "Address". To learn the list of address fields available in a Jive instance do a GET to /metadata/objects/addresses. When using the Javascript API then execute metadata.getObjectMetadata("addresses").
@property(nonatomic, copy) NSString* jive_label;

// A valid postal address. This is a JSON object where one or more of the following String fields must be specified: streetAddress, locality, region, postalCode or country.
@property(nonatomic, copy) NSString* value;

// Possible values are home, other or work.
@property(nonatomic, copy) NSString* type;

// True if this is the primary postal address.
@property(nonatomic, readonly) bool primary;


@end
