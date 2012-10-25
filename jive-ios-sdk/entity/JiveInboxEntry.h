//
//  JiveInboxEntry.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiveObject.h"

@class JiveActivityObject;
@class JiveMediaLink;
@class JiveExtension;
@class JiveOpenSocial;

@interface JiveInboxEntry : JiveObject

// The person (or other object) that created this activity.
@property(nonatomic, readonly, strong) JiveActivityObject* actor;

// Text (or possibly HTML) content describing this activity.
@property(nonatomic, copy) NSString* content;

// The application used to generate this activity.
@property(nonatomic, readonly, strong) JiveActivityObject* generator;

// An icon associated with this activity.
@property(nonatomic, readonly, strong) JiveMediaLink* icon;

// Internal identifier for this activity.
@property(nonatomic, copy) NSString* jiveId;

//Jive extensions to the standard Activity Streams format.
@property(nonatomic, readonly, strong) JiveExtension* jive;

// The object that was affected by this activity.
@property(nonatomic, readonly, strong) JiveActivityObject* object;

// OpenSocial extensions to the standard Activity Streams format.
@property(nonatomic, readonly, strong) JiveOpenSocial* openSocial;

// The service instance at which this activity was generated.
@property(nonatomic, readonly, strong) JiveActivityObject* provider;

// The date and time at which this activity was generated.
@property(nonatomic, readonly, strong) NSDate* published;

// The object representing the "context" or "target" of this activity.
@property(nonatomic, readonly, strong) JiveActivityObject* target;

// The title of this activity.
@property(nonatomic, copy) NSString* title;

// The date and time at which this activity was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

// A URL pointing at more detailed information related to this activity.
@property(nonatomic, readonly, strong) NSURL* url;

// The verb describing the category of activity that took place. Verbs for Jive standard actions will be prefixed with jive:
@property(nonatomic, copy) NSString* verb;

@end
