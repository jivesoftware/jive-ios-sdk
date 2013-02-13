//
//  JiveGroup.h
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
#import "JivePerson.h"

@interface JiveGroup : JivePlace

// Person that created this social group.
@property(nonatomic, readonly, strong) JivePerson* creator;

// Membership and visibility type of this group (OPEN, MEMBER_ONLY, PRIVATE, SECRET).
@property(nonatomic, copy) NSString* groupType;

// Number of people that are members of this group.
@property(nonatomic, readonly, strong) NSNumber* memberCount;

// Tags associated with this object. String[]
@property(nonatomic, readonly, strong) NSArray* tags;

@end
