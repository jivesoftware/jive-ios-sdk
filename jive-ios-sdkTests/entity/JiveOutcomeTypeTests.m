//
//  JiveOutcomeTypeTests.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/5/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveOutcomeTypeTests.h"
#import "JiveOutcomeType.h"

@implementation JiveOutcomeTypeTests

- (void)testToJSON {
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = [[NSArray alloc] initWithObjects:@"field", nil];
    NSString *outcomeTypesJiveId = @"345";
    NSString *outcomeTypesName = @"name";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    [outcomeType setValue:fields forKey:@"fields"];
    [outcomeType setValue:outcomeTypesJiveId forKey:@"jiveId"];
    [outcomeType setValue:outcomeTypesName forKey:@"name"];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    
    NSDictionary *JSON = [outcomeType toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEquals([JSON objectForKey:@"id"], outcomeTypesJiveId, @"ID wrong in JSON");
}

- (void)testPersistentJSON {
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = [[NSArray alloc] initWithObjects:@"field", nil];
    NSString *outcomeTypesJiveId = @"345";
    NSString *outcomeTypesName = @"name";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    [outcomeType setValue:fields forKey:@"fields"];
    [outcomeType setValue:outcomeTypesJiveId forKey:@"jiveId"];
    [outcomeType setValue:outcomeTypesName forKey:@"name"];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    
    NSDictionary *JSON = [outcomeType persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEquals([[JSON objectForKey:@"fields"] objectAtIndex:0], @"field", @"Fields wrong in JSON");
    STAssertEquals([JSON objectForKey:@"id"], outcomeTypesJiveId, @"ID wrong in JSON");
    STAssertEquals([JSON objectForKey:@"name"], outcomeTypesName, @"Name wrong in JSON");
    STAssertEquals([[JSON objectForKey:@"resources"] objectForKey:@"key"], @"resource", @"Resources wrong in JSON");
}

- (void)testToJSON_alternate {
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = [[NSArray alloc] initWithObjects:@"field2", nil];
    NSString *outcomeTypesJiveId = @"777";
    NSString *outcomeTypesName = @"typeName";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource2", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    [outcomeType setValue:fields forKey:@"fields"];
    [outcomeType setValue:outcomeTypesJiveId forKey:@"jiveId"];
    [outcomeType setValue:outcomeTypesName forKey:@"name"];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    
    NSDictionary *JSON = [outcomeType toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEquals([JSON objectForKey:@"id"], outcomeTypesJiveId, @"ID wrong in JSON");
}

- (void)testPersistentJSON_alternate {
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = [[NSArray alloc] initWithObjects:@"field2", nil];
    NSString *outcomeTypesJiveId = @"777";
    NSString *outcomeTypesName = @"typeName";
    NSDictionary *outcomeTypeResources = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"resource2", nil] forKeys:[[NSArray alloc] initWithObjects:@"key", nil]];
    [outcomeType setValue:fields forKey:@"fields"];
    [outcomeType setValue:outcomeTypesJiveId forKey:@"jiveId"];
    [outcomeType setValue:outcomeTypesName forKey:@"name"];
    [outcomeType setValue:outcomeTypeResources forKey:@"resources"];
    
    NSDictionary *JSON = [outcomeType persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEquals([[JSON objectForKey:@"fields"] objectAtIndex:0], @"field2", @"Fields wrong in JSON");
    STAssertEquals([JSON objectForKey:@"id"], outcomeTypesJiveId, @"ID wrong in JSON");
    STAssertEquals([JSON objectForKey:@"name"], outcomeTypesName, @"Name wrong in JSON");
    STAssertEquals([[JSON objectForKey:@"resources"] objectForKey:@"key"], @"resource2", @"Resources wrong in JSON");
}

@end
