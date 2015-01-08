//
//  JiveAnnouncementRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
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

#import "JiveAnnouncementRequestOptionsTests.h"

@implementation JiveAnnouncementRequestOptionsTests

- (JiveAnnouncementRequestOptions *)announcementOptions {
    
    return (JiveAnnouncementRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveAnnouncementRequestOptions alloc] init];
}

- (void)testCollapse {
    
    self.announcementOptions.activeOnly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"activeOnly", asString, @"Wrong string contents");
}

- (void)testCollapseWithOtherFields {
    
    [self.announcementOptions addField:@"name"];
    self.announcementOptions.activeOnly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&activeOnly", asString, @"Wrong string contents");
    
    self.announcementOptions.startIndex = 5;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&startIndex=5&activeOnly", asString, @"Wrong string contents");
}

@end
