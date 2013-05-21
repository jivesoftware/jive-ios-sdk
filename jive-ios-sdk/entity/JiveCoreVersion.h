//
//  JiveCoreVersion.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/11/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

extern struct JiveCoreVersionAttributes {
    __unsafe_unretained NSString *version;
    __unsafe_unretained NSString *revision;
    __unsafe_unretained NSString *uri;
    __unsafe_unretained NSString *documentation;
} const JiveCoreVersionAttributes;

//! \class JiveCoreVersion
//! REST api version information
@interface JiveCoreVersion : JiveObject

//! REST api major version. This SDK works with version 3.
@property (nonatomic, readonly) NSNumber *version;

//! REST api minor version. This SDK may check this value for feature availablity.
@property (nonatomic, readonly) NSNumber *revision;

//! Relative path for all REST api calls.
@property (nonatomic, readonly) NSString *uri;

//! REST api documentation.
@property (nonatomic, readonly) NSURL *documentation;

@end
