//
//  JiveDefinedSizeRequestOptionsTests.m
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

#import "JiveDefinedSizeRequestOptionsTests.h"

@implementation JiveDefinedSizeRequestOptionsTests

- (void)setUp {
    
    self.options = [[JiveDefinedSizeRequestOptions alloc] init];
}

- (void)tearDown {
    
    self.options = nil;
}

- (void)testSize {
    
    self.options.size = JiveImageSizeOptionLargeImage;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");
    
    self.options.size = JiveImageSizeOptionMediumImage;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"size=medium", asString, @"Wrong string contents");
    
    self.options.size = JiveImageSizeOptionSmallImage;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"size=small", asString, @"Wrong string contents");
}

- (void)testInvalidSize {
    
    self.options.size = (enum JiveImageSizeOption)-1;

    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");

    self.options.size = (enum JiveImageSizeOption)5000;
    asString = [self.options toQueryString];
    STAssertNil(asString, @"Invalid string returned");
}

@end
