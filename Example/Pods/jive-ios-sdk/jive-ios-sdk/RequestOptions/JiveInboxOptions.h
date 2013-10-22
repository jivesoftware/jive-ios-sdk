//
//  JiveInboxOptions.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
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

#import "JiveDateLimitedRequestOptions.h"

//! Inbox content type for including acclaim when filtering on content type.
extern NSString * const JiveAcclaimInboxType;

//! \class JiveInboxOptions
//! https://developers.jivesoftware.com/api/v3/rest/InboxService.html#getActivity(String,%20String,%20int,%20List<String>,%20String)
@interface JiveInboxOptions : JiveDateLimitedRequestOptions

//! Indicates if only unread entries should be returned.
@property (nonatomic) BOOL unread;
//! Select entries authored by the specified person, identified by authorID. Mutually exclusive with authorURL.
@property (nonatomic, strong) NSString *authorID;
//! Select entries authored by the specified person, identified by URL. Mutually exclusive with authorID.
@property (nonatomic, strong) NSURL *authorURL;
//! Select entries of the specified type. One or more types can be specified.
@property (nonatomic, strong) NSArray *types;

//! Helper method to simplify adding a type to the types array.
- (void)addType:(NSString *)type;

@end
