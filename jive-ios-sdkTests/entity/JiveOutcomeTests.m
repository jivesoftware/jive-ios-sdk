//
//  JiveOutcomeTests.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveOutcomeTests.h"
#import "JiveOutcomeType.h"

@implementation JiveOutcomeTests

- (void)testToJSON {
    JiveOutcome *outcome = [[JiveOutcome alloc] init];
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"creationDate"];
    [outcome setValue:@"123" forKey:@"jiveId"];
    
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = [[NSArray alloc] initWithObjects:@"field", nil];
    NSString *outcomeTypesJiveId = @"345";
    NSString *outcomeTypesName = @"name";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    [outcomeType setValue:fields forKey:@"fields"];
    [outcomeType setValue:outcomeTypesJiveId forKey:@"jiveId"];
    [outcomeType setValue:outcomeTypesName forKey:@"name"];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    [outcome setValue:outcomeType forKey:@"outcomeType"];
    
    [outcome setValue:@"testParent" forKey:@"parent"];
    [outcome setValue:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"property", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]] forKey:@"properties"];
    [outcome setValue:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]] forKey:@"resources"];
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [outcome setValue:[[JivePerson alloc] init] forKey:@"user"];
    
    NSDictionary *JSON = [outcome toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"creationDate"], @"1970-01-01T00:00:00.000+0000", @"creationDate wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"id"], outcome.jiveId, @"jiveId wrong in JSON");
    STAssertEqualObjects([[JSON objectForKey:@"outcomeType"] objectForKey:@"id"], outcome.outcomeType.jiveId, @"outcomeType id wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:@"outcomeType"] objectForKey:@"name"], outcome.outcomeType.name, @"outcomeType name wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:@"properties"] objectForKey:@"key"], @"property", @"Properties wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:@"resources"] objectForKey:@"key"], @"resource", @"Resources wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"parent"], outcome.parent, @"parent wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"updated wrong in JSON");
}

- (void)testToJSON_alternate {
    JiveOutcome *outcome = [[JiveOutcome alloc] init];
    
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"creationDate"];
    [outcome setValue:@"345" forKey:@"jiveId"];
    
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = [[NSArray alloc] initWithObjects:@"field", nil];
    NSString *outcomeTypesJiveId = @"666";
    NSString *outcomeTypesName = @"outcomeTypeName";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    [outcomeType setValue:fields forKey:@"fields"];
    [outcomeType setValue:outcomeTypesJiveId forKey:@"jiveId"];
    [outcomeType setValue:outcomeTypesName forKey:@"name"];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    [outcome setValue:outcomeType forKey:@"outcomeType"];
    
    [outcome setValue:@"outcomeParent" forKey:@"parent"];
    [outcome setValue:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"property2", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]] forKey:@"properties"];
    [outcome setValue:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource2", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]] forKey:@"resources"];
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [outcome setValue:[[JivePerson alloc] init] forKey:@"user"];
    
    NSDictionary *JSON = [outcome toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"creationDate"], @"1970-01-01T00:00:00.000+0000", @"creationDate wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"id"], outcome.jiveId, @"jiveId wrong in JSON");
    STAssertEqualObjects([[JSON objectForKey:@"outcomeType"] objectForKey:@"id"], outcome.outcomeType.jiveId, @"outcomeType id wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:@"outcomeType"] objectForKey:@"name"], outcome.outcomeType.name, @"outcomeType name wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:@"properties"] objectForKey:@"key"], @"property2", @"Properties wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:@"resources"] objectForKey:@"key"], @"resource2", @"Resources wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"parent"], outcome.parent, @"parent wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"updated wrong in JSON");
}

@end
