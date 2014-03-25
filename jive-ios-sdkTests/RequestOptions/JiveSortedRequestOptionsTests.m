//
//  JiveSortedRequestOptionsTests.m
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

#import "JiveSortedRequestOptionsTests.h"

@implementation JiveSortedRequestOptionsTests

- (JiveSortedRequestOptions *)sortedOptions {

    return (JiveSortedRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSortedRequestOptions alloc] init];
}

- (void)testSort {
    
    self.sortedOptions.sort = JiveSortOrderDefault;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");
    
    self.sortedOptions.sort = JiveSortOrderDateCreatedDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateCreatedDesc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateCreatedAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateCreatedAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLatestActivityDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=latestActivityDesc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLatestActivityAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=latestActivityAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderTitleAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=titleAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderFirstNameAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=firstNameAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLastNameAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=lastNameAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateJoinedDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateJoinedDesc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateJoinedAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateJoinedAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderStatusLevelDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=statusLevelDesc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderRelevanceDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=relevanceDesc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderUpdatedAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=updatedAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderUpdatedDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=updatedDesc", asString, @"Wrong string contents");
}

- (void)testSortWithField {
    
    NSString *testField = @"name";
    [self.pageOptions addField:testField];
    self.sortedOptions.sort = JiveSortOrderDateCreatedAsc;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&sort=dateCreatedAsc", asString, @"Wrong string contents");
}

- (void)testInvalidSort {
    
    self.sortedOptions.sort = (enum JiveSortOrder)-1;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");
    
    self.sortedOptions.sort = (enum JiveSortOrder)5000;
    asString = [self.options toQueryString];
    STAssertNil(asString, @"Invalid string returned");
}

@end
