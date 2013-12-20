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
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JivePersonJiveTests

- (void)setUp {
    [super setUp];
    self.object = [JivePersonJive new];
}

- (JivePersonJive *)person {
    return (JivePersonJive *)self.object;
}

- (void)testToJSON {
    NSDictionary *JSON = [self.person toJSONDictionary];
    JiveLevel *level = [JiveLevel new];
    JiveProfileEntry *profile = [JiveProfileEntry new];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals(JSON.count, (NSUInteger)0, @"Initial dictionary is not empty");
    
    [level setValue:@"name" forKey:@"name"];
    [profile setValue:@"jive_label" forKey:@"jive_label"];
    self.person.password = @"Phone Number";
    self.person.locale = @"12345";
    self.person.timeZone = @"CST";
    self.person.username = @"Home";
    self.person.enabled = @YES;
    self.person.external = @YES;
    self.person.externalContributor = @YES;
    self.person.federated = @YES;
    [self.person setValue:[NSDate date] forKey:JivePersonJiveAttributes.lastProfileUpdate];
    [self.person setValue:level forKey:JivePersonJiveAttributes.level];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.sendable];
    [self.person setValue:@[profile] forKey:JivePersonJiveAttributes.profile];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.viewContent];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.visible];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.termsAndConditionsRequired];
    
    JSON = [self.person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals(JSON.count, (NSUInteger)8, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.password], self.person.password, @"Wrong password.");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.locale], self.person.locale, @"Wrong locale.");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.timeZone], self.person.timeZone, @"Wrong time zone");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.username], self.person.username, @"Wrong username");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.enabled], self.person.enabled, @"Wrong enabled");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.external], self.person.external, @"Wrong external");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.externalContributor], self.person.externalContributor, @"Wrong externalContributor");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.federated], self.person.federated, @"Wrong federated");
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
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.password], self.person.password, @"Wrong password.");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.locale], self.person.locale, @"Wrong locale.");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.timeZone], self.person.timeZone, @"Wrong time zone");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.username], self.person.username, @"Wrong username");
    STAssertNil(JSON[JivePersonJiveAttributes.enabled], @"enabled included?");
    STAssertNil(JSON[JivePersonJiveAttributes.external], @"external included?");
    STAssertNil(JSON[JivePersonJiveAttributes.externalContributor], @"externalContributor included?");
    STAssertNil(JSON[JivePersonJiveAttributes.federated], @"federated included?");
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.person toJSONDictionary];
    JiveLevel *level = [JiveLevel new];
    JiveProfileEntry *profile = [JiveProfileEntry new];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals(JSON.count, (NSUInteger)0, @"Initial dictionary is not empty");
    
    [level setValue:@"name" forKey:@"name"];
    [profile setValue:@"jive_label" forKey:@"jive_label"];
    self.person.password = @"Phone Number";
    self.person.locale = @"12345";
    self.person.timeZone = @"CST";
    self.person.username = @"Home";
    self.person.enabled = @YES;
    self.person.external = @YES;
    self.person.externalContributor = @YES;
    self.person.federated = @YES;
    [self.person setValue:[NSDate date] forKey:JivePersonJiveAttributes.lastProfileUpdate];
    [self.person setValue:level forKey:JivePersonJiveAttributes.level];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.sendable];
    [self.person setValue:@[profile] forKey:JivePersonJiveAttributes.profile];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.viewContent];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.visible];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.termsAndConditionsRequired];
    
    JSON = [self.person persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals(JSON.count, (NSUInteger)15, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.password], self.person.password, @"Wrong password.");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.locale], self.person.locale, @"Wrong locale.");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.timeZone], self.person.timeZone, @"Wrong time zone");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.username], self.person.username, @"Wrong username");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.enabled], self.person.enabled, @"Wrong enabled");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.external], self.person.external, @"Wrong external");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.externalContributor],
                         self.person.externalContributor, @"Wrong externalContributor");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.federated], self.person.federated, @"Wrong federated");

    STAssertEqualObjects(JSON[JivePersonJiveAttributes.lastProfileUpdate],
                         [dateFormatter stringFromDate:self.person.lastProfileUpdate],
                         @"Wrong last profile update");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.sendable], self.person.sendable, @"Wrong sendable");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.viewContent], self.person.viewContent,
                         @"Wrong viewContent");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.visible], self.person.visible, @"Wrong visible");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.termsAndConditionsRequired],
                         self.person.termsAndConditionsRequired, @"Wrong termsAndConditionsRequired");
    
    NSDictionary *levelJSON = JSON[JivePersonJiveAttributes.level];
    
    STAssertTrue([[levelJSON class] isSubclassOfClass:[NSDictionary class]], @"Level object not converted");
    STAssertEqualObjects(levelJSON[@"name"], level.name, @"Wrong level");
    
    NSArray *profilesJSON = JSON[JivePersonJiveAttributes.profile];
    NSDictionary *profileJSON = profilesJSON[0];
    
    STAssertTrue([[profilesJSON class] isSubclassOfClass:[NSArray class]], @"Profiles array not converted");
    STAssertEquals(profilesJSON.count, (NSUInteger)1, @"Wrong number of elements in the profiles array");
    STAssertTrue([[profileJSON class] isSubclassOfClass:[NSDictionary class]], @"Profile object not converted");
    STAssertEqualObjects(profileJSON[@"jive_label"], profile.jive_label, @"Wrong profile");
}

