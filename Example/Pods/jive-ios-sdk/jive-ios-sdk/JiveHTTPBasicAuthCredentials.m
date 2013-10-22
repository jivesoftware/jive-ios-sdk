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
#import "NSData+JiveBase64.h"

@interface JiveHTTPBasicAuthCredentials()

@property (nonatomic) NSString *authorizationHeaderValue;

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
        NSData* data = [[NSString stringWithFormat:@"%@:%@", username, password]
                        dataUsingEncoding:NSUTF8StringEncoding];
        self.authorizationHeaderValue = [NSString stringWithFormat:@"Basic %@",
                                         [data jive_base64EncodedString:NO]];
    }
    
    return self;
}

#pragma mark - JiveCredentials

- (void) applyToRequest:(NSMutableURLRequest*) request {
    [request setValue:self.authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
}

@end
