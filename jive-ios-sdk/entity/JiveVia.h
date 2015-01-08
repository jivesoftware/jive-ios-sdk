//
//  JiveVia.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 5/13/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveObject.h"


extern struct JiveViaAttributes {
    __unsafe_unretained NSString *displayName;
    __unsafe_unretained NSString *url;
} const JiveViaAttributes;


//! \class JiveVia
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/ViaEntity.html
@interface JiveVia : JiveObject

//! Name of the remote system that was used for writing the original content and that posted the message in Jive.
@property (nonatomic, copy) NSString *displayName;

//! Relative URL for downloading or getting more information about the remote system that can post on behalf of other users.
@property (nonatomic, copy) NSURL *url;

@end
