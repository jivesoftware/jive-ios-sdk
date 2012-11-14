//
//  JiveComment.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveComment : JiveContent

// Object type of the root content object that this comment is a direct or indirect reply to.
@property(nonatomic, readonly, copy) NSString* rootType;

// URI of the root content object that this comment is a direct or indirect reply to.
@property(nonatomic, readonly, copy) NSString* rootURI;


@end
