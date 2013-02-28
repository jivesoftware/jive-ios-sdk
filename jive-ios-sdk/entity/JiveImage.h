//
//  JiveImage.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 2/27/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveImage : JiveObject

//! Type of image
@property(nonatomic, readonly, strong) NSString* type;

//! Unique identifier of this image
@property(nonatomic, readonly, strong) NSString* jiveId;

//! Length of image data
@property(nonatomic, readonly) NSNumber* size;

//! Content type of this image
@property(nonatomic, readonly, strong) NSString* contentType;

//! URI that can be used to reference this image within content
@property(nonatomic, readonly) NSURL* ref;

@end
