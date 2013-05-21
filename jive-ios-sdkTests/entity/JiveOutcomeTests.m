//
//  JiveOutcomeTests.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveOutcomeTests.h"
#import "JiveOutcomeType.h"
#import "JiveField.h"

@implementation JiveOutcomeTests

- (void)testToJSON {
    JiveOutcome *outcome = [JiveOutcome new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    JivePerson *user = [JivePerson new];
    JiveField *field = [JiveField new];
    JiveResourceEntry *resourceEntry = [JiveResourceEntry new];
    NSString *outcomeTypesJiveId = @"345";
    
    [user setValue:@"Richard" forKey:JivePersonAttributes.displayName];
    [resourceEntry setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:JiveResourceEntryAttributes.ref];
    [resourceEntry setValue:@"GET" forKey:JiveResourceEntryAttributes.allowed];
    [field setValue:@"field name" forKey:@"name"];
    [outcomeType setValue:@[field] forKey:JiveOutcomeTypeAttributes.fields];
    [outcomeType setValue:outcomeTypesJiveId forKey:JiveOutcomeAttributes.jiveId];
    [outcome setValue:outcomeType forKey:JiveOutcomeAttributes.outcomeType];
    
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveOutcomeAttributes.creationDate];
    [outcome setValue:@"123" forKey:JiveOutcomeAttributes.jiveId];
    
    [outcome setValue:@"testParent" forKey:JiveOutcomeAttributes.parent];
    [outcome setValue:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"property", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]] forKey:JiveOutcomeAttributes.properties];
    [outcome setValue:@{@"key": resourceEntry} forKey:@"resources"];
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveOutcomeAttributes.updated];
    [outcome setValue:user forKey:JiveOutcomeAttributes.user];
    
    NSDictionary *JSON = [outcome toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]],
                 @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], outcome.jiveId, @"jiveId wrong in JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.outcomeType] objectForKey:@"id"],
                         outcome.outcomeType.jiveId, @"outcomeType id wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.properties] objectForKey:@"key"],
                         @"property", @"Properties wrong in outcome JSON");
}

- (void)testPersistentJSON {
    JiveOutcome *outcome = [JiveOutcome new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    JivePerson *user = [JivePerson new];
    JiveField *field = [JiveField new];
    JiveResourceEntry *resourceEntry = [JiveResourceEntry new];
    NSString *outcomeTypesJiveId = @"345";
    NSString *outcomeTypesName = @"name";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    
    [user setValue:@"Richard" forKey:JivePersonAttributes.displayName];
    [resourceEntry setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:JiveResourceEntryAttributes.ref];
    [resourceEntry setValue:@"GET" forKey:JiveResourceEntryAttributes.allowed];
    [field setValue:@"field name" forKey:@"name"];
    [outcomeType setValue:@[field] forKey:JiveOutcomeTypeAttributes.fields];
    [outcomeType setValue:outcomeTypesJiveId forKey:JiveOutcomeAttributes.jiveId];
    [outcomeType setValue:outcomeTypesName forKey:JiveOutcomeTypeAttributes.name];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    [outcome setValue:outcomeType forKey:JiveOutcomeAttributes.outcomeType];
    
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveOutcomeAttributes.creationDate];
    [outcome setValue:@"123" forKey:JiveOutcomeAttributes.jiveId];

    [outcome setValue:@"testParent" forKey:JiveOutcomeAttributes.parent];
    [outcome setValue:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"property", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]] forKey:JiveOutcomeAttributes.properties];
    [outcome setValue:@{@"key": resourceEntry} forKey:@"resources"];
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveOutcomeAttributes.updated];
    [outcome setValue:user forKey:JiveOutcomeAttributes.user];
    
    NSDictionary *JSON = [outcome persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]],
                 @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveOutcomeAttributes.creationDate],
                         @"1970-01-01T00:00:00.000+0000", @"creationDate wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"id"], outcome.jiveId, @"jiveId wrong in JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.outcomeType] objectForKey:@"id"],
                         outcome.outcomeType.jiveId, @"outcomeType id wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.outcomeType] objectForKey:JiveOutcomeTypeAttributes.name],
                         outcome.outcomeType.name, @"outcomeType name wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.properties] objectForKey:@"key"],
                         @"property", @"Properties wrong in outcome JSON");
    STAssertEquals([[[JSON objectForKey:@"resources"] objectForKey:@"key"] objectForKey:JiveResourceEntryAttributes.ref],
                   [resourceEntry.ref absoluteString], @"Resources wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JiveOutcomeAttributes.parent], outcome.parent,
                         @"parent wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:JiveOutcomeAttributes.updated],
                         @"1970-01-01T00:16:40.123+0000", @"updated wrong in JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.user] objectForKey:JivePersonAttributes.displayName],
                         user.displayName, @"user wrong in JSON");
}

