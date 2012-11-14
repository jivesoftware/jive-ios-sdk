//
//  JiveDirectMessage.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveDirectMessage : JiveContent

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic) bool visibleToExternalContributors;

@end
