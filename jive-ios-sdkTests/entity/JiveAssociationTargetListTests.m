//
//  JiveAssociationTargetListTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveAssociationTargetListTests.h"
#import "JiveAssociationTargetList_internal.h"
#import "JivePerson.h"
#import "JivePlace.h"
#import "JiveContent.h"
#import "JiveResourceEntry.h"

@implementation JiveAssociationTargetListTests

@synthesize targets;

- (void)setUp {
    targets = [[JiveAssociationTargetList alloc] init];
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
    NSArray *JSON = [targets toJSONArray];
    
    STAssertNil(JSON, @"Empty list should not exist");
    
    [resource1 setValue:sampleUrl1 forKey:@"ref"];
    [person1 setValue:[NSDictionary dictionaryWithObject:resource1 forKey:@"self"] forKey:@"resources"];
    [resource2 setValue:sampleUrl2 forKey:@"ref"];
    [person2 setValue:[NSDictionary dictionaryWithObject:resource2 forKey:@"self"] forKey:@"resources"];
    
    [targets addAssociationTarget:person1];
    JSON = [targets toJSONArray];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    
    [targets addAssociationTarget:person2];
    JSON = [targets toJSONArray];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], [sampleUrl2 absoluteString], @"Wrong contents");
}

- (void)testAddPlace {
    JivePlace *place1 = [[JivePlace alloc] init];
    JivePlace *place2 = [[JivePlace alloc] init];
    JiveResourceEntry *resource1 = [[JiveResourceEntry alloc] init];
    JiveResourceEntry *resource2 = [[JiveResourceEntry alloc] init];
    NSURL *sampleUrl1 = [NSURL URLWithString:@"http://dummy.com"];
    NSURL *sampleUrl2 = [NSURL URLWithString:@"http://super.com"];
    NSArray *JSON = [targets toJSONArray];
    
    STAssertNil(JSON, @"Empty list should not exist");
    
    [resource1 setValue:sampleUrl1 forKey:@"ref"];
    [place1 setValue:[NSDictionary dictionaryWithObject:resource1 forKey:@"self"] forKey:@"resources"];
    [resource2 setValue:sampleUrl2 forKey:@"ref"];
    [place2 setValue:[NSDictionary dictionaryWithObject:resource2 forKey:@"self"] forKey:@"resources"];
    
    [targets addAssociationTarget:place1];
    JSON = [targets toJSONArray];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    
    [targets addAssociationTarget:place2];
    JSON = [targets toJSONArray];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], [sampleUrl2 absoluteString], @"Wrong contents");
}

- (void)testAddContent {
    JiveContent *content1 = [[JiveContent alloc] init];
    JiveContent *content2 = [[JiveContent alloc] init];
    JiveResourceEntry *resource1 = [[JiveResourceEntry alloc] init];
    JiveResourceEntry *resource2 = [[JiveResourceEntry alloc] init];
    NSURL *sampleUrl1 = [NSURL URLWithString:@"http://dummy.com"];
    NSURL *sampleUrl2 = [NSURL URLWithString:@"http://super.com"];
    NSArray *JSON = [targets toJSONArray];
    
    STAssertNil(JSON, @"Empty list should not exist");
    
    [resource1 setValue:sampleUrl1 forKey:@"ref"];
    [content1 setValue:[NSDictionary dictionaryWithObject:resource1 forKey:@"self"] forKey:@"resources"];
    [resource2 setValue:sampleUrl2 forKey:@"ref"];
    [content2 setValue:[NSDictionary dictionaryWithObject:resource2 forKey:@"self"] forKey:@"resources"];
    
    [targets addAssociationTarget:content1];
    JSON = [targets toJSONArray];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    
    [targets addAssociationTarget:content2];
    JSON = [targets toJSONArray];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSArray class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectAtIndex:0], [sampleUrl1 absoluteString], @"Wrong contents");
    STAssertEqualObjects([JSON objectAtIndex:1], [sampleUrl2 absoluteString], @"Wrong contents");
}

@end
