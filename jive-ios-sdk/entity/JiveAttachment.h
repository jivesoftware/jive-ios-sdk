//
//  JiveAttachment.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveAttachment : JiveObject

// The content type of this attachment.
@property(nonatomic, copy) NSString* contentType;

// An indicator of whether an attachment is new and should be uploaded.
@property(nonatomic) bool doUpload;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, copy) NSString* jiveId;

// Filename of this attachment.
@property(nonatomic, copy) NSString* name;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property(nonatomic, readonly, strong) NSDictionary* resources;

// The size (in bytes) of this attachment.
@property(nonatomic, readonly, strong) NSNumber* size;

// The URL to retrieve the binary content of this attachment.
@property(nonatomic, copy) NSString* url;


@end
