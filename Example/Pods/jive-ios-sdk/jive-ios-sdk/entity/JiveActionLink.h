//
//  JiveActionLink.h
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

//! \class JiveActionLink
//! https://developers.jivesoftware.com/api/v3/rest/ActionLinkEntity.html
@interface JiveActionLink : JiveObject

//! Hint that MAY be used by the presentation layer to allow interaction with the user (for example, the label text for a button).
@property(nonatomic, copy) NSString* caption;

//! HTTP operation to perform against the actionable resource. Should be one of GET, PUT, POST, DELETE, or other standard HTTP verb. If not present, defaults to GET.
@property(nonatomic, copy) NSString* httpVerb;

//! URI representing the target web hook endpoint to be invoked with the specified HTTP verb.
@property(nonatomic, copy) NSURL *target;

@end
