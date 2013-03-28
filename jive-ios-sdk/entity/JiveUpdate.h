//
//  JiveUpdate.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JiveContent.h"

extern struct JiveUpdateAttributes {
    __unsafe_unretained NSString *latitude;
    __unsafe_unretained NSString *longitude;
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
    __unsafe_unretained NSString *visibility;
} const JiveUpdateAttributes;

//! \class JiveUpdate
//! https://developers.jivesoftware.com/api/v3/rest/UpdateEntity.html
@interface JiveUpdate : JiveContent

//! If available, the latitude of the location from which this update was made.
@property(atomic, readonly, strong) NSNumber* latitude;

//! If available, the longitude of the location from which this update was made.
@property(atomic, readonly, strong) NSNumber* longitude;

//! Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

//! Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;

//! The visibility policy for new Status Updates. Not present for existing Status Updates. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility and parent are not specified.
// * place - place permissions specify which users can see the content. Default when visibility is not specified but parent is specified.
@property (nonatomic, strong) NSString *visibility;

@end
