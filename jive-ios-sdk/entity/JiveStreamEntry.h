//
//  JiveStream.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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
#import "JivePerson.h"
#import "JiveContentBody.h"
#import "JiveSummary.h"

extern struct JiveStreamEntryAttributes {
    __unsafe_unretained NSString *verb;
    
    // Deprecated attribute names. Please use the JiveContentAttribute names.
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveStreamEntryAttributes;

//! \class JiveStreamEntry
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/StreamEntryEntity.html
@interface JiveStreamEntry : JiveContent

//! The verb provided by the Jive App that created this entry.
@property(nonatomic, readonly, strong) NSString *verb;

@end
