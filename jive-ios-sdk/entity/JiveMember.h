//
//  JiveMember.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
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

#import "JiveTypedObject.h"
#import "JiveGroup.h"
#import "JivePerson.h"


extern struct JiveMemberState {
    __unsafe_unretained NSString *banned;
    __unsafe_unretained NSString *invited;
    __unsafe_unretained NSString *member;
    __unsafe_unretained NSString *owner;
    __unsafe_unretained NSString *pending;
} const JiveMemberState;


//! \class JiveMember
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/MemberEntity.html
@interface JiveMember : JiveTypedObject

//! Group to which this member belongs.
@property (nonatomic, readonly, strong) JiveGroup *group;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, strong) NSString* jiveId;

//! Jive person that is a member of the specified group.
@property(nonatomic, readonly, strong) JivePerson *person;

//! Date and time when this content object was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

//! Current state of this membership.
// * banned - Previously accepted member has been banned from further involvement.
// * invited - Person has been invited but has not yet accepted the invitation.
// * member - Current member with standard permissions.
// * owner - Current member with place owner permissions.
// * pending - Person has requested membership but has not yet been accepted.
@property(nonatomic, strong) NSString* state;

//! Date and time this content object was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

@end
