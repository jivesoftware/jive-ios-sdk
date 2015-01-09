//
//  JiveNewsStream.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/26/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JiveStream.h"


extern struct JiveNewsStreamAttributes {
    __unsafe_unretained NSString *activities;
    __unsafe_unretained NSString *stream;
    __unsafe_unretained NSString *type;
} const JiveNewsStreamAttributes;


//! \class JiveNewsStream
//! A current news for a stream.
@interface JiveNewsStream : JiveObject

//! The recent activities in the stream. JiveActivity[]
@property (nonatomic, readonly) NSArray *activities;

//! The stream the activites are from.
@property (nonatomic, readonly) JiveStream *stream;

//! The object type of this object.
@property (nonatomic, readonly) NSString *type;

@end
