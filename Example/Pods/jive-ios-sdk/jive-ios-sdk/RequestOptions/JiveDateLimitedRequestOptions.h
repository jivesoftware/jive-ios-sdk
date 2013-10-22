//
//  JiveDateLimitedRequestOptions.h
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

#import "JiveCountRequestOptions.h"

//! \class JiveDateLimitedRequestOptions
//! Part of many request options, such as:
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getActivity(String,%20String,%20int,%20String)
@interface JiveDateLimitedRequestOptions : JiveCountRequestOptions

//! Date and time representing the minimum "last activity in a collection" timestamp for selecting activities (cannot specify both after and before)
@property (nonatomic, strong) NSDate *after;
//! Date and time representing the maxium "last activity in a collection" timestamp for selecting activities (cannot specify both after and before)
@property (nonatomic, strong) NSDate *before;

@end
