//
//  JiveOpenSocial.h
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

@class JiveEmbedded;

//! \class JiveOpenSocial
//! https://developers.jivesoftware.com/api/v3/rest/OpenSocialEntity.html
@interface JiveOpenSocial : JiveObject

//! List of ActionLinks representing actions that a person might take against an actionable resource.
@property(nonatomic, readonly, strong) NSArray* actionLinks;

//! List of URIs of Persons to which this activity should be explicitly delivered.
@property(nonatomic, readonly, strong) NSArray* deliverTo;

//! Metadata about an OpenSocial Embedded Experience associated with this activity.
@property(nonatomic, readonly, strong) JiveEmbedded* embed;

@end
