//
//  JiveUpdate.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveUpdate : JiveContent

// If available, the latitude of the location from which this update was made.
@property(atomic, readonly, strong) NSNumber* latitude;

// If available, the longitude of the location from which this update was made.
@property(atomic, readonly, strong) NSNumber* longitude;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;


@end
