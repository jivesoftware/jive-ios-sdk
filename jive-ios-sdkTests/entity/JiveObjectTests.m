//
//  JiveObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveObjectTests.h"
#import "Jive_internal.h"

@implementation JiveObjectTests

@synthesize serverURL = _serverURL, apiPath = _apiPath;

- (void)setServerURL:(NSURL *)testURL {
    if (!_serverURL || ![_serverURL isEqual:testURL]) {
        _serverURL = testURL;
        if (self.instance) {
            [self.instance.platformVersion setValue:testURL
                                             forKey:JivePlatformVersionAttributes.instanceURL];
        }
    }
}

- (NSURL *)serverURL {
    if (!_serverURL) {
        _serverURL = [NSURL URLWithString:@"http://dummy.com/"];
    }
    
    return _serverURL;
}

- (void)setApiPath:(NSString *)apiPath {
    if (!_apiPath || ![_apiPath isEqual:apiPath]) {
        _apiPath = apiPath;
        if (self.instance) {
            [self.instance.platformVersion.coreURI[0] setValue:apiPath
                                                        forKey:JiveCoreVersionAttributes.uri];
        }
    }
}

- (NSString *)apiPath {
    if (!_apiPath) {
        _apiPath = @"api/core/v3";
    }
    
    return _apiPath;
}

- (void)setUp {
    JivePlatformVersion *platformVersion = [JivePlatformVersion new];
    JiveCoreVersion *coreVersion = [JiveCoreVersion new];
    
    self.instance = [[Jive alloc] initWithJiveInstance:self.serverURL
                                 authorizationDelegate:self];
    self.object = [JiveObject new];
    
    [coreVersion setValue:self.apiPath forKey:JiveCoreVersionAttributes.uri];
    [coreVersion setValue:@3 forKey:JiveCoreVersionAttributes.version];
    [platformVersion setValue:@[coreVersion] forKey:JivePlatformVersionAttributes.coreURI];
    [platformVersion setValue:self.serverURL forKey:JivePlatformVersionAttributes.instanceURL];
    self.instance.platformVersion = platformVersion;
}

- (void)tearDown {
    self.object = nil;
    self.instance = nil;
}

- (id<JiveCredentials>)credentialsForJiveInstance:(NSURL *)url {
    return nil;
}

- (JiveMobileAnalyticsHeader *)mobileAnalyticsHeaderForJiveInstance:(NSURL *)url {
    return nil;
}

- (void)testDeserialize_emptyJSON {
    NSDictionary *JSON = @{};
    
    STAssertFalse([self.object deserialize:JSON fromInstance:self.instance], @"Reported valid deserialize with empty JSON");
    STAssertFalse(self.object.extraFieldsDetected, @"Reported extra fields with empty JSON");
    STAssertNil(self.object.refreshDate, @"Invalid refresh date entered for empty JSON");
}

- (void)testDeserialize_invalidJSON {
    NSDictionary *JSON = @{@"dummy key":@"bad value"};
    
    STAssertFalse([self.object deserialize:JSON fromInstance:self.instance], @"Reported valid deserialize with wrong JSON");
    STAssertTrue(self.object.extraFieldsDetected, @"No extra fields reported with wrong JSON");
    STAssertNil(self.object.refreshDate, @"Invalid refresh date entered for empty JSON");
}

@end