- (void)testPersistentJSON_alternate {
    NSDictionary *JSON = [self.person toJSONDictionary];
    JiveLevel *level = [JiveLevel new];
    JiveProfileEntry *profile = [JiveProfileEntry new];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [level setValue:@"Johnson" forKey:@"name"];
    [profile setValue:@"restless" forKey:@"jive_label"];
    self.person.password = @"helpless";
    self.person.locale = @"87654";
    self.person.timeZone = @"MDT";
    self.person.username = @"Work";
    [self.person setValue:[NSDate dateWithTimeIntervalSinceNow:-5000]
                   forKey:JivePersonJiveAttributes.lastProfileUpdate];
    [self.person setValue:level forKey:JivePersonJiveAttributes.level];
    [self.person setValue:@NO forKey:JivePersonJiveAttributes.sendable];
    [self.person setValue:@[profile] forKey:JivePersonJiveAttributes.profile];
    
    JSON = [self.person persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals(JSON.count, (NSUInteger)8, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.password], self.person.password, @"Wrong password.");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.locale], self.person.locale, @"Wrong locale.");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.timeZone], self.person.timeZone, @"Wrong time zone");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.username], self.person.username, @"Wrong username");
    STAssertNil(JSON[JivePersonJiveAttributes.enabled], @"enabled included?");
    STAssertNil(JSON[JivePersonJiveAttributes.external], @"external included?");
    STAssertNil(JSON[JivePersonJiveAttributes.externalContributor], @"externalContributor included?");
    STAssertNil(JSON[JivePersonJiveAttributes.federated], @"federated included?");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.lastProfileUpdate],
                         [dateFormatter stringFromDate:self.person.lastProfileUpdate],
                         @"Wrong last profile update");
    STAssertEqualObjects(JSON[JivePersonJiveAttributes.sendable], self.person.sendable, @"Wrong sendable");
    STAssertNil(JSON[JivePersonJiveAttributes.viewContent], @"viewContent included?");
    STAssertNil(JSON[JivePersonJiveAttributes.visible], @"visible included?");
    STAssertNil(JSON[JivePersonJiveAttributes.termsAndConditionsRequired],
                @"termsAndConditionsRequired included?");
    
    NSDictionary *levelJSON = JSON[JivePersonJiveAttributes.level];
    
    STAssertTrue([[levelJSON class] isSubclassOfClass:[NSDictionary class]], @"Level object not converted");
    STAssertEqualObjects(levelJSON[@"name"], level.name, @"Wrong level");
    
    NSArray *profilesJSON = JSON[JivePersonJiveAttributes.profile];
    NSDictionary *profileJSON = profilesJSON[0];
    
    STAssertTrue([[profilesJSON class] isSubclassOfClass:[NSArray class]], @"Profiles array not converted");
    STAssertEquals(profilesJSON.count, (NSUInteger)1, @"Wrong number of elements in the profiles array");
    STAssertTrue([[profileJSON class] isSubclassOfClass:[NSDictionary class]], @"Profile object not converted");
    STAssertEqualObjects(profileJSON[@"jive_label"], profile.jive_label, @"Wrong profile");
}

