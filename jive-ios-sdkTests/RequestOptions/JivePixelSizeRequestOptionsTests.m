//
//  JivePixelSizeRequestOptionsTests.m
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

#import "JivePixelSizeRequestOptionsTests.h"

@implementation JivePixelSizeRequestOptionsTests

@synthesize options;

- (void)setUp {
    
    options = [[JivePixelSizeRequestOptions alloc] init];
}

- (void)tearDown {
    
    options = nil;
}

- (void)testNoFields {
    
    NSString *asString = [options toQueryString];
    
    STAssertNil(asString, @"Valid string returned");
}

- (void)testSize {
    
    int value = 5;
    
    self.options.size = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"size=5", asString, @"Wrong string contents");
    
    value = 7;
    self.options.size = value;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"size=7", asString, @"Wrong string contents");
}

@end
