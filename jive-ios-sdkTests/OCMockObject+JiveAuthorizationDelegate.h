//
//  OCMockObject+JiveAuthorizationDelegate.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "Jive.h"

@interface OCMockObject (JiveAuthorizationDelegate)

+ (id<JiveAuthorizationDelegate>) mockJiveAuthorizationDelegate;

+ (id<JiveAuthorizationDelegate>) mockJiveAuthorizationDelegateWithUsername:(NSString *)username
                                                                andPassword:(NSString *)password;

@end
