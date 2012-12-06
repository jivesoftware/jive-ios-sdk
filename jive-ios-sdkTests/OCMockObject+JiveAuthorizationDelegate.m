//
//  OCMockObject+JiveAuthorizationDelegate.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "OCMockObject+JiveAuthorizationDelegate.h"

@implementation OCMockObject (JiveAuthorizationDelegate)

+ (id<JiveAuthorizationDelegate>) mockJiveAuthorizationDelegate {
    return [self mockJiveAuthorizationDelegateWithUsername:@"foo"
                                               andPassword:@"bar"];
}

+ (id<JiveAuthorizationDelegate>) mockJiveAuthorizationDelegateWithUsername:(NSString *)username
                                                                andPassword:(NSString *)password {
    id mockAuthorizationDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    
    [[[mockAuthorizationDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:username
                                                                                    password:password]] credentialsForJiveInstance:[OCMArg any]];
    
    return mockAuthorizationDelegate;
}

@end
