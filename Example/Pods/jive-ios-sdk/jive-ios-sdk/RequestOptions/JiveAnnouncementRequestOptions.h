//
//  JiveAnnouncementRequestOptions.h
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

#import "JivePagedRequestOptions.h"

//! \class JiveAnnouncementRequestOptions
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/AnnouncementService.html#getSystemAnnouncements(int,%20int,%20boolean,%20boolean,%20String)
@interface JiveAnnouncementRequestOptions : JivePagedRequestOptions

//! Flag indicating whether only active system announcements should be returned.
@property (nonatomic) BOOL activeOnly;

@end