- (void)testToJSON_alternate {
    JiveOutcome *outcome = [JiveOutcome new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    JivePerson *user = [JivePerson new];
    JiveField *field = [JiveField new];
    JiveResourceEntry *resourceEntry = [JiveResourceEntry new];
    NSString *outcomeTypesJiveId = @"666";
    NSString *outcomeTypesName = @"outcomeTypeName";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    
    [user setValue:@"Burt" forKey:JivePersonAttributes.displayName];
    [resourceEntry setValue:[NSURL URLWithString:@"http://alternate.com"] forKey:JiveResourceEntryAttributes.ref];
    [resourceEntry setValue:@"GET" forKey:JiveResourceEntryAttributes.allowed];
    [field setValue:@"alternate" forKey:@"name"];
    [outcomeType setValue:@[field] forKey:JiveOutcomeTypeAttributes.fields];
    [outcomeType setValue:outcomeTypesJiveId forKey:JiveOutcomeAttributes.jiveId];
    [outcomeType setValue:outcomeTypesName forKey:JiveOutcomeTypeAttributes.name];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    [outcome setValue:outcomeType forKey:JiveOutcomeAttributes.outcomeType];
    
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveOutcomeAttributes.creationDate];
    [outcome setValue:@"345" forKey:JiveOutcomeAttributes.jiveId];
    
    [outcome setValue:@"outcomeParent" forKey:JiveOutcomeAttributes.parent];
    [outcome setValue:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"property2", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]] forKey:JiveOutcomeAttributes.properties];
    [outcome setValue:@{@"key": resourceEntry} forKey:@"resources"];
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveOutcomeAttributes.updated];
    [outcome setValue:user forKey:JiveOutcomeAttributes.user];
    
    NSDictionary *JSON = [outcome toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]],
                 @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], outcome.jiveId, @"jiveId wrong in JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.outcomeType] objectForKey:@"id"],
                         outcome.outcomeType.jiveId, @"outcomeType id wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.properties] objectForKey:@"key"],
                         @"property2", @"Properties wrong in outcome JSON");
}

- (void)testPersistentJSON_alternate {
    JiveOutcome *outcome = [JiveOutcome new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    JivePerson *user = [JivePerson new];
    JiveField *field = [JiveField new];
    JiveResourceEntry *resourceEntry = [JiveResourceEntry new];
    NSString *outcomeTypesJiveId = @"666";
    NSString *outcomeTypesName = @"outcomeTypeName";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    
    [user setValue:@"Burt" forKey:JivePersonAttributes.displayName];
    [resourceEntry setValue:[NSURL URLWithString:@"http://alternate.com"] forKey:JiveResourceEntryAttributes.ref];
    [resourceEntry setValue:@"GET" forKey:JiveResourceEntryAttributes.allowed];
    [field setValue:@"alternate" forKey:@"name"];
    [outcomeType setValue:@[field] forKey:JiveOutcomeTypeAttributes.fields];
    [outcomeType setValue:outcomeTypesJiveId forKey:JiveOutcomeAttributes.jiveId];
    [outcomeType setValue:outcomeTypesName forKey:JiveOutcomeTypeAttributes.name];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    [outcome setValue:outcomeType forKey:JiveOutcomeAttributes.outcomeType];
    
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveOutcomeAttributes.creationDate];
    [outcome setValue:@"345" forKey:JiveOutcomeAttributes.jiveId];
    
    [outcome setValue:@"outcomeParent" forKey:JiveOutcomeAttributes.parent];
    [outcome setValue:[[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"property2", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]] forKey:JiveOutcomeAttributes.properties];
    [outcome setValue:@{@"key": resourceEntry} forKey:@"resources"];
    [outcome setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveOutcomeAttributes.updated];
    [outcome setValue:user forKey:JiveOutcomeAttributes.user];
    
    NSDictionary *JSON = [outcome persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]],
                 @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveOutcomeAttributes.creationDate],
                         @"1970-01-01T00:00:00.000+0000", @"creationDate wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"id"], outcome.jiveId, @"jiveId wrong in JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.outcomeType] objectForKey:@"id"],
                         outcome.outcomeType.jiveId, @"outcomeType id wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.outcomeType] objectForKey:JiveOutcomeTypeAttributes.name],
                         outcome.outcomeType.name, @"outcomeType name wrong in outcome JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.properties] objectForKey:@"key"],
                         @"property2", @"Properties wrong in outcome JSON");
    STAssertEquals([[[JSON objectForKey:@"resources"] objectForKey:@"key"] objectForKey:JiveResourceEntryAttributes.ref],
                   [resourceEntry.ref absoluteString], @"Resources wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JiveOutcomeAttributes.parent], outcome.parent,
                         @"parent wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:JiveOutcomeAttributes.updated],
                         @"1970-01-01T00:16:40.123+0000", @"updated wrong in JSON");
    STAssertEqualObjects([[JSON objectForKey:JiveOutcomeAttributes.user] objectForKey:JivePersonAttributes.displayName],
                         user.displayName, @"user wrong in JSON");
}

@end
