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

- (void)setUp {
    [super setUp];
    self.object = [JivePersonJive new];
}

- (JivePersonJive *)person {
    return (JivePersonJive *)self.object;
}

- (void)testToJSON {
    id JSON = [self.person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.person.password = @"Phone Number";
    self.person.locale = @"12345";
    self.person.timeZone = @"CST";
    self.person.username = @"Home";
    self.person.enabled = [NSNumber numberWithBool:YES];
    self.person.external = [NSNumber numberWithBool:YES];
    self.person.externalContributor = [NSNumber numberWithBool:YES];
    self.person.federated = [NSNumber numberWithBool:YES];
    
    JSON = [self.person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)8, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"password"], self.person.password, @"Wrong password.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"locale"], self.person.locale, @"Wrong locale.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"timeZone"], self.person.timeZone, @"Wrong time zone");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"username"], self.person.username, @"Wrong username");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"enabled"], self.person.enabled, @"Wrong enabled");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"external"], self.person.external, @"Wrong external");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"externalContributor"], self.person.externalContributor, @"Wrong externalContributor");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"federated"], self.person.federated, @"Wrong federated");
}

- (void)testToJSON_alternate {
    id JSON = [self.person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.person.password = @"helpless";
    self.person.locale = @"87654";
    self.person.timeZone = @"MDT";
    self.person.username = @"Work";
    
    JSON = [self.person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"password"], self.person.password, @"Wrong password.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"locale"], self.person.locale, @"Wrong locale.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"timeZone"], self.person.timeZone, @"Wrong time zone");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"username"], self.person.username, @"Wrong username");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"enabled"], @"enabled included?");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"external"], @"external included?");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"externalContributor"], @"externalContributor included?");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"federated"], @"federated included?");
}

- (void)testPersonJiveParsing {
    self.person.password = @"Phone Number";
    self.person.locale = @"12345";
    self.person.timeZone = @"CST";
    self.person.username = @"Home";
    self.person.enabled = [NSNumber numberWithBool:YES];
    self.person.external = [NSNumber numberWithBool:YES];
    self.person.externalContributor = [NSNumber numberWithBool:YES];
    self.person.federated = [NSNumber numberWithBool:YES];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[self.person toJSONDictionary];
    NSDictionary *levelJSON = [NSDictionary dictionaryWithObject:@"Molybdenum" forKey:@"name"];
    NSDictionary *profileJSON = [NSDictionary dictionaryWithObject:@"jive label" forKey:@"jive_label"];
    
    [JSON setValue:levelJSON forKey:@"level"];
    [JSON setValue:[NSNumber numberWithBool:YES] forKey:@"visible"];
    [JSON setValue:[NSArray arrayWithObject:profileJSON] forKey:@"profile"];
    
    JivePersonJive *newPerson = [JivePersonJive objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newPerson class], [JivePersonJive class], @"Wrong item class");
    STAssertEqualObjects(newPerson.password, self.person.password, @"Wrong password");
    STAssertEqualObjects(newPerson.locale, self.person.locale, @"Wrong locale");
    STAssertEqualObjects(newPerson.timeZone, self.person.timeZone, @"Wrong timeZone");
    STAssertEqualObjects(newPerson.username, self.person.username, @"Wrong username");
    STAssertEqualObjects(newPerson.enabled, self.person.enabled, @"Wrong enabled");
    STAssertEqualObjects(newPerson.external, self.person.external, @"Wrong external");
    STAssertEqualObjects(newPerson.externalContributor, self.person.externalContributor, @"Wrong externalContributor");
    STAssertEqualObjects(newPerson.federated, self.person.federated, @"Wrong federated");
    STAssertEqualObjects(newPerson.visible, [NSNumber numberWithBool:YES], @"Wrong visible");
    STAssertEqualObjects(newPerson.level.name, @"Molybdenum", @"Wrong level name");
    STAssertEquals(newPerson.profile.count, (NSUInteger)1, @"Wrong number of profile objects");
    if (newPerson.profile.count == 1)
        STAssertEqualObjects(((JiveProfileEntry *)[newPerson.profile objectAtIndex:0]).jive_label, @"jive label", @"Wrong profile entry label");
}

- (void)testPersonJiveParsingAlternate {
    self.person.password = @"helpless";
    self.person.locale = @"87654";
    self.person.timeZone = @"MDT";
    self.person.username = @"Work";
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[self.person toJSONDictionary];
    NSDictionary *levelJSON = [NSDictionary dictionaryWithObject:@"iron" forKey:@"name"];
    NSDictionary *profileJSON = [NSDictionary dictionaryWithObject:@"department" forKey:@"jive_label"];
    
    [JSON setValue:levelJSON forKey:@"level"];
    [JSON setValue:[NSArray arrayWithObject:profileJSON] forKey:@"profile"];
    
    JivePersonJive *newPerson = [JivePersonJive objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newPerson class], [JivePersonJive class], @"Wrong item class");
    STAssertEqualObjects(newPerson.password, self.person.password, @"Wrong password");
    STAssertEqualObjects(newPerson.locale, self.person.locale, @"Wrong locale");
    STAssertEqualObjects(newPerson.timeZone, self.person.timeZone, @"Wrong timeZone");
    STAssertEqualObjects(newPerson.username, self.person.username, @"Wrong username");
    STAssertEqualObjects(newPerson.enabled, self.person.enabled, @"Wrong enabled");
    STAssertEqualObjects(newPerson.external, self.person.external, @"Wrong external");
    STAssertEqualObjects(newPerson.externalContributor, self.person.externalContributor, @"Wrong externalContributor");
    STAssertEqualObjects(newPerson.federated, self.person.federated, @"Wrong federated");
    STAssertEqualObjects(newPerson.visible, self.person.visible, @"Wrong visible");
    STAssertEqualObjects(newPerson.level.name, @"iron", @"Wrong level name");
    STAssertEquals(newPerson.profile.count, (NSUInteger)1, @"Wrong number of profile objects");
    if (newPerson.profile.count == 1)
        STAssertEqualObjects(((JiveProfileEntry *)[newPerson.profile objectAtIndex:0]).jive_label, @"department", @"Wrong profile entry label");
}

@end
