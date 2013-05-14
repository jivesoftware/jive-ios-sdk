//
//  JiveMobileAnalyticsHeader.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 5/6/13.
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

#import "JiveMobileAnalyticsHeader.h"
#import "NSData+JiveBase64.h"

@interface JiveMobileAnalyticsHeader()

@property (nonatomic) NSString *headerValue;

@end

@implementation JiveMobileAnalyticsHeader

- (id)initWithAppID:(NSString *)appID
         appVersion:(NSString *)appVersion
     connectionType:(NSString *)connectionType
     devicePlatform:(NSString *)devicePlatform
      deviceVersion:(NSString *)deviceVersion {
    
    if(!appVersion || [appVersion length] <= 0) {
        [NSException raise:@"JiveMobileAnalyticsHeader appVersion may not be nil or empty." format:nil];
    }
    if(!connectionType || [connectionType length] <= 0) {
        [NSException raise:@"JiveMobileAnalyticsHeader connectionType may not be nil or empty." format:nil];
    }
    if(!devicePlatform || [devicePlatform length] <= 0) {
        [NSException raise:@"JiveMobileAnalyticsHeader devicePlatform may not be nil or empty." format:nil];
    }
    if(!deviceVersion || [deviceVersion length] <= 0) {
        [NSException raise:@"JiveMobileAnalyticsHeader deviceVersion may not be nil or empty." format:nil];
    }
    
    if(self = [super init]) {
        NSMutableDictionary *headerDictionary = [[NSMutableDictionary alloc] init];
        
        [headerDictionary setValue:appID forKey:@"App-ID"];
        [headerDictionary setValue:appVersion forKey:@"App-Version"];
        
        NSMutableDictionary *appSpecDictionary = [[NSMutableDictionary alloc] init];
        [appSpecDictionary setValue:@"Native" forKey:@"requestOrigin"];
        [appSpecDictionary setValue:connectionType forKey:@"connectionType"];
        [appSpecDictionary setValue:devicePlatform forKey:@"devicePlatform"];
        [appSpecDictionary setValue:deviceVersion forKey:@"deviceVersion"];
        
        [headerDictionary setValue:appSpecDictionary forKey:@"App-Spec"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:headerDictionary options:0 error:nil];
        
        self.headerValue = [data jive_base64EncodedString:NO];
    }
    
    return self;
}

//! Apply the credentials to a request object.
- (void) applyToRequest:(NSMutableURLRequest*) request {
    [request setValue:self.headerValue forHTTPHeaderField:@"X-Jive-Client"];
}

@end
