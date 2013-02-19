//
//  JiveWelcomeRequestOptions.h
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

#import "JiveReturnFieldsRequestOptions.h"

//! \class JiveWelcomeRequestOptions
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createPerson(PersonEntity,%20Boolean,%20String)
@interface JiveWelcomeRequestOptions : JiveReturnFieldsRequestOptions

//! Flag indicating that a welcome email should be sent to the newly created user (since 3.2)
@property (nonatomic) BOOL welcome;

@end
