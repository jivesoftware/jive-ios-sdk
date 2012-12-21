//
//  JivePersonJiveTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/17/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePersonJiveTests.h"
#import "JivePersonJive.h"

@implementation JivePersonJiveTests

- (void)testToJSON {
    JivePersonJive *person = [[JivePersonJive alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    person.password = @"Phone Number";
    person.locale = @"12345";
    person.timeZone = @"CST";
    person.username = @"Home";
    [person performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"enabled"
                    withObject:(__bridge id)kCFBooleanTrue];
    [person performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"external"
                    withObject:(__bridge id)kCFBooleanTrue];
    [person performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"externalContributor"
                    withObject:(__bridge id)kCFBooleanTrue];
    [person performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"federated"
                    withObject:(__bridge id)kCFBooleanTrue];
    [person performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"visible"
                    withObject:(__bridge id)kCFBooleanTrue];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)9, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"password"], person.password, @"Wrong password.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"locale"], person.locale, @"Wrong locale.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"timeZone"], person.timeZone, @"Wrong time zone");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"username"], person.username, @"Wrong username");
    
    id enabled = [(NSDictionary *)JSON objectForKey:@"enabled"];
    
    STAssertNotNil(enabled, @"Missing visibility");
    if (enabled)
        STAssertTrue(CFBooleanGetValue((__bridge CFBooleanRef)enabled), @"Wrong enabled");
    
    id external = [(NSDictionary *)JSON objectForKey:@"external"];
    
    STAssertNotNil(external, @"Missing external");
    if (external)
        STAssertTrue(CFBooleanGetValue((__bridge CFBooleanRef)external), @"Wrong external");
    
    id externalContributor = [(NSDictionary *)JSON objectForKey:@"externalContributor"];
    
    STAssertNotNil(externalContributor, @"Missing externalContributor");
    if (externalContributor)
        STAssertTrue(CFBooleanGetValue((__bridge CFBooleanRef)externalContributor), @"Wrong externalContributor");
    
    id federated = [(NSDictionary *)JSON objectForKey:@"federated"];
    
    STAssertNotNil(federated, @"Missing federated");
    if (federated)
        STAssertTrue(CFBooleanGetValue((__bridge CFBooleanRef)federated), @"Wrong federated");
    
    id visible = [(NSDictionary *)JSON objectForKey:@"visible"];
    
    STAssertNotNil(visible, @"Missing visible");
    if (visible)
        STAssertTrue(CFBooleanGetValue((__bridge CFBooleanRef)visible), @"Wrong visible");
}

- (void)testToJSON_alternate {
    JivePersonJive *person = [[JivePersonJive alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    person.password = @"helpless";
    person.locale = @"87654";
    person.timeZone = @"MDT";
    person.username = @"Work";
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"password"], person.password, @"Wrong password.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"locale"], person.locale, @"Wrong locale.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"timeZone"], person.timeZone, @"Wrong time zone");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"username"], person.username, @"Wrong username");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"enabled"], @"enabled included?");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"external"], @"external included?");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"externalContributor"], @"externalContributor included?");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"federated"], @"federated included?");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"visible"], @"visible included?");
}

- (void)testPlaceParsing {
    JivePersonJive *basePerson = [[JivePersonJive alloc] init];
    
    basePerson.password = @"Phone Number";
    basePerson.locale = @"12345";
    basePerson.timeZone = @"CST";
    basePerson.username = @"Home";
    [basePerson performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                 withObject:@"enabled"
                 withObject:(__bridge id)kCFBooleanTrue];
    [basePerson performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                 withObject:@"external"
                 withObject:(__bridge id)kCFBooleanTrue];
    [basePerson performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                 withObject:@"externalContributor"
                 withObject:(__bridge id)kCFBooleanTrue];
    [basePerson performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                 withObject:@"federated"
                 withObject:(__bridge id)kCFBooleanTrue];
    [basePerson performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                 withObject:@"visible"
                 withObject:(__bridge id)kCFBooleanTrue];
    
    id JSON = [basePerson toJSONDictionary];
    JivePersonJive *person = [JivePersonJive instanceFromJSON:JSON];
    
    STAssertEquals([person class], [JivePersonJive class], @"Wrong item class");
    STAssertEqualObjects(person.password, basePerson.password, @"Wrong password");
    STAssertEqualObjects(person.locale, basePerson.locale, @"Wrong locale");
    STAssertEqualObjects(person.timeZone, basePerson.timeZone, @"Wrong timeZone");
    STAssertEqualObjects(person.username, basePerson.username, @"Wrong username");
    STAssertTrue(person.enabled, @"Wrong enabled");
    STAssertTrue(person.external, @"Wrong external");
    STAssertTrue(person.externalContributor, @"Wrong externalContributor");
    STAssertTrue(person.federated, @"Wrong federated");
    STAssertTrue(person.visible, @"Wrong visible");
}

- (void)testPlaceParsingAlternate {
    JivePersonJive *basePerson = [[JivePersonJive alloc] init];
    
    basePerson.password = @"helpless";
    basePerson.locale = @"87654";
    basePerson.timeZone = @"MDT";
    basePerson.username = @"Work";
    
    id JSON = [basePerson toJSONDictionary];
    JivePersonJive *person = [JivePersonJive instanceFromJSON:JSON];
    
    STAssertEquals([person class], [JivePersonJive class], @"Wrong item class");
    STAssertEqualObjects(person.password, basePerson.password, @"Wrong password");
    STAssertEqualObjects(person.locale, basePerson.locale, @"Wrong locale");
    STAssertEqualObjects(person.timeZone, basePerson.timeZone, @"Wrong timeZone");
    STAssertEqualObjects(person.username, basePerson.username, @"Wrong username");
    STAssertFalse(person.enabled, @"Wrong enabled");
    STAssertFalse(person.external, @"Wrong external");
    STAssertFalse(person.externalContributor, @"Wrong externalContributor");
    STAssertFalse(person.federated, @"Wrong federated");
    STAssertFalse(person.visible, @"Wrong visible");
}

@end
