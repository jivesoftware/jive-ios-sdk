//
//  JiveOpenSocial.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@class JiveEmbedded;

@interface JiveOpenSocial : JiveObject

// List of ActionLinks representing actions that a person might take against an actionable resource.
@property(nonatomic, readonly, strong) NSArray* actionLinks;

// List of URIs of Persons to which this activity should be explicitly delivered.
@property(nonatomic, readonly, strong) NSArray* deliverTo;

// Metadata about an OpenSocial Embedded Experience associated with this activity.
@property(nonatomic, readonly, strong) JiveEmbedded* embed;

@end
