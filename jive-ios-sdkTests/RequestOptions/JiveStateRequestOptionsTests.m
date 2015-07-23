//
//  JiveStateRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
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

#import "JiveStateRequestOptionsTests.h"

@implementation JiveStateRequestOptionsTests

- (JiveStateRequestOptions *)stateOptions {
    
    return (JiveStateRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveStateRequestOptions alloc] init];
}

- (void)testState {
    
    [self.stateOptions addState:@"owner"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"state=owner", asString, @"Wrong string contents");
    
    [self.stateOptions addState:@"banned"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"state=owner&state=banned", asString, @"Wrong string contents");
}

- (void)testStateWithFields {
    
    [self.stateOptions addState:@"owner"];
    [self.stateOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&state=owner", asString, @"Wrong string contents");
}

@end
