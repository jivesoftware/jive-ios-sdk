//
//  OCMockObject+JiveAuthorizationDelegate.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
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

#import "OCMockObject+JiveAuthorizationDelegate.h"
#import "JiveHTTPBasicAuthCredentials.h"

@implementation OCMockObject (JiveAuthorizationDelegate)

+ (id<JiveAuthorizationDelegate>) mockJiveAuthorizationDelegate {
    return [self mockJiveAuthorizationDelegateWithUsername:@"foo"
                                               andPassword:@"bar"];
}

+ (id<JiveAuthorizationDelegate>) mockJiveAuthorizationDelegateWithUsername:(NSString *)username
                                                                andPassword:(NSString *)password {
    id mockAuthorizationDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    
    [[[mockAuthorizationDelegate stub] andReturn:[[JiveHTTPBasicAuthCredentials alloc] initWithUsername:username
                                                                                               password:password]] credentialsForJiveInstance:[OCMArg any]];
    
    return mockAuthorizationDelegate;
}

@end
