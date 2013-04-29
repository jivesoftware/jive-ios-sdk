//
//  JiveSpace.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
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

#import "JivePlace.h"

extern struct JiveSpaceAttributes {
    __unsafe_unretained NSString *childCount;
    __unsafe_unretained NSString *locale;
    __unsafe_unretained NSString *tags;
} const JiveSpaceAttributes;

//! \class JiveSpace
//! https://developers.jivesoftware.com/api/v3/rest/SpaceEntity.html
@interface JiveSpace : JivePlace

//! Number of spaces that are direct children of this space.
@property(nonatomic, readonly, strong) NSNumber* childCount;

//! Locale string of the space.
@property (nonatomic, copy) NSString *locale;

//! Tags associated with this object. String[]
@property(nonatomic, strong) NSArray* tags;

@end
