//
//  JiveSearchContentsRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
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

#import "JiveSearchContentsRequestOptionsTests.h"

@implementation JiveSearchContentsRequestOptionsTests

- (JiveSearchContentsRequestOptions *)contentsOptions {
    
    return (JiveSearchContentsRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSearchContentsRequestOptions alloc] init];
}

- (void)testSubjectOnly {
    
    self.contentsOptions.subjectOnly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=subjectonly", asString, @"Wrong string contents");
}

- (void)testSubjectOnlyWithOtherFields {
    
    [self.contentsOptions addField:@"name"];
    self.contentsOptions.subjectOnly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=subjectonly", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=subjectonly", asString, @"Wrong string contents");
    
    [self.contentsOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(share)&filter=subjectonly", asString, @"Wrong string contents");
}

- (void)testAfter {
    
    self.contentsOptions.after = [NSDate dateWithTimeIntervalSince1970:0];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=after(1970-01-01T00:00:00.000+0000)", asString, @"Wrong string contents");
    
    self.contentsOptions.after = [NSDate dateWithTimeIntervalSince1970:1000];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=after(1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
}

- (void)testAfterWithField {
    
    self.contentsOptions.after = [NSDate dateWithTimeIntervalSince1970:0];
    [self.contentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=after(1970-01-01T00:00:00.000+0000)", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=after(1970-01-01T00:00:00.000+0000)", asString, @"Wrong string contents");
    
    self.contentsOptions.subjectOnly = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=subjectonly&filter=after(1970-01-01T00:00:00.000+0000)", asString, @"Wrong string contents");
}

- (void)testBefore {
    
    self.contentsOptions.before = [NSDate dateWithTimeIntervalSince1970:0];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=before(1970-01-01T00:00:00.000+0000)", asString, @"Wrong string contents");
    
    self.contentsOptions.before = [NSDate dateWithTimeIntervalSince1970:1000];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=before(1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
}

- (void)testBeforeWithField {
    
    self.contentsOptions.before = [NSDate dateWithTimeIntervalSince1970:1000];
    [self.contentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=before(1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=before(1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
    
    self.contentsOptions.subjectOnly = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=subjectonly&filter=before(1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
    
    self.contentsOptions.after = [NSDate dateWithTimeIntervalSince1970:0];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=subjectonly&filter=after(1970-01-01T00:00:00.000+0000)&filter=before(1970-01-01T00:16:40.000+0000)", asString, @"Wrong string contents");
}

- (void)testAuthorURL {
    
    self.contentsOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=author(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    self.contentsOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
}

- (void)testAuthorURLWithOtherOptions {
    
    self.contentsOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    [self.contentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
    
    [self.contentsOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
    
    self.contentsOptions.subjectOnly = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=subjectonly&filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
}

- (void)testAuthorURLIgnoredWithAuthorID {
    
    self.contentsOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=author(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    self.contentsOptions.authorID = @"54321";
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=author(/people/54321)", asString, @"Wrong string contents");
}

- (void)testAuthorIDWithOtherOptions {
    
    self.contentsOptions.authorID = @"54321";
    [self.contentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=author(/people/54321)", asString, @"Wrong string contents");
    
    [self.contentsOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=author(/people/54321)", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=author(/people/54321)", asString, @"Wrong string contents");
    
    self.contentsOptions.subjectOnly = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=subjectonly&filter=author(/people/54321)", asString, @"Wrong string contents");
}

- (void)testMoreLikeContentID {
    
    self.contentsOptions.moreLikeContentID = @"1005";
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=morelike(/content/1005)", asString, @"Wrong string contents");
    
    self.contentsOptions.moreLikeContentID = @"54321";
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=morelike(/content/54321)", asString, @"Wrong string contents");
}

- (void)testMoreLikeContentIDWithOtherOptions {
    
    self.contentsOptions.moreLikeContentID = @"54321";
    [self.contentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=morelike(/content/54321)", asString, @"Wrong string contents");
    
    [self.contentsOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=morelike(/content/54321)", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=morelike(/content/54321)", asString, @"Wrong string contents");
    
    self.contentsOptions.subjectOnly = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=subjectonly&filter=morelike(/content/54321)", asString, @"Wrong string contents");
    
    self.contentsOptions.authorID = @"54321";
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=subjectonly&filter=author(/people/54321)&filter=morelike(/content/54321)", asString, @"Wrong string contents");
}

- (void)testPlaceID {
    
    [self.contentsOptions addPlaceID:@"1005"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=place(/places/1005)", asString, @"Wrong string contents");
    
    [self.contentsOptions addPlaceID:@"54321"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=place(/places/1005,/places/54321)", asString, @"Wrong string contents");
}

- (void)testPlaceURL {
    
    [self.contentsOptions addPlaceURL:[NSURL URLWithString:@"http://dummy.com/places/1005"]];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=place(http://dummy.com/places/1005)", asString, @"Wrong string contents");
    
    [self.contentsOptions addPlaceURL:[NSURL URLWithString:@"http://dummy.com/places/54321"]];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=place(http://dummy.com/places/1005,http://dummy.com/places/54321)", asString, @"Wrong string contents");

    [self.contentsOptions addPlaceID:@"12345"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=place(http://dummy.com/places/1005,http://dummy.com/places/54321,/places/12345)", asString, @"Wrong string contents");
}

- (void)testPlaceIDWithOtherOptions {
    
    [self.contentsOptions addPlaceID:@"1005"];
    [self.contentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=place(/places/1005)", asString, @"Wrong string contents");
    
    [self.contentsOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=place(/places/1005)", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=place(/places/1005)", asString, @"Wrong string contents");
    
    self.contentsOptions.subjectOnly = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=subjectonly&filter=place(/places/1005)", asString, @"Wrong string contents");
    
    self.contentsOptions.authorID = @"54321";
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=subjectonly&filter=author(/people/54321)&filter=place(/places/1005)", asString, @"Wrong string contents");
    
    self.contentsOptions.moreLikeContentID = @"12345";
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=type(dm)&filter=subjectonly&filter=author(/people/54321)&filter=morelike(/content/12345)&filter=place(/places/1005)", asString, @"Wrong string contents");
}

@end
