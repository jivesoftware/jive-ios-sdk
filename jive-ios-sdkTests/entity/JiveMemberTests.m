//
//  JiveMemberTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
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

#import "JiveMemberTests.h"
#import "JiveResourceEntry.h"

@implementation JiveMemberTests

@synthesize member;

- (void)setUp {
    member = [[JiveMember alloc] init];
}

- (void)tearDown {
    member = nil;
}

- (void)testToJSON {
    JivePerson *person = [[JivePerson alloc] init];
    JiveGroup *group = [[JiveGroup alloc] init];
    NSDictionary *JSON = [member toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"member", @"Wrong type");
    
    person.location = @"location";
    group.displayName = @"group";
    member.state = @"banned";
    [member setValue:@"1234" forKey:@"jiveId"];
    [member setValue:person forKey:@"person"];
    [member setValue:group forKey:@"group"];
    [member setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [member setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    JSON = [member toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], member.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"type"], member.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"state"], member.state, @"Wrong state");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    
    NSDictionary *personJSON = [JSON objectForKey:@"person"];
    
    STAssertTrue([[personJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([personJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([personJSON objectForKey:@"location"], person.location, @"Wrong value");
    
    NSDictionary *groupJSON = [JSON objectForKey:@"group"];
    
    STAssertTrue([[groupJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([groupJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([groupJSON objectForKey:@"displayName"], group.displayName, @"Wrong value");
}

- (void)testToJSON_alternate {
    JivePerson *person = [[JivePerson alloc] init];
    JiveGroup *group = [[JiveGroup alloc] init];
    
    person.location = @"Tower";
    group.displayName = @"group";
    member.state = @"member";
    [member setValue:@"8743" forKey:@"jiveId"];
    [member setValue:person forKey:@"person"];
    [member setValue:group forKey:@"group"];
    [member setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [member setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    NSDictionary *JSON = [member toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], member.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"type"], member.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"state"], member.state, @"Wrong state");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    
    NSDictionary *personJSON = [JSON objectForKey:@"person"];
    
    STAssertTrue([[personJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([personJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([personJSON objectForKey:@"location"], person.location, @"Wrong value");
    
    NSDictionary *groupJSON = [JSON objectForKey:@"group"];
    
    STAssertTrue([[groupJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([groupJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([groupJSON objectForKey:@"displayName"], group.displayName, @"Wrong value");
}

- (void)testContentParsing {
    JivePerson *person = [[JivePerson alloc] init];
    JiveGroup *group = [[JiveGroup alloc] init];
    NSString *memberType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:memberType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:memberType] forKey:@"ref"];
    person.location = @"location";
    group.displayName = @"group";
    member.state = @"banned";
    [member setValue:@"1234" forKey:@"jiveId"];
    [member setValue:person forKey:@"person"];
    [member setValue:group forKey:@"group"];
    [member setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [member setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [member setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [member toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveMember *newMember = [JiveMember instanceFromJSON:JSON];
    
    STAssertTrue([[newMember class] isSubclassOfClass:[member class]], @"Wrong item class");
    STAssertEqualObjects(newMember.jiveId, member.jiveId, @"Wrong id");
    STAssertEqualObjects(newMember.type, member.type, @"Wrong type");
    STAssertEqualObjects(newMember.person.location, member.person.location, @"Wrong person");
    STAssertEqualObjects(newMember.group.displayName, member.group.displayName, @"Wrong group");
    STAssertEqualObjects(newMember.published, member.published, @"Wrong published");
    STAssertEqualObjects(newMember.updated, member.updated, @"Wrong updated");
    STAssertEqualObjects(newMember.state, member.state, @"Wrong state");
    STAssertEquals([newMember.resources count], [member.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newMember.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingAlternate {
    JivePerson *person = [[JivePerson alloc] init];
    JiveGroup *group = [[JiveGroup alloc] init];
    NSString *memberType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:memberType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:memberType] forKey:@"ref"];
    person.location = @"Tower";
    group.displayName = @"group";
    member.state = @"member";
    [member setValue:@"8743" forKey:@"jiveId"];
    [member setValue:person forKey:@"person"];
    [member setValue:group forKey:@"group"];
    [member setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [member setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [member setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [member toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveMember *newMember = [JiveMember instanceFromJSON:JSON];
    
    STAssertTrue([[newMember class] isSubclassOfClass:[member class]], @"Wrong item class");
    STAssertEqualObjects(newMember.jiveId, member.jiveId, @"Wrong id");
    STAssertEqualObjects(newMember.type, member.type, @"Wrong type");
    STAssertEqualObjects(newMember.person.location, member.person.location, @"Wrong person");
    STAssertEqualObjects(newMember.group.displayName, member.group.displayName, @"Wrong group");
    STAssertEqualObjects(newMember.published, member.published, @"Wrong published");
    STAssertEqualObjects(newMember.updated, member.updated, @"Wrong updated");
    STAssertEqualObjects(newMember.state, member.state, @"Wrong state");
    STAssertEquals([newMember.resources count], [member.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newMember.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
