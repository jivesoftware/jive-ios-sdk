//
//  JiveCredentials.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/2/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _JiveAuthentication {
    JiveAuthenticationBasic,
    JiveAuthenticationOAuth,
    JiveAuthenticationSSO
} JiveAuthentication;

@interface JiveCredentials : NSObject

- (id) initWithUserName:(NSString*) username password:(NSString*) password;
- (id) initWithOAuthToken:(NSString*) token;

- (void) applyToRequest:(NSMutableURLRequest*) request;

@end
