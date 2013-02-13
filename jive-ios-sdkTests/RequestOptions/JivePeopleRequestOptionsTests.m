//
//  JivePeopleRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
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

#import "JivePeopleRequestOptionsTests.h"

@implementation JivePeopleRequestOptionsTests

- (JivePeopleRequestOptions *)peopleOptions {
    
    return (JivePeopleRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JivePeopleRequestOptions alloc] init];
}

- (void)testTitle {
    self.peopleOptions.title = @"Head Honcho";
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=title(Head%20Honcho)", asString, @"Wrong string contents");
    
    self.peopleOptions.title = @"grunt";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=title(grunt)", asString, @"Wrong string contents");
}

- (void)testTitleWithFields {
    
    self.peopleOptions.title = @"Head Honcho";
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=title(Head%20Honcho)", asString, @"Wrong string contents");

    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=title(Head%20Honcho)", asString, @"Wrong string contents");
}

- (void)testDepartment {
    
    self.peopleOptions.department = @"Engineering";
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=department(Engineering)", asString, @"Wrong string contents");
    
    self.peopleOptions.department = @"Human Resources";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=department(Human%20Resources)", asString, @"Wrong string contents");
}

- (void)testDepartmentWithFields {
    
    self.peopleOptions.department = @"Engineering";
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=department(Engineering)", asString, @"Wrong string contents");
    
    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=department(Engineering)", asString, @"Wrong string contents");
    
    self.peopleOptions.title = @"Head Honcho";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=title(Head%20Honcho)&filter=department(Engineering)", asString, @"Wrong string contents");
}

- (void)testLocation {
    
    self.peopleOptions.location = @"Portland";
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=location(Portland)", asString, @"Wrong string contents");
    
    self.peopleOptions.location = @"Boulder, CO";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=location(Boulder%2C%20CO)", asString, @"Wrong string contents");
}

- (void)testLocationWithFields {
    
    self.peopleOptions.location = @"Portland";
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=location(Portland)", asString, @"Wrong string contents");
    
    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=location(Portland)", asString, @"Wrong string contents");
    
    self.peopleOptions.department = @"Engineering";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=department(Engineering)&filter=location(Portland)", asString, @"Wrong string contents");
}

- (void)testCompany {
    
    self.peopleOptions.company = @"Jive";
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=company(Jive)", asString, @"Wrong string contents");
    
    self.peopleOptions.company = @"American Express";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=company(American%20Express)", asString, @"Wrong string contents");
}

- (void)testCompanyWithFields {
    
    self.peopleOptions.company = @"Jive";
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=company(Jive)", asString, @"Wrong string contents");
    
    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=company(Jive)", asString, @"Wrong string contents");
    
    self.peopleOptions.location = @"Portland";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=location(Portland)&filter=company(Jive)", asString, @"Wrong string contents");
}

- (void)testOffice {
    
    self.peopleOptions.office = @"PDX";
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=office(PDX)", asString, @"Wrong string contents");
    
    self.peopleOptions.office = @"Jiverado$";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=office(Jiverado%24)", asString, @"Wrong string contents");
}

- (void)testOfficeWithFields {
    
    self.peopleOptions.office = @"PDX";
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=office(PDX)", asString, @"Wrong string contents");
    
    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=office(PDX)", asString, @"Wrong string contents");
    
    self.peopleOptions.company = @"Jive";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=company(Jive)&filter=office(PDX)", asString, @"Wrong string contents");
}

- (void)testDateRange {
    
    [self.peopleOptions setHireDateBetween:[NSDate dateWithTimeIntervalSince1970:0]
                                       and:[NSDate dateWithTimeIntervalSince1970:1000]];
   
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=hire-date(1970-01-01T00:00:00.000+0000,1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");

    [self.peopleOptions setHireDateBetween:[NSDate dateWithTimeIntervalSince1970:1001]
                                       and:[NSDate dateWithTimeIntervalSince1970:1000]];
    asString = [self.options toQueryString];
    STAssertNil(asString, @"Invalid string returned");
    
    [self.peopleOptions setHireDateBetween:nil
                                       and:[NSDate dateWithTimeIntervalSince1970:1000]];
    asString = [self.options toQueryString];
    STAssertNil(asString, @"Invalid string returned");
}

- (void)testDateRangeWithFields {
    
    [self.peopleOptions setHireDateBetween:[NSDate dateWithTimeIntervalSince1970:0]
                                       and:[NSDate dateWithTimeIntervalSince1970:1000]];
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=hire-date(1970-01-01T00:00:00.000+0000,1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
    
    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=hire-date(1970-01-01T00:00:00.000+0000,1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
    
    self.peopleOptions.office = @"PDX";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&filter=office(PDX)&filter=hire-date(1970-01-01T00:00:00.000+0000,1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
}

- (void)testIDs {
    
    [self.peopleOptions addID:@"1005"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"ids=1005", asString, @"Wrong string contents");
    
    [self.peopleOptions addID:@"54321"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"ids=1005,54321", asString, @"Wrong string contents");
}

- (void)testIDsWithOtherOptions {
    
    [self.peopleOptions addID:@"1005"];
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&ids=1005", asString, @"Wrong string contents");
    
    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&ids=1005", asString, @"Wrong string contents");
}

- (void)testQuery {
    
    self.peopleOptions.query = @"search term";
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"query=search%20term", asString, @"Wrong string contents");
    
    self.peopleOptions.query = @"alternate search";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"query=alternate%20search", asString, @"Wrong string contents");
}

- (void)testQueryWithFields {
    
    self.peopleOptions.query = @"search term";
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&query=search%20term", asString, @"Wrong string contents");
    
    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&query=search%20term", asString, @"Wrong string contents");
    
    [self.peopleOptions addID:@"1005"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)&ids=1005&query=search%20term", asString, @"Wrong string contents");
}

@end
