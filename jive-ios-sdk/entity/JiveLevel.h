//
//  JiveLevel.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@interface JiveLevel : JiveObject

// Description of the status level that this person has achieved.
@property(nonatomic, readonly) NSString* description;

// Name of the status level that this person has achieved.
@property(nonatomic, readonly) NSString* name;

// Number of status level points that this person has achieved.
@property(nonatomic, readonly) NSNumber *points;

@end
