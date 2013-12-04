//
//  JiveInviteTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/11/13.
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

#import "JiveInviteTests.h"
#import "JiveResourceEntry.h"
#import "JiveTypedObject_internal.h"

@implementation JiveInviteTests

- (JiveInvite *)invite {
    return (JiveInvite *)self.typedObject;
}

- (void)setUp {
    [super setUp];
    self.object = [[JiveInvite alloc] init];
}

- (void)testContentParsing {
    JivePerson *invitee = [[JivePerson alloc] init];
    JivePerson *inviter = [[JivePerson alloc] init];
    JivePerson *revoker = [[JivePerson alloc] init];
    JivePlace *place = [[JivePlace alloc] init];
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    invitee.location = @"invitee";
    inviter.location = @"inviter";
    revoker.location = @"revoker";
    place.displayName = @"place";
    [self.invite setValue:@"body" forKey:@"body"];
    [self.invite setValue:@"email" forKey:@"email"];
    [self.invite setValue:@"1234" forKey:@"jiveId"];
    [self.invite setValue:invitee forKey:@"invitee"];
    [self.invite setValue:inviter forKey:@"inviter"];
    [self.invite setValue:place forKey:@"place"];
    [self.invite setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.invite setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    [self.invite setValue:[NSDate dateWithTimeIntervalSince1970:0.123] forKey:@"revokeDate"];
    [self.invite setValue:revoker forKey:@"revoker"];
    [self.invite setValue:[NSDate dateWithTimeIntervalSince1970:1000] forKey:@"sentDate"];
    [self.invite setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:14];
    
    [JSON setValue:self.invite.body forKey:@"body"];
    [JSON setValue:self.invite.email forKey:@"email"];
    [JSON setValue:self.invite.jiveId forKey:@"id"];
    [JSON setValue:[invitee toJSONDictionary] forKey:@"invitee"];
    [JSON setValue:[inviter toJSONDictionary] forKey:@"inviter"];
    [JSON setValue:[place toJSONDictionary] forKey:@"place"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"published"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    [JSON setValue:@"1970-01-01T00:00:00.123+0000" forKey:@"revokeDate"];
    [JSON setValue:[revoker toJSONDictionary] forKey:@"revoker"];
    [JSON setValue:@"1970-01-01T00:16:40.000+0000" forKey:@"sentDate"];
    [JSON setValue:@"processing" forKey:@"state"];
    [JSON setValue:@"not a real type" forKey:@"type"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"updated"];
    
    JiveInvite *newInvite = [JiveInvite objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newInvite class] isSubclassOfClass:[self.invite class]], @"Wrong item class");
    STAssertEqualObjects(newInvite.body, self.invite.body, @"Wrong body");
    STAssertEqualObjects(newInvite.email, self.invite.email, @"Wrong email");
    STAssertEqualObjects(newInvite.jiveId, self.invite.jiveId, @"Wrong id");
    STAssertEqualObjects(newInvite.invitee.location, invitee.location, @"Wrong invitee");
    STAssertEqualObjects(newInvite.inviter.location, inviter.location, @"Wrong inviter");
    STAssertEqualObjects(newInvite.place.displayName, place.displayName, @"Wrong place");
    STAssertEqualObjects(newInvite.published, self.invite.published, @"Wrong published");
    STAssertEqualObjects(newInvite.revokeDate, self.invite.revokeDate, @"Wrong revokeDate");
    STAssertEqualObjects(newInvite.revoker.location, revoker.location, @"Wrong revoker");
    STAssertEqualObjects(newInvite.sentDate, self.invite.sentDate, @"Wrong sentDate");
    STAssertEquals(newInvite.state, JiveInviteProcessing, @"Wrong state");
    STAssertEqualObjects(newInvite.type, @"invite", @"Wrong type");
    STAssertEqualObjects(newInvite.updated, self.invite.updated, @"Wrong updated");
    STAssertEquals([newInvite.resources count], [self.invite.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newInvite.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingAlternate {
    JivePerson *invitee = [[JivePerson alloc] init];
    JivePerson *inviter = [[JivePerson alloc] init];
    JivePerson *revoker = [[JivePerson alloc] init];
    JivePlace *place = [[JivePlace alloc] init];
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    invitee.location = @"New York City";
    inviter.location = @"San Andreas";
    revoker.location = @"Denver";
    place.displayName = @"Restaurant";
    [self.invite setValue:@"Nothing to see here" forKey:@"body"];
    [self.invite setValue:@"orson.bushnell@jivesoftware.com" forKey:@"email"];
    [self.invite setValue:@"5678" forKey:@"jiveId"];
    [self.invite setValue:invitee forKey:@"invitee"];
    [self.invite setValue:inviter forKey:@"inviter"];
    [self.invite setValue:place forKey:@"place"];
    [self.invite setValue:[NSDate dateWithTimeIntervalSince1970:0.123] forKey:@"published"];
    [self.invite setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    [self.invite setValue:[NSDate dateWithTimeIntervalSince1970:1000] forKey:@"revokeDate"];
    [self.invite setValue:revoker forKey:@"revoker"];
    [self.invite setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"sentDate"];
    [self.invite setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:14];
    
    [JSON setValue:self.invite.body forKey:@"body"];
    [JSON setValue:self.invite.email forKey:@"email"];
    [JSON setValue:self.invite.jiveId forKey:@"id"];
    [JSON setValue:[invitee toJSONDictionary] forKey:@"invitee"];
    [JSON setValue:[inviter toJSONDictionary] forKey:@"inviter"];
    [JSON setValue:[place toJSONDictionary] forKey:@"place"];
    [JSON setValue:@"1970-01-01T00:00:00.123+0000" forKey:@"published"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    [JSON setValue:@"1970-01-01T00:16:40.000+0000" forKey:@"revokeDate"];
    [JSON setValue:[revoker toJSONDictionary] forKey:@"revoker"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"sentDate"];
    [JSON setValue:@"fulfilled" forKey:@"state"];
    [JSON setValue:@"not a real type" forKey:@"type"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"updated"];
    
    JiveInvite *newInvite = [JiveInvite objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newInvite class] isSubclassOfClass:[self.invite class]], @"Wrong item class");
    STAssertEqualObjects(newInvite.body, self.invite.body, @"Wrong body");
    STAssertEqualObjects(newInvite.email, self.invite.email, @"Wrong email");
    STAssertEqualObjects(newInvite.jiveId, self.invite.jiveId, @"Wrong id");
    STAssertEqualObjects(newInvite.invitee.location, invitee.location, @"Wrong invitee");
    STAssertEqualObjects(newInvite.inviter.location, inviter.location, @"Wrong inviter");
    STAssertEqualObjects(newInvite.place.displayName, place.displayName, @"Wrong place");
    STAssertEqualObjects(newInvite.published, self.invite.published, @"Wrong published");
    STAssertEqualObjects(newInvite.revokeDate, self.invite.revokeDate, @"Wrong revokeDate");
    STAssertEqualObjects(newInvite.revoker.location, revoker.location, @"Wrong revoker");
    STAssertEqualObjects(newInvite.sentDate, self.invite.sentDate, @"Wrong sentDate");
    STAssertEquals(newInvite.state, JiveInviteFulfilled, @"Wrong state");
    STAssertEqualObjects(newInvite.type, @"invite", @"Wrong type");
    STAssertEqualObjects(newInvite.updated, self.invite.updated, @"Wrong updated");
    STAssertEquals([newInvite.resources count], [self.invite.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newInvite.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingStateValues {
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:14];
    
    [JSON setValue:@"1234" forKey:@"id"];
    [JSON setValue:@"deleted" forKey:@"state"];
    
    JiveInvite *newInvite = [JiveInvite objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals(newInvite.state, JiveInviteDeleted, @"Wrong state");
    
    [JSON setValue:@"revoked" forKey:@"state"];
    newInvite = [JiveInvite objectFromJSON:JSON withInstance:self.instance];
    STAssertEquals(newInvite.state, JiveInviteRevoked, @"Wrong state");
    
    [JSON setValue:@"sent" forKey:@"state"];
    newInvite = [JiveInvite objectFromJSON:JSON withInstance:self.instance];
    STAssertEquals(newInvite.state, JiveInviteSent, @"Wrong state");
}

- (void)testContentParsingStateInvalidValues {
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:14];
    
    [JSON setValue:@"1234" forKey:@"id"];
    [JSON setValue:@"delete" forKey:@"state"];
    
    JiveInvite *newInvite = [JiveInvite objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals(newInvite.state, 0, @"Wrong state");
    
    [JSON setValue:@"revoke" forKey:@"state"];
    newInvite = [JiveInvite objectFromJSON:JSON withInstance:self.instance];
    STAssertEquals(newInvite.state, 0, @"Wrong state");
    
    [JSON setValue:@"sen" forKey:@"state"];
    newInvite = [JiveInvite objectFromJSON:JSON withInstance:self.instance];
    STAssertEquals(newInvite.state, 0, @"Wrong state");
}

@end
