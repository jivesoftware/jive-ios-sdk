//
//  JiveAnnouncementTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/27/12.
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

#import "JiveAnnouncementTests.h"

@implementation JiveAnnouncementTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveAnnouncement alloc] init];
}

- (JiveAnnouncement *)announcement {
    return (JiveAnnouncement *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.announcement.type, @"announcement", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.announcement.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.announcement class], @"Announcement class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.announcement class], @"Announcement class not registered with JiveContent.");
}

- (void)testAnnouncementToJSON {
    id JSON = [self.announcement toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], @"announcement", @"Wrong type");
    
    self.announcement.subjectURI = @"/place/123456";
    self.announcement.publishDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.announcement.endDate = [NSDate dateWithTimeIntervalSince1970:1000.123];
    self.announcement.image = [NSURL URLWithString:@"http://dummy.com/image.png"];
    self.announcement.sortKey = [NSNumber numberWithInt:6];
    self.announcement.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    [self.announcement setValue:@"place" forKey:@"subjectURITargetType"];
    
    JSON = [self.announcement toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.announcement.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"subjectURI"], self.announcement.subjectURI, @"Wrong subjectURI");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"subjectURITargetType"], self.announcement.subjectURITargetType, @"Wrong subjectURITargetType");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"publishDate"], @"1970-01-01T00:00:00.000+0000", @"Wrong publishDate");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"endDate"], @"1970-01-01T00:16:40.123+0000", @"Wrong endDate");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"image"], [self.announcement.image absoluteString], @"Wrong image");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"sortKey"], self.announcement.sortKey, @"Wrong sortKey");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"visibleToExternalContributors"], self.announcement.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

- (void)testAnnouncementToJSON_alternate {
    id JSON = [self.announcement toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.announcement.type, @"Wrong type");
    
    self.announcement.subjectURI = @"/person/4567";
    self.announcement.publishDate = [NSDate dateWithTimeIntervalSince1970:1000.123];
    self.announcement.endDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.announcement.image = [NSURL URLWithString:@"http://super.com/image.jpg"];
    self.announcement.sortKey = [NSNumber numberWithInt:2];
    [self.announcement setValue:@"person" forKey:@"subjectURITargetType"];
    
    JSON = [self.announcement toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.announcement.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"subjectURI"], self.announcement.subjectURI, @"Wrong subjectURI");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"subjectURITargetType"], self.announcement.subjectURITargetType, @"Wrong subjectURITargetType");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"publishDate"], @"1970-01-01T00:16:40.123+0000", @"Wrong publishDate");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"endDate"], @"1970-01-01T00:00:00.000+0000", @"Wrong endDate");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"image"], [self.announcement.image absoluteString], @"Wrong image");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"sortKey"], self.announcement.sortKey, @"Wrong sortKey");
}

- (void)testAnnouncementParsing {
    self.announcement.subjectURI = @"/place/123456";
    self.announcement.publishDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.announcement.endDate = [NSDate dateWithTimeIntervalSince1970:1000.123];
    self.announcement.image = [NSURL URLWithString:@"http://dummy.com/image.png"];
    self.announcement.sortKey = [NSNumber numberWithInt:6];
    self.announcement.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    [self.announcement setValue:@"place" forKey:@"subjectURITargetType"];
    
    id JSON = [self.announcement toJSONDictionary];
    JiveAnnouncement *newContent = [JiveAnnouncement objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.announcement class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.announcement.type, @"Wrong type");
    STAssertEqualObjects(newContent.subjectURI, self.announcement.subjectURI, @"Wrong subjectURI");
    STAssertEqualObjects(newContent.subjectURITargetType, self.announcement.subjectURITargetType, @"Wrong subjectURITargetType");
    STAssertEqualObjects(newContent.publishDate, self.announcement.publishDate, @"Wrong publishDate");
    STAssertEqualObjects(newContent.endDate, self.announcement.endDate, @"Wrong endDate");
    STAssertEqualObjects(newContent.image, self.announcement.image, @"Wrong image");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.announcement.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

- (void)testAnnouncementParsingAlternate {
    self.announcement.subjectURI = @"/person/4567";
    self.announcement.publishDate = [NSDate dateWithTimeIntervalSince1970:1000.123];
    self.announcement.endDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.announcement.image = [NSURL URLWithString:@"http://super.com/image.jpg"];
    self.announcement.sortKey = [NSNumber numberWithInt:2];
    [self.announcement setValue:@"person" forKey:@"subjectURITargetType"];
    
    id JSON = [self.announcement toJSONDictionary];
    JiveAnnouncement *newContent = [JiveAnnouncement objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.announcement class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.announcement.type, @"Wrong type");
    STAssertEqualObjects(newContent.subjectURI, self.announcement.subjectURI, @"Wrong subjectURI");
    STAssertEqualObjects(newContent.subjectURITargetType, self.announcement.subjectURITargetType, @"Wrong subjectURITargetType");
    STAssertEqualObjects(newContent.publishDate, self.announcement.publishDate, @"Wrong publishDate");
    STAssertEqualObjects(newContent.endDate, self.announcement.endDate, @"Wrong endDate");
    STAssertEqualObjects(newContent.image, self.announcement.image, @"Wrong image");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.announcement.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

@end
