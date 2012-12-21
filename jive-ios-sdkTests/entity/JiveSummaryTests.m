//
//  JiveSummaryTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/21/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSummaryTests.h"
#import "JiveSummary.h"

@implementation JiveSummaryTests

- (void)testToJSON {
    JiveSummary *summary = [[JiveSummary alloc] init];
    id JSON = [summary toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [summary setValue:@"testName" forKey:@"name"];
    [summary setValue:@"1234" forKey:@"jiveId"];
    [summary setValue:@"place" forKey:@"type"];
    [summary setValue:@"https://dummy.com/item.html" forKey:@"html"];
    [summary setValue:@"https://dummy.com/item.json" forKey:@"uri"];
    
    JSON = [summary toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], summary.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], summary.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], summary.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"html"], summary.html, @"Wrong html");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"uri"], summary.uri, @"Wrong uri");
}

- (void)testToJSON_alternate {
    JiveSummary *summary = [[JiveSummary alloc] init];
    id JSON = [summary toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [summary setValue:@"Alternate" forKey:@"name"];
    [summary setValue:@"8743" forKey:@"jiveId"];
    [summary setValue:@"blog" forKey:@"type"];
    [summary setValue:@"https://dummy.com/blog.html" forKey:@"html"];
    [summary setValue:@"https://dummy.com/blog.json" forKey:@"uri"];
    
    JSON = [summary toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], summary.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], summary.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], summary.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"html"], summary.html, @"Wrong html");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"uri"], summary.uri, @"Wrong uri");
}

- (void)testPlaceParsing {
    JiveSummary *baseSummary = [[JiveSummary alloc] init];
    
    [baseSummary setValue:@"testName" forKey:@"name"];
    [baseSummary setValue:@"1234" forKey:@"jiveId"];
    [baseSummary setValue:@"place" forKey:@"type"];
    [baseSummary setValue:@"https://dummy.com/item.html" forKey:@"html"];
    [baseSummary setValue:@"https://dummy.com/item.json" forKey:@"uri"];
    
    id JSON = [baseSummary toJSONDictionary];
    JiveSummary *summary = [JiveSummary instanceFromJSON:JSON];
    
    STAssertEquals([summary class], [baseSummary class], @"Wrong item class");
    STAssertEqualObjects(summary.jiveId, baseSummary.jiveId, @"Wrong id");
    STAssertEqualObjects(summary.name, baseSummary.name, @"Wrong name");
    STAssertEqualObjects(summary.type, baseSummary.type, @"Wrong type");
    STAssertEqualObjects(summary.html, baseSummary.html, @"Wrong html");
    STAssertEqualObjects(summary.uri, baseSummary.uri, @"Wrong uri");
}

- (void)testPlaceParsingAlternate {
    JiveSummary *baseSummary = [[JiveSummary alloc] init];
    
    [baseSummary setValue:@"Alternate" forKey:@"name"];
    [baseSummary setValue:@"8743" forKey:@"jiveId"];
    [baseSummary setValue:@"blog" forKey:@"type"];
    [baseSummary setValue:@"https://dummy.com/blog.html" forKey:@"html"];
    [baseSummary setValue:@"https://dummy.com/blog.json" forKey:@"uri"];
    
    id JSON = [baseSummary toJSONDictionary];
    JiveSummary *summary = [JiveSummary instanceFromJSON:JSON];
    
    STAssertEquals([summary class], [baseSummary class], @"Wrong item class");
    STAssertEqualObjects(summary.jiveId, baseSummary.jiveId, @"Wrong id");
    STAssertEqualObjects(summary.name, baseSummary.name, @"Wrong name");
    STAssertEqualObjects(summary.type, baseSummary.type, @"Wrong type");
    STAssertEqualObjects(summary.html, baseSummary.html, @"Wrong html");
    STAssertEqualObjects(summary.uri, baseSummary.uri, @"Wrong uri");
}

@end
