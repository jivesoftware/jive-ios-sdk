//
//  JiveActivity.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/9/13.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveObject.h"
#import "JiveActivityObject.h"
#import "JiveExtension.h"
#import "JiveOpenSocial.h"
#import "JiveMediaLink.h"

//! \class JiveActivity
//! https://developers.jivesoftware.com/api/v3/rest/ActivityEntity.html
@interface JiveActivity : JiveObject

//! The person (or other object) that created this activity.
@property (nonatomic, readonly, strong) JiveActivityObject *actor;

//! Text (or possibly HTML) content describing this activity. Required for creation.
@property (nonatomic, copy) NSString *content;

//! The application used to generate this activity.
@property (nonatomic, readonly, strong) JiveActivityObject *generator;

//! An icon associated with this activity.
@property (nonatomic, strong) JiveMediaLink *icon;

//! Internal identifier for this activity.
@property(nonatomic, readonly, strong) NSString* jiveId;

//! Jive extensions to the standard Activity Streams format.
@property (nonatomic, strong) JiveExtension *jive;

//! The object that was affected by this activity.
@property (nonatomic, strong) JiveActivityObject *object;

//! OpenSocial extensions to the standard Activity Streams format.
@property (nonatomic, strong) JiveOpenSocial *openSocial;

//! The service instance at which this activity was generated.
@property (nonatomic, readonly, strong) JiveActivityObject *provider;

//! The date and time at which this activity was generated.
@property(nonatomic, readonly, strong) NSDate* published;

//! The object representing the "context" or "target" of this activity.
@property (nonatomic, strong) JiveActivityObject *target;

//! The title of this activity. Required for creation.
@property (nonatomic, copy) NSString *title;

//! The date and time at which this activity was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

//! A URL pointing at more detailed information related to this activity.
@property (nonatomic, copy) NSURL *url;

//! The verb describing the category of activity that took place. Verbs for Jive standard actions will be prefixed with jive:, and are only for internal use by Jive.
@property (nonatomic, copy) NSString *verb;

@end
