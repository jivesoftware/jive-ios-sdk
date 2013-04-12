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

@interface JivePlatformVersion : JiveObject

@property (nonatomic, readonly) NSNumber *major;
@property (nonatomic, readonly) NSNumber *minor;
@property (nonatomic, readonly) NSNumber *maintenance;
@property (nonatomic, readonly) NSNumber *build;
@property (nonatomic, readonly) NSString *releaseID;
@property (nonatomic, readonly) NSArray *coreURI;       // JiveVersionCoreURI[]
@property (nonatomic, readonly) NSArray *ssoEnabled;    // NSString[]

@end
