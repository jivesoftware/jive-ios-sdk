//
//  JiveProfileEntry.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveObject.h"

@interface JiveProfileEntry : JiveObject

// Label for this profile entry.
@property(nonatomic, readonly, copy) NSString* jive_label;

// Value for this profile entry.
@property(nonatomic, readonly, copy) NSString* value;

@end
