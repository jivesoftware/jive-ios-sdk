//
//  JiveStream_internal.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 5/2/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveStream.h"


struct JiveStreamResourceTags {
    __unsafe_unretained NSString *activity;
    __unsafe_unretained NSString *associations;
    __unsafe_unretained NSString *html;
} const JiveStreamResourceTags;

struct JiveStreamJSONAttributes {
    __unsafe_unretained NSString *newUpdates;
    __unsafe_unretained NSString *previousUpdates;
} const JiveStreamJSONAttributes;
