//
//  JiveSummaryTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/21/12.
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

#import "JiveSummaryTests.h"
#import "JiveSummary.h"

@implementation JiveSummaryTests

- (void)setUp {
    [super setUp];
    self.object = [JiveSummary new];
}

- (JiveSummary *)summary {
    return (JiveSummary *)self.object;
}

- (void)testToJSON {
    id JSON = [self.summary toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self.summary setValue:@"testName" forKey:@"name"];
    [self.summary setValue:@"1234" forKey:@"jiveId"];
    [self.summary setValue:@"place" forKey:@"type"];
    [self.summary setValue:@"https://dummy.com/item.html" forKey:@"html"];
    [self.summary setValue:@"https://dummy.com/item.json" forKey:@"uri"];
    
    JSON = [self.summary toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], self.summary.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], self.summary.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.summary.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"html"], self.summary.html, @"Wrong html");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"uri"], self.summary.uri, @"Wrong uri");
}

- (void)testToJSON_alternate {
    id JSON = [self.summary toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self.summary setValue:@"Alternate" forKey:@"name"];
    [self.summary setValue:@"8743" forKey:@"jiveId"];
    [self.summary setValue:@"blog" forKey:@"type"];
    [self.summary setValue:@"https://dummy.com/blog.html" forKey:@"html"];
    [self.summary setValue:@"https://dummy.com/blog.json" forKey:@"uri"];
    
    JSON = [self.summary toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], self.summary.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], self.summary.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.summary.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"html"], self.summary.html, @"Wrong html");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"uri"], self.summary.uri, @"Wrong uri");
}

- (void)testPlaceParsing {
    [self.summary setValue:@"testName" forKey:@"name"];
    [self.summary setValue:@"1234" forKey:@"jiveId"];
    [self.summary setValue:@"place" forKey:@"type"];
    [self.summary setValue:@"https://dummy.com/item.html" forKey:@"html"];
    [self.summary setValue:@"https://dummy.com/item.json" forKey:@"uri"];
    
    id JSON = [self.summary toJSONDictionary];
    JiveSummary *newSummary = [JiveSummary objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newSummary class], [self.summary class], @"Wrong item class");
    STAssertEqualObjects(newSummary.jiveId, self.summary.jiveId, @"Wrong id");
    STAssertEqualObjects(newSummary.name, self.summary.name, @"Wrong name");
    STAssertEqualObjects(newSummary.type, self.summary.type, @"Wrong type");
    STAssertEqualObjects(newSummary.html, self.summary.html, @"Wrong html");
    STAssertEqualObjects(newSummary.uri, self.summary.uri, @"Wrong uri");
}

- (void)testPlaceParsingAlternate {
    [self.summary setValue:@"Alternate" forKey:@"name"];
    [self.summary setValue:@"8743" forKey:@"jiveId"];
    [self.summary setValue:@"blog" forKey:@"type"];
    [self.summary setValue:@"https://dummy.com/blog.html" forKey:@"html"];
    [self.summary setValue:@"https://dummy.com/blog.json" forKey:@"uri"];
    
    id JSON = [self.summary toJSONDictionary];
    JiveSummary *newSummary = [JiveSummary objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newSummary class], [self.summary class], @"Wrong item class");
    STAssertEqualObjects(newSummary.jiveId, self.summary.jiveId, @"Wrong id");
    STAssertEqualObjects(newSummary.name, self.summary.name, @"Wrong name");
    STAssertEqualObjects(newSummary.type, self.summary.type, @"Wrong type");
    STAssertEqualObjects(newSummary.html, self.summary.html, @"Wrong html");
    STAssertEqualObjects(newSummary.uri, self.summary.uri, @"Wrong uri");
}

@end
