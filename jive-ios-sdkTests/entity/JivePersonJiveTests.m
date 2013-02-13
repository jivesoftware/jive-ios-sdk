//
//  JivePersonJiveTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/17/12.
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

#import "JivePersonJiveTests.h"
#import "JivePersonJive.h"
#import "JiveLevel.h"
#import "JiveProfileEntry.h"

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
    person.enabled = [NSNumber numberWithBool:YES];
    person.external = [NSNumber numberWithBool:YES];
    person.externalContributor = [NSNumber numberWithBool:YES];
    person.federated = [NSNumber numberWithBool:YES];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)8, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"password"], person.password, @"Wrong password.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"locale"], person.locale, @"Wrong locale.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"timeZone"], person.timeZone, @"Wrong time zone");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"username"], person.username, @"Wrong username");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"enabled"], person.enabled, @"Wrong enabled");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"external"], person.external, @"Wrong external");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"externalContributor"], person.externalContributor, @"Wrong externalContributor");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"federated"], person.federated, @"Wrong federated");
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
}

- (void)testPersonJiveParsing {
    JivePersonJive *basePerson = [[JivePersonJive alloc] init];
    
    basePerson.password = @"Phone Number";
    basePerson.locale = @"12345";
    basePerson.timeZone = @"CST";
    basePerson.username = @"Home";
    basePerson.enabled = [NSNumber numberWithBool:YES];
    basePerson.external = [NSNumber numberWithBool:YES];
    basePerson.externalContributor = [NSNumber numberWithBool:YES];
    basePerson.federated = [NSNumber numberWithBool:YES];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[basePerson toJSONDictionary];
    NSDictionary *levelJSON = [NSDictionary dictionaryWithObject:@"Molybdenum" forKey:@"name"];
    NSDictionary *profileJSON = [NSDictionary dictionaryWithObject:@"jive label" forKey:@"jive_label"];
    
    [JSON setValue:levelJSON forKey:@"level"];
    [JSON setValue:[NSNumber numberWithBool:YES] forKey:@"visible"];
    [JSON setValue:[NSArray arrayWithObject:profileJSON] forKey:@"profile"];
    
    JivePersonJive *person = [JivePersonJive instanceFromJSON:JSON];
    
    STAssertEquals([person class], [JivePersonJive class], @"Wrong item class");
    STAssertEqualObjects(person.password, basePerson.password, @"Wrong password");
    STAssertEqualObjects(person.locale, basePerson.locale, @"Wrong locale");
    STAssertEqualObjects(person.timeZone, basePerson.timeZone, @"Wrong timeZone");
    STAssertEqualObjects(person.username, basePerson.username, @"Wrong username");
    STAssertEqualObjects(person.enabled, basePerson.enabled, @"Wrong enabled");
    STAssertEqualObjects(person.external, basePerson.external, @"Wrong external");
    STAssertEqualObjects(person.externalContributor, basePerson.externalContributor, @"Wrong externalContributor");
    STAssertEqualObjects(person.federated, basePerson.federated, @"Wrong federated");
    STAssertEqualObjects(person.visible, [NSNumber numberWithBool:YES], @"Wrong visible");
    STAssertEqualObjects(person.level.name, @"Molybdenum", @"Wrong level name");
    STAssertEquals(person.profile.count, (NSUInteger)1, @"Wrong number of profile objects");
    if (person.profile.count == 1)
        STAssertEqualObjects(((JiveProfileEntry *)[person.profile objectAtIndex:0]).jive_label, @"jive label", @"Wrong profile entry label");
}

- (void)testPersonJiveParsingAlternate {
    JivePersonJive *basePerson = [[JivePersonJive alloc] init];
    
    basePerson.password = @"helpless";
    basePerson.locale = @"87654";
    basePerson.timeZone = @"MDT";
    basePerson.username = @"Work";
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[basePerson toJSONDictionary];
    NSDictionary *levelJSON = [NSDictionary dictionaryWithObject:@"iron" forKey:@"name"];
    NSDictionary *profileJSON = [NSDictionary dictionaryWithObject:@"department" forKey:@"jive_label"];
    
    [JSON setValue:levelJSON forKey:@"level"];
    [JSON setValue:[NSArray arrayWithObject:profileJSON] forKey:@"profile"];
    
    JivePersonJive *person = [JivePersonJive instanceFromJSON:JSON];
    
    STAssertEquals([person class], [JivePersonJive class], @"Wrong item class");
    STAssertEqualObjects(person.password, basePerson.password, @"Wrong password");
    STAssertEqualObjects(person.locale, basePerson.locale, @"Wrong locale");
    STAssertEqualObjects(person.timeZone, basePerson.timeZone, @"Wrong timeZone");
    STAssertEqualObjects(person.username, basePerson.username, @"Wrong username");
    STAssertEqualObjects(person.enabled, basePerson.enabled, @"Wrong enabled");
    STAssertEqualObjects(person.external, basePerson.external, @"Wrong external");
    STAssertEqualObjects(person.externalContributor, basePerson.externalContributor, @"Wrong externalContributor");
    STAssertEqualObjects(person.federated, basePerson.federated, @"Wrong federated");
    STAssertEqualObjects(person.visible, basePerson.visible, @"Wrong visible");
    STAssertEqualObjects(person.level.name, @"iron", @"Wrong level name");
    STAssertEquals(person.profile.count, (NSUInteger)1, @"Wrong number of profile objects");
    if (person.profile.count == 1)
        STAssertEqualObjects(((JiveProfileEntry *)[person.profile objectAtIndex:0]).jive_label, @"department", @"Wrong profile entry label");
}

@end
