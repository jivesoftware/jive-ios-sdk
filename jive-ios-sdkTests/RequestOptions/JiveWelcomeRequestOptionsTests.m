//
//  JiveWelcomeRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
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

#import "JiveWelcomeRequestOptionsTests.h"

@implementation JiveWelcomeRequestOptionsTests

- (JiveWelcomeRequestOptions *)welcomeOptions {
    
    return (JiveWelcomeRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveWelcomeRequestOptions alloc] init];
}

- (void)testWelcome {
    
    self.welcomeOptions.welcome = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"welcome=true", asString, @"Wrong string contents");
}

- (void)testWelcomeWithField {
    
    NSString *testField = @"name";
    
    [self.welcomeOptions addField:testField];
    self.welcomeOptions.welcome = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&welcome=true", asString, @"Wrong string contents");
}

@end
