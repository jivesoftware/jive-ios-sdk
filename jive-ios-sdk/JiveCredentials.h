//
//  JiveCredentials.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/2/12.
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

#import <Foundation/Foundation.h>

typedef enum _JiveAuthentication {
    JiveAuthenticationBasic,
    JiveAuthenticationOAuth,
    JiveAuthenticationSSO
} JiveAuthentication;

//! \class JiveCredentials
@interface JiveCredentials : NSObject

//! Initialize the credentials object with a username and password.
- (id) initWithUserName:(NSString*) username password:(NSString*) password;

//! Apply the credentials to a request object.
- (void) applyToRequest:(NSMutableURLRequest*) request;

@end
