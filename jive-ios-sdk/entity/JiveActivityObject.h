//
//  JiveActivityObject.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@class JiveMediaLink;

@interface JiveActivityObject : JiveObject

// The person (or other entity) that created or authored this object.
@property(nonatomic, readonly, strong) JiveActivityObject *author;

// Natural language description of this object (may contain HTML markup).
@property(nonatomic, copy) NSString* content;

//Natural language, human readable, and plain text name of this object.
@property(nonatomic, copy) NSString* displayName;

//Permanent and universally unique identifier for this object. For standard Jive objects (those for which the objectType field starts with "jive:"), this will be an IRI that resolves to the Jive Core API endpoint to retrieve this particular object.
@property(nonatomic, copy) NSString* jiveId;

// Description of a resource providing a visual representation of this object, intended for human consumption
@property(nonatomic, readonly, strong) JiveMediaLink* image;

// The type of this object. Standard Jive objects will all have a prefix of jive:.
@property(nonatomic, copy) NSString* objectType;

// Date and time when this object was initally published.
@property(nonatomic, readonly, strong) NSDate* published;

// Natural language summarization of this object, which may contain HTML markup.
@property(nonatomic, copy) NSString* summary;

// Date and time at which a previously published object was modified.
@property(nonatomic, readonly, strong) NSDate* updated;

// URI identifying a resource that provides an HTML representation of the object.
@property(nonatomic, readonly, strong) NSURL* url;

@end
