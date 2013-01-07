//
//  JiveStream.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JivePerson.h"

@interface JiveStream : JiveObject

// Unique identifier of this custom stream.
@property(nonatomic, readonly, strong) NSString* jiveId;

// Name of this custom stream. Will be a zero length string on custom streams with a source other than custom. Must be unique (per user) for streams with source custom.
@property(nonatomic, copy) NSString* name;

// A Person describing the person that owns this custom stream.
@property(nonatomic, readonly, strong) JivePerson* person;

// Date and time this custom stream was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

// Flag indicating whether the owner of this custom stream wants to receive email when new activity arrives.
@property(nonatomic, strong) NSNumber *receiveEmails;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

// Source of this particular stream. Custom streams managed via this API MUST have a stream source of custom. Other values for non-custom streams are:
// all - the standard "Activities" stream
// communications - the standard "Communications" stream
// connections - the standard "Connections" stream
// context - TODO definition
// profile - TODO definition
// watches - TODO definition
@property(nonatomic, copy) NSString* source;

// The object type of this object ("stream").
@property(nonatomic, readonly, strong) NSString* type;

// Date and time this custom stream configuration was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

@end
