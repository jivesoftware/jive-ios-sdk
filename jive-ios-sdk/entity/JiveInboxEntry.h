//
//  JiveInboxEntry.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

#import <Foundation/Foundation.h>
#import "JiveObject.h"
#import "JiveGenericPerson.h"

@class JiveActivityObject;
@class JiveMediaLink;
@class JiveExtension;
@class JiveOpenSocial;

extern struct JiveInboxEntryAttributes {
    __unsafe_unretained NSString *actor;
    __unsafe_unretained NSString *content;
    __unsafe_unretained NSString *generator;
    __unsafe_unretained NSString *icon;
    __unsafe_unretained NSString *jive;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *object;
    __unsafe_unretained NSString *openSocial;
    __unsafe_unretained NSString *provider;
    __unsafe_unretained NSString *published;
    __unsafe_unretained NSString *target;
    __unsafe_unretained NSString *title;
    __unsafe_unretained NSString *url;
    __unsafe_unretained NSString *updated;
    __unsafe_unretained NSString *verb;
} const JiveInboxEntryAttributes;

//! \class JiveInboxEntry
//! https://developers.jivesoftware.com/api/v3/rest/InboxEntryEntity.html
@interface JiveInboxEntry : JiveObject

//! The person (or other object) that created this activity.
@property(nonatomic, readonly, strong) JiveActivityObject* actor;

//! Text (or possibly HTML) content describing this activity.
@property(nonatomic, copy) NSString* content;

//! The application used to generate this activity.
@property(nonatomic, readonly, strong) JiveActivityObject* generator;

//! An icon associated with this activity.
@property(nonatomic, readonly, strong) JiveMediaLink* icon;

//! Internal identifier for this activity.
@property(nonatomic, copy) NSString* jiveId;

//Jive extensions to the standard Activity Streams format.
@property(nonatomic, readonly, strong) JiveExtension* jive;

//! The object that was affected by this activity.
@property(nonatomic, readonly, strong) JiveActivityObject* object;

//! OpenSocial extensions to the standard Activity Streams format.
@property(nonatomic, readonly, strong) JiveOpenSocial* openSocial;

//! The service instance at which this activity was generated.
@property(nonatomic, readonly, strong) JiveActivityObject* provider;

//! The date and time at which this activity was generated.
@property(nonatomic, readonly, strong) NSDate* published;

//! The object representing the "context" or "target" of this activity.
@property(nonatomic, readonly, strong) JiveActivityObject* target;

//! The title of this activity.
@property(nonatomic, copy) NSString* title;

//! The date and time at which this activity was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

//! A URL pointing at more detailed information related to this activity.
@property(nonatomic, readonly, strong) NSURL* url;

//! The verb describing the category of activity that took place. Verbs for Jive standard actions will be prefixed with jive:
@property(nonatomic, copy) NSString* verb;

@end
