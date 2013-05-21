//
//  JiveVersion.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

extern struct JivePlatformVersionAttributes {
    __unsafe_unretained NSString *major;
    __unsafe_unretained NSString *minor;
    __unsafe_unretained NSString *maintenance;
    __unsafe_unretained NSString *build;
    __unsafe_unretained NSString *releaseID;
    __unsafe_unretained NSString *coreURI;
    __unsafe_unretained NSString *ssoEnabled;
} const JivePlatformVersionAttributes;

//! \class JivePlatformVersion
//! Version data for a Jive instance
@interface JivePlatformVersion : JiveObject

//! Major release version
@property (nonatomic, readonly) NSNumber *major;

//! Minor release version
@property (nonatomic, readonly) NSNumber *minor;

//! Maintenance release version
@property (nonatomic, readonly) NSNumber *maintenance;

//! Build version
@property (nonatomic, readonly) NSNumber *build;

//! Release identifier.
@property (nonatomic, readonly) NSString *releaseID;

//! Available REST api versions. JiveCoreVersion[]
@property (nonatomic, readonly) NSArray *coreURI;

//! SSO types available for authorization. Simple authorization is not available if this is populated. NSString[]
@property (nonatomic, readonly) NSArray *ssoEnabled;

@end
