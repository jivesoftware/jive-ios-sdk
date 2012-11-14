//
//  JiveContentBody.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveContentBody : JiveObject

// The (typically HTML) text of the content object's body.
@property(nonatomic, copy) NSString* text;

// The MIME type of this content object's body (typically text/html).
@property(nonatomic, copy) NSString* type;

@end
