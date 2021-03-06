//
//  JiveVote.h
//  jive-ios-sdk
//
//  Created by Ben Oberkfell on 7/24/14.
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

extern struct JiveVoteAttributes {
    __unsafe_unretained NSString *option;
    __unsafe_unretained NSString *count;

} const JiveVoteAttributes;

//! \class JiveVote
@interface JiveVote : JiveObject

//! Vote option NSString
@property (nonatomic, strong) NSString *option;

//! Vote count NSNumber
@property (nonatomic, strong) NSNumber *count;
@end
