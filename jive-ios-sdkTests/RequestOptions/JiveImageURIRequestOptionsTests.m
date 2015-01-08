//
//  JiveImageURIRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
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

#import "JiveImageURIRequestOptionsTests.h"

@implementation JiveImageURIRequestOptionsTests

@synthesize options;

- (void)setUp {
    
    options = [[JiveImageURIRequestOptions alloc] init];
}

- (void)tearDown {
    
    options = nil;
}

- (void)testURI {
    
    options.uri = [NSURL URLWithString:@"http://dummy_uri"];
    
    NSString *asString = [options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"uri=http://dummy_uri", asString, @"Wrong string contents");
}

- (void)testAlternateURI {
    
    options.uri = [NSURL URLWithString:@"http://alternate/address"];
    
    NSString *asString = [options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"uri=http://alternate/address", asString, @"Wrong string contents");
}

@end
