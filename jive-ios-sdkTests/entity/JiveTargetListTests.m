//
//  JiveTargetListTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTargetListTests.h"
#import "JiveResourceEntry.h"

@implementation JiveTargetListTests

@synthesize targets;

- (void)setUp {
    targets = [[JiveTargetList alloc] init];
}

- (void)tearDown {
    targets = nil;
}

- (void)testAddPerson {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    JiveResourceEntry *resource1 = [[JiveResourceEntry alloc] init];
    JiveResourceEntry *resource2 = [[JiveResourceEntry alloc] init];
    NSURL *sampleUrl1 = [NSURL URLWithString:@"http://dummy.com"];
    NSURL *sampleUrl2 = [NSURL URLWithString:@"http://super.com"];
    NSArray *JSON = [targets toJSONArray:YES];
    
    STAssertNil(JSON, @"Empty list should not exist");
    
    [resource1 setValue:sampleUrl1 forKey:@"ref"];
    [person1 setValue:[NSDictionary dictionaryWithObject:resource1 forKey:@"self"] forKey:@"resources"];
    [resource2 setValue:sampleUrl2 forKey:@"ref"];
    [person2 setValue:[NSDictionary dictionaryWithObject:resource2 forKey:@"self"] forKey:@"resources"];
    
    [targets addPerson:person1];
    JSON = [targets toJSONArray:YES];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    
    [targets addPerson:person2];
    JSON = [targets toJSONArray:YES];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], [sampleUrl2 absoluteString], @"Wrong contents");
}

- (void)testAddEmail {
    NSString *sampleEmail1 = @"email@dummy.com";
    NSString *sampleEmail2 = @"email@super.com";
    NSArray *JSON = [targets toJSONArray:NO];
    
    STAssertNil(JSON, @"Empty list should not exist");
    
    [targets addEmailAddress:sampleEmail1];
    JSON = [targets toJSONArray:YES];
    STAssertNil(JSON, @"Empty list should not exist");
    
    JSON = [targets toJSONArray:NO];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], sampleEmail1, @"Wrong contents");
    
    [targets addEmailAddress:sampleEmail2];
    JSON = [targets toJSONArray:YES];
    STAssertNil(JSON, @"Empty list should not exist");
    
    JSON = [targets toJSONArray:NO];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], sampleEmail1, @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], sampleEmail2, @"Wrong contents");
}

- (void)testAddUserName {
    NSString *sampleUserName1 = @"Orson Bushnell";
    NSString *sampleUserName2 = @"Heath Borders";
    NSArray *JSON = [targets toJSONArray:NO];
    
    STAssertNil(JSON, @"Empty list should not exist");
    
    [targets addUserName:sampleUserName1];
    JSON = [targets toJSONArray:YES];
    STAssertNil(JSON, @"Empty list should not exist");
    
    JSON = [targets toJSONArray:NO];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], sampleUserName1, @"Wrong contents");
    
    [targets addUserName:sampleUserName2];
    JSON = [targets toJSONArray:YES];
    STAssertNil(JSON, @"Empty list should not exist");
    
    JSON = [targets toJSONArray:NO];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], sampleUserName1, @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], sampleUserName2, @"Wrong contents");
}

- (void)testAddEmailAndPerson {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    JiveResourceEntry *resource1 = [[JiveResourceEntry alloc] init];
    JiveResourceEntry *resource2 = [[JiveResourceEntry alloc] init];
    NSURL *sampleUrl1 = [NSURL URLWithString:@"http://dummy.com"];
    NSURL *sampleUrl2 = [NSURL URLWithString:@"http://super.com"];
    NSString *sampleEmail1 = @"email@dummy.com";
    NSString *sampleEmail2 = @"email@super.com";
    NSArray *JSON = [targets toJSONArray:NO];
    
    STAssertNil(JSON, @"Empty list should not exist");
    
    [resource1 setValue:sampleUrl1 forKey:@"ref"];
    [person1 setValue:[NSDictionary dictionaryWithObject:resource1 forKey:@"self"] forKey:@"resources"];
    [resource2 setValue:sampleUrl2 forKey:@"ref"];
    [person2 setValue:[NSDictionary dictionaryWithObject:resource2 forKey:@"self"] forKey:@"resources"];
    
    [targets addPerson:person1];
    JSON = [targets toJSONArray:NO];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    
    [targets addEmailAddress:sampleEmail1];
    JSON = [targets toJSONArray:YES];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    
    JSON = [targets toJSONArray:NO];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], sampleEmail1, @"Wrong contents");
    
    [targets addPerson:person2];
    JSON = [targets toJSONArray:YES];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], [sampleUrl2 absoluteString], @"Wrong contents");
    
    JSON = [targets toJSONArray:NO];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], [sampleUrl2 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:2], sampleEmail1, @"Wrong contents");
    
    [targets addEmailAddress:sampleEmail2];
    JSON = [targets toJSONArray:YES];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], [sampleUrl2 absoluteString], @"Wrong contents");
    
    JSON = [targets toJSONArray:NO];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], [sampleUrl2 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:2], sampleEmail1, @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:3], sampleEmail2, @"Wrong contents");
}

@end
