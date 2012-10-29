//
//  JivePhoto.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@interface JivePhoto : JiveObject

// The URL value of this photo
@property(nonatomic, copy) NSString* value;

// Whether this is the primary photo, if doesn't exist then false
@property(nonatomic, readonly) bool primary;

@end
