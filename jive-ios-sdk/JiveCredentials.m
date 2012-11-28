//
//  JiveCredentials.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/2/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveCredentials.h"
#import "NSData+JiveBase64.h"

@interface JiveCredentials() {
@private
    JiveAuthentication _authType;
    __strong NSString* _header;
}

@end

@implementation JiveCredentials


- (id) initWithUserName:(NSString*) username password:(NSString*) password {
    
    if(!username || [username length] <= 0) {
        [NSException raise:@"JiveCredentials username may not be nil or empty." format:nil];
    }
    
    if(!password || [password length] <= 0) {
        [NSException raise:@"JiveCredentials password may not be nil or empty." format:nil];
    }
    
    if(self = [super init]) {
        NSData* data = [[NSString stringWithFormat:@"%@:%@", username, password]
                        dataUsingEncoding:NSUTF8StringEncoding];
        _header = [NSString stringWithFormat:@"Basic %@", [data jive_base64EncodedString]];
    }
    
    return self;
}


- (id) initWithActivationCode:(NSString*) code {
   
    
    
    return nil;
}

- (void) applyToRequest:(NSMutableURLRequest*) request {
    
    if(_authType == JiveAuthenticationBasic) {
        [request setValue:_header forHTTPHeaderField:@"Authorization"];
    } else {
        
    }
}

@end
