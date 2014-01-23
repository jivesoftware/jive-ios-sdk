//
//  JiveGenericPerson.h
//  jive-ios-sdk
//
//  Created by Janeen Neri on 1/15/14.
//
//    Copyright 2014 Jive Software Inc.
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
#import "JivePerson.h"

extern struct JiveGenericPersonAttributes {
    __unsafe_unretained NSString *email;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *person;
} const JiveGenericPersonAttributes;

//! \class JiveExtension
//! Used to describe authors that may or may not have Jive profiles, appears in external objects
@interface JiveGenericPerson : JiveObject

//! If the person doesn't have a profile on Jive, their email will be here
@property (nonatomic, readonly) NSString *email;

//! If the person doesn't have a profile on Jive, their display name will be here
@property (nonatomic, readonly) NSString *name;

//! If the person does have a profile on Jive, their info will be here
@property (nonatomic, readonly) JivePerson *person;

@end
