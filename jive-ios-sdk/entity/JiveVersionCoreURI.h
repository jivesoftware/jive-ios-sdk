//
//  JiveVersionCoreURI.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/11/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

extern struct JiveVersionCoreURIAttributes {
    __unsafe_unretained NSString *version;
    __unsafe_unretained NSString *revision;
    __unsafe_unretained NSString *uri;
    __unsafe_unretained NSString *documentation;
} const JiveVersionCoreURIAttributes;

@interface JiveVersionCoreURI : JiveObject

@property (nonatomic, readonly) NSNumber *version;
@property (nonatomic, readonly) NSNumber *revision;
@property (nonatomic, readonly) NSString *uri;
@property (nonatomic, readonly) NSURL *documentation;

@end
