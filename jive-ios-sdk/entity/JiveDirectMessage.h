//
//  JiveDirectMessage.h
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

extern NSString * const JiveDirectMessageType;

extern struct JiveDirectMessageAttributes {
    __unsafe_unretained NSString *participants;
    __unsafe_unretained NSString *typeActual;
    
    // Deprecated attribute names. Please use the JiveContentAttribute names.
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveDirectMessageAttributes;

//! \class JiveDirectMessage
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/DirectMessageEntity.html
@interface JiveDirectMessage : JiveContent

//! The people to whom this direct message was sent. JivePerson[]
@property (nonatomic, readonly, strong) NSArray *participants;

@property (nonatomic, readonly, copy) NSString *typeActual;

@end
