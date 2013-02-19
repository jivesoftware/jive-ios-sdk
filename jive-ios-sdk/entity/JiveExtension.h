//
//  JiveExtension.h
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

@class JiveActivityObject;

//! \class JiveExtension
//! https://developers.jivesoftware.com/api/v3/rest/JiveExtensionEntity.html
@interface JiveExtension : JiveObject

//! Identifier that groups several activities around the same topic. Activities within such a collection are ordered newest to oldest by activity date.
@property(nonatomic, copy) NSString* collection;


//! Date of latest activity of the identifier that groups several activities.
@property(nonatomic, readonly, strong) NSDate* collectionUpdated;

//! Value describing the grouping style to be applied to this activity stream entry. Valid values are
// update - Each activity is presented as a separate update (default value)
// grouped - Activities are grouped by common generator (i.e. which app created this) and verb
// digest - Specialized format (Jive internal use only)
@property(nonatomic, copy) NSString* display;

//! Parent content object for this comment or message.
// Only present on Jive creation activities related to comments or messages.
@property(nonatomic, readonly, strong) JiveActivityObject* parent;

//! Flag indicating the inbox entry corresponding to this activity has been read.
// Only present on activities that correspond to inbox entries
@property(nonatomic, readonly) NSNumber *read;

//! Flag indicating the current state of an action. Valid values are:
// awaiting_action
// accepted
// rejected
// ignored
// hidden
//Only present on activities that correspond to actions, when accessed via GET /actions (REST) or osapi.jive.corev3.actions.get() (JavaScript)
@property(nonatomic, copy) NSString* state;

//! URI to update the read/unread state of the content object associated with this inbox entry. If the read field value is true, send a DELETE to this URI to mark it as unread. If the read field value is false, send a POST to this URI to mark it as read. Only present on activities that correspond to inbox entries
@property(nonatomic, readonly) NSURL* update;

@property(nonatomic, copy) NSURL *updateCollection;

@property(nonatomic) BOOL collectionRead;

@end
