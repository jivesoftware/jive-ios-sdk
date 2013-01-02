//
//  JiveStatic.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JivePerson.h"
#import "JivePlace.h"

@interface JiveStatic : JiveObject

// Person that most recently uploaded this static resource.
@property(nonatomic, readonly, strong) JivePerson* author;

// Description of this static resource.
@property (nonatomic, copy) NSString *description;

// Filename of this static resource (must be unique within static resources for a particular place).
@property(nonatomic, copy) NSString* filename;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, copy) NSString* jiveId;

// Place (blog, group, project, or space) that this static resource is associated with.
@property(nonatomic, readonly, copy) JivePlace* place;

// Date and time this object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

// The object type of this object ("static").
@property(nonatomic, readonly, copy) NSString* type;

// Date and time this object was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

@end
