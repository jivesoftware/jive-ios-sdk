//
//  JiveOutcomeType.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
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

extern struct JiveOutcomeTypeAttributes {
    __unsafe_unretained NSString *fields;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *resources;
} const JiveOutcomeTypeAttributes;

//! \class JvieOutcomeType
//! https://developers.jivesoftware.com/api/v3/rest/OutcomeTypeEntity.html
@interface JiveOutcomeType : JiveObject

//! Metadata about the fields that may be present in the JSON representation of this object type.
@property (nonatomic, readonly, strong) NSArray *fields;

//! The unique identifier of this outcome type.
@property (nonatomic, readonly, strong) NSString *jiveId;

//! The name of this outcome type.
@property (nonatomic, readonly, strong) NSString *name;

//! Resource links (and related permissions for the requesting person) relevant to this object.
@property (nonatomic, readonly, strong) NSDictionary *resources;

@end
