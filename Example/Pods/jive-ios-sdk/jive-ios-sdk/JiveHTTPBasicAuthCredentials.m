//
//  JiveHTTPBasicAuthCredentials.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 4/30/13.
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

#import "JiveHTTPBasicAuthCredentials.h"
static NSString * const JiveBasicAuthCredentialsUsername = @"JiveBasicAuthCredentialsUsername";
static NSString * const JiveBasicAuthCredentialsPassword = @"JiveBasicAuthCredentialsPassword";
static NSString * const JiveBasicAuthCredentialsAuthorizationHeaderValue = @"JiveBasicAuthCredentialsAuthorizationHeaderValue";


@interface JiveHTTPBasicAuthCredentials()

@property (nonatomic) NSString *authorizationHeaderValue;
@property (nonatomic, strong, readwrite) NSString *username;
@property (nonatomic, strong, readwrite) NSString *password;
@end

@implementation JiveHTTPBasicAuthCredentials

#pragma mark - init/dealloc

- (id)initWithUsername:(NSString *)username
              password:(NSString *)password {
    
    if(!username || [username length] <= 0) {
        [NSException raise:@"JiveCredentials username may not be nil or empty." format:nil];
    }
    
    if(!password || [password length] <= 0) {
        [NSException raise:@"JiveCredentials password may not be nil or empty." format:nil];
    }
    
    if(self = [super init]) {
        self.username = username;
        self.password = password;
        NSData* data = [[NSString stringWithFormat:@"%@:%@", username, password]
                        dataUsingEncoding:NSUTF8StringEncoding];
        self.authorizationHeaderValue = [NSString stringWithFormat:@"Basic %@",
                                         [data base64EncodedStringWithOptions:0]];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _username = [coder decodeObjectForKey:JiveBasicAuthCredentialsUsername];
        _password = [coder decodeObjectForKey:JiveBasicAuthCredentialsPassword];
        _authorizationHeaderValue = [coder decodeObjectForKey:JiveBasicAuthCredentialsAuthorizationHeaderValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.username forKey:JiveBasicAuthCredentialsUsername];
    [coder encodeObject:self.password forKey:JiveBasicAuthCredentialsPassword];
    [coder encodeObject:self.authorizationHeaderValue forKey:JiveBasicAuthCredentialsAuthorizationHeaderValue];
}

#pragma mark - JiveCredentials

- (void) applyToRequest:(NSMutableURLRequest*) request {
    [request setValue:self.authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
}

@end
