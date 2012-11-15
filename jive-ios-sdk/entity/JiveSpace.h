//
//  JiveSpace.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlace.h"

@interface JiveSpace : JivePlace

// Number of spaces that are direct children of this space.
@property(nonatomic, readonly, strong) NSNumber* childCount;

// Tags associated with this object. String[]
@property(nonatomic, strong) NSArray* tags;

@end
