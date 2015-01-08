//
//  JiveTargetList.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/15/13.
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

#import "JivePerson.h"

//! \class JiveTargetList
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/DirectMessageService.html#createDirectMessage(String,%20boolean,%20String)
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/InviteService.html#createInvites(String,%20String,%20String)
@interface JiveTargetList : NSObject {
    NSMutableArray *personURIs;
    NSMutableArray *alternateIdentifiers;
}

//! Method to add a person object to the target list.
- (void)addPerson:(JivePerson *)person;
//! Method to add a person's email address to the target list. Not valid for direct messages.
- (void)addEmailAddress:(NSString *)emailAddress;
//! Method to add a person's user name to the target list. Not valid for direct messages.
- (void)addUserName:(NSString *)userName;
//! Method to add a person's URI to the target list.
- (void)addPersonURI:(NSString *)uri;

@end
