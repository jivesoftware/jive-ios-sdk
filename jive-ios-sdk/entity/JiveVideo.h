//
//  JiveVideo.h
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveVideo : JiveContent

//! Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, readonly, strong) NSNumber *visibleToExternalContributors;

@end
