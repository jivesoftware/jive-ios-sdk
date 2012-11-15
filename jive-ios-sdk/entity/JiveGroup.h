//
//  JiveGroup.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlace.h"
#import "JivePerson.h"

@interface JiveGroup : JivePlace

// Person that created this social group.
@property(nonatomic, readonly, strong) JivePerson* creator;

// Membership and visibility type of this group (OPEN, MEMBER_ONLY, PRIVATE, SECRET).
@property(nonatomic, copy) NSString* groupType;

// Number of people that are members of this group.
@property(nonatomic, readonly, strong) NSNumber* memberCount;

// Tags associated with this object. String[]
@property(nonatomic, readonly, strong) NSArray* tags;

@end