- (void)testPersonJiveParsing {
    JiveLevel *level = [JiveLevel new];
    JiveProfileEntry *profile = [JiveProfileEntry new];
    
    [level setValue:@"name" forKey:@"name"];
    [profile setValue:@"jive_label" forKey:@"jive_label"];
    self.person.password = @"Phone Number";
    self.person.locale = @"12345";
    self.person.timeZone = @"CST";
    self.person.username = @"Home";
    self.person.enabled = @YES;
    self.person.external = @YES;
    self.person.externalContributor = @YES;
    self.person.federated = @YES;
    [self.person setValue:[NSDate dateWithTimeIntervalSince1970:7239832] forKey:JivePersonJiveAttributes.lastProfileUpdate];
    [self.person setValue:level forKey:JivePersonJiveAttributes.level];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.sendable];
    [self.person setValue:@[profile] forKey:JivePersonJiveAttributes.profile];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.viewContent];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.visible];
    [self.person setValue:@YES forKey:JivePersonJiveAttributes.termsAndConditionsRequired];
    
    NSDictionary *JSON = [self.person persistentJSON];
    JivePersonJive *newPerson = [JivePersonJive objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newPerson class], [JivePersonJive class], @"Wrong item class");
    STAssertEqualObjects(newPerson.enabled, self.person.enabled, @"Wrong enabled");
    STAssertEqualObjects(newPerson.external, self.person.external, @"Wrong external");
    STAssertEqualObjects(newPerson.externalContributor, self.person.externalContributor,
                         @"Wrong externalContributor");
    STAssertEqualObjects(newPerson.federated, self.person.federated, @"Wrong federated");
    STAssertEqualObjects(newPerson.lastProfileUpdate, self.person.lastProfileUpdate,
                         @"Wrong update date");
    STAssertEqualObjects(newPerson.level.name, self.person.level.name, @"Wrong level name");
    STAssertEqualObjects(newPerson.locale, self.person.locale, @"Wrong locale");
    STAssertEqualObjects(newPerson.password, self.person.password, @"Wrong password");
    STAssertEqualObjects(newPerson.sendable, self.person.sendable, @"Wrong sendable");
    STAssertEqualObjects(newPerson.timeZone, self.person.timeZone, @"Wrong timeZone");
    STAssertEqualObjects(newPerson.username, self.person.username, @"Wrong username");
    STAssertEqualObjects(newPerson.viewContent, self.person.viewContent, @"Wrong viewContent");
    STAssertEqualObjects(newPerson.visible, self.person.visible, @"Wrong visible");
    STAssertEqualObjects(newPerson.termsAndConditionsRequired,
                         self.person.termsAndConditionsRequired, @"Wrong termsAndConditionsRequired");
    STAssertEquals(newPerson.profile.count, (NSUInteger)1, @"Wrong number of profile objects");
    if (newPerson.profile.count == 1)
        STAssertEqualObjects(((JiveProfileEntry *)newPerson.profile[0]).jive_label,
                             profile.jive_label, @"Wrong profile entry label");
}

- (void)testPersonJiveParsingAlternate {
    JiveLevel *level = [JiveLevel new];
    JiveProfileEntry *profile = [JiveProfileEntry new];
    
    [level setValue:@"Johnson" forKey:@"name"];
    [profile setValue:@"restless" forKey:@"jive_label"];
    self.person.password = @"helpless";
    self.person.locale = @"87654";
    self.person.timeZone = @"MDT";
    self.person.username = @"Work";
    [self.person setValue:[NSDate dateWithTimeIntervalSince1970:22222222]
                   forKey:JivePersonJiveAttributes.lastProfileUpdate];
    [self.person setValue:level forKey:JivePersonJiveAttributes.level];
    [self.person setValue:@NO forKey:JivePersonJiveAttributes.sendable];
    [self.person setValue:@[profile] forKey:JivePersonJiveAttributes.profile];
    
    NSDictionary *JSON = [self.person persistentJSON];
    JivePersonJive *newPerson = [JivePersonJive objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newPerson class], [JivePersonJive class], @"Wrong item class");
    STAssertEqualObjects(newPerson.enabled, self.person.enabled, @"Wrong enabled");
    STAssertEqualObjects(newPerson.external, self.person.external, @"Wrong external");
    STAssertEqualObjects(newPerson.externalContributor, self.person.externalContributor,
                         @"Wrong externalContributor");
    STAssertEqualObjects(newPerson.federated, self.person.federated, @"Wrong federated");
    STAssertEqualObjects(newPerson.lastProfileUpdate, self.person.lastProfileUpdate,
                         @"Wrong update date");
    STAssertEqualObjects(newPerson.level.name, self.person.level.name, @"Wrong level name");
    STAssertEqualObjects(newPerson.locale, self.person.locale, @"Wrong locale");
    STAssertEqualObjects(newPerson.password, self.person.password, @"Wrong password");
    STAssertEqualObjects(newPerson.sendable, self.person.sendable, @"Wrong sendable");
    STAssertEqualObjects(newPerson.timeZone, self.person.timeZone, @"Wrong timeZone");
    STAssertEqualObjects(newPerson.username, self.person.username, @"Wrong username");
    STAssertEqualObjects(newPerson.viewContent, self.person.viewContent, @"Wrong viewContent");
    STAssertEqualObjects(newPerson.visible, self.person.visible, @"Wrong visible");
    STAssertEqualObjects(newPerson.termsAndConditionsRequired,
                         self.person.termsAndConditionsRequired, @"Wrong termsAndConditionsRequired");
    STAssertEquals(newPerson.profile.count, (NSUInteger)1, @"Wrong number of profile objects");
    if (newPerson.profile.count == 1)
        STAssertEqualObjects(((JiveProfileEntry *)newPerson.profile[0]).jive_label,
                             profile.jive_label, @"Wrong profile entry label");
}

@end
