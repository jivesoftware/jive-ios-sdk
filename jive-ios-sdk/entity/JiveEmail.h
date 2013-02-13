//
//  JiveEmail.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
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

@interface JiveEmail : JiveObject

// For primary emails the value must be "Email". To learn the list of email fields available in a Jive instance do a GET to /metadata/objects/emails. When using the Javascript API then execute metadata.getObjectMetadata("emails").
@property(nonatomic, copy) NSString* jive_label;

// A valid email address. Primary emails must be unique across the system.
@property(nonatomic, copy) NSString* value;

// Possible values are home, other or work.
@property(nonatomic, copy) NSString* type;

// True if this is the primary email address.
@property(nonatomic, readonly) bool primary;

@end
