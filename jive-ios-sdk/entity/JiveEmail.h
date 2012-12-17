//
//  JiveEmail.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@interface JiveEmail : JiveObject

// For primary emails the value must be "Email". To learn the list of email fields available in a Jive instance do a GET to /metadata/objects/emails. When using the Javascript API then execute metadata.getObjectMetadata("emails").
@property(nonatomic, copy) NSString* jive_label;

// A valid email address. Primary emails must be unique across the system.
@property(nonatomic, copy) NSString* value;

// Possible values are home, other or work.
@property(nonatomic, copy) NSString* type;

// True if this is the primary email address.
@property(nonatomic, readonly) bool primary;

- (id)toJSONDictionary;

@end
