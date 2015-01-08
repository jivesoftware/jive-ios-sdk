//
//  JiveNews.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/26/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JivePerson.h"


extern struct JiveNewsAttributes {
    __unsafe_unretained NSString *newsStreams;
    __unsafe_unretained NSString *owner;
    __unsafe_unretained NSString *type;
} const JiveNewsAttributes;


//! \class JiveNews
//! The news feed object.
@interface JiveNews : JiveObject

//! The news feeds for the owners streams. JiveNewsStream[]
@property(nonatomic, readonly) NSArray* newsStreams;

//! The owner of the stream. Relevant only for administrators, who can look at other peoples news.
@property(nonatomic, readonly) JivePerson* owner;

//! The object type of this object.
@property(nonatomic, readonly) NSString* type;

@end
