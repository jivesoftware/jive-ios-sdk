//
//  JiveFavorite.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveFavorite : JiveContent

// The favorite object that was saved. When creating a favorite, the fields type and url are required.
@property(nonatomic, strong) NSDictionary* favoriteObject;

// Flag indicating that this favorite is private, and thus not shared.
@property(nonatomic, strong) NSNumber *private;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;

@end
