//
//  JiveCoreVersion.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/11/13.
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

extern struct JiveCoreVersionAttributes {
    __unsafe_unretained NSString *version;
    __unsafe_unretained NSString *revision;
    __unsafe_unretained NSString *uri;
    __unsafe_unretained NSString *documentation;
} const JiveCoreVersionAttributes;

//! \class JiveCoreVersion
//! REST api version information
@interface JiveCoreVersion : JiveObject

//! REST api major version. This SDK works with version 3.
@property (nonatomic, readonly) NSNumber *version;

//! REST api minor version. This SDK may check this value for feature availablity.
@property (nonatomic, readonly) NSNumber *revision;

//! Relative path for all REST api calls.
@property (nonatomic, readonly) NSString *uri;

//! REST api documentation.
@property (nonatomic, readonly) NSURL *documentation;

@end
