//
//  JiveReturnFieldsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
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

#import "JiveRequestOptions.h"

//! \class JiveReturnFieldsRequestOptions
//! Part of many request options, such as:
//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#getAnnouncement(String,%20String)
@interface JiveReturnFieldsRequestOptions : NSObject<JiveRequestOptions>

//! Fields to be returned
@property (nonatomic, strong) NSArray *fields;

//! Helper method to add a field to the fields array.
- (void)addField:(NSString *)newField;

// Internal helper method.
- (NSString *)toQueryString;

@end
