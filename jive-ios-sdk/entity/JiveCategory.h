//
//  JiveCategory.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveCategory : JiveObject

// Description of the category.
@property(nonatomic, copy) NSString* description;

// Number of people following this object. Availability: Will be present only for object types that support being followed.
@property(nonatomic, readonly, strong) NSNumber *followerCount;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, strong) NSString* jiveId;

// Number of people who have liked this object. Availability: Will be present only for object types that support being liked.
@property(nonatomic, readonly, strong) NSNumber *likeCount;

// Name of the category.
@property(nonatomic, copy) NSString* name;

// URI of the place where this category belongs.
@property(nonatomic, readonly, strong) NSString* place;

// Date and time this object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// The object type of this object ("category").
@property(readonly) NSString* type;

// Date and time this person was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

@end
