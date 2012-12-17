//
//  JiveName.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@interface JiveName : JiveObject

// Last name of this person.
@property(nonatomic, copy) NSString* familyName;

// Formatted full name of this person.
@property(nonatomic, copy, readonly) NSString* formatted;

// First name of this person.
@property(nonatomic, copy) NSString* givenName;

- (id)toJSONDictionary;

@end
