//
//  JiveInviteTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/11/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveInviteTests.h"
#import "JiveResourceEntry.h"

@implementation JiveInviteTests

@synthesize invite;

- (void)setUp {
    invite = [[JiveInvite alloc] init];
}

- (void)tearDown {
    invite = nil;
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
    [invite setValue:@"body" forKey:@"body"];
    [invite setValue:@"email" forKey:@"email"];
    [invite setValue:@"1234" forKey:@"jiveId"];
    [invite setValue:invitee forKey:@"invitee"];
    [invite setValue:inviter forKey:@"inviter"];
    [invite setValue:place forKey:@"place"];
    [invite setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [invite setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    [invite setValue:[NSDate dateWithTimeIntervalSince1970:0.123] forKey:@"revokeDate"];
    [invite setValue:revoker forKey:@"revoker"];
    [invite setValue:[NSDate dateWithTimeIntervalSince1970:1000] forKey:@"sentDate"];
    [invite setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:14];
    
    [JSON setValue:invite.body forKey:@"body"];
    [JSON setValue:invite.email forKey:@"email"];
    [JSON setValue:invite.jiveId forKey:@"id"];
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
    
    JiveInvite *newInvite = [JiveInvite instanceFromJSON:JSON];
    
    STAssertTrue([[newInvite class] isSubclassOfClass:[invite class]], @"Wrong item class");
    STAssertEqualObjects(newInvite.body, invite.body, @"Wrong body");
    STAssertEqualObjects(newInvite.email, invite.email, @"Wrong email");
    STAssertEqualObjects(newInvite.jiveId, invite.jiveId, @"Wrong id");
    STAssertEqualObjects(newInvite.invitee.location, invitee.location, @"Wrong invitee");
    STAssertEqualObjects(newInvite.inviter.location, inviter.location, @"Wrong inviter");
    STAssertEqualObjects(newInvite.place.displayName, place.displayName, @"Wrong place");
    STAssertEqualObjects(newInvite.published, invite.published, @"Wrong published");
    STAssertEqualObjects(newInvite.revokeDate, invite.revokeDate, @"Wrong revokeDate");
    STAssertEqualObjects(newInvite.revoker.location, revoker.location, @"Wrong revoker");
    STAssertEqualObjects(newInvite.sentDate, invite.sentDate, @"Wrong sentDate");
    STAssertEquals(newInvite.state, JiveInviteProcessing, @"Wrong state");
    STAssertEqualObjects(newInvite.type, @"invite", @"Wrong type");
    STAssertEqualObjects(newInvite.updated, invite.updated, @"Wrong updated");
    STAssertEquals([newInvite.resources count], [invite.resources count], @"Wrong number of resource objects");
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
    [invite setValue:@"Nothing to see here" forKey:@"body"];
    [invite setValue:@"orson.bushnell@jivesoftware.com" forKey:@"email"];
    [invite setValue:@"5678" forKey:@"jiveId"];
    [invite setValue:invitee forKey:@"invitee"];
    [invite setValue:inviter forKey:@"inviter"];
    [invite setValue:place forKey:@"place"];
    [invite setValue:[NSDate dateWithTimeIntervalSince1970:0.123] forKey:@"published"];
    [invite setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    [invite setValue:[NSDate dateWithTimeIntervalSince1970:1000] forKey:@"revokeDate"];
    [invite setValue:revoker forKey:@"revoker"];
    [invite setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"sentDate"];
    [invite setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:14];
    
    [JSON setValue:invite.body forKey:@"body"];
    [JSON setValue:invite.email forKey:@"email"];
    [JSON setValue:invite.jiveId forKey:@"id"];
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
    
    JiveInvite *newInvite = [JiveInvite instanceFromJSON:JSON];
    
    STAssertTrue([[newInvite class] isSubclassOfClass:[invite class]], @"Wrong item class");
    STAssertEqualObjects(newInvite.body, invite.body, @"Wrong body");
    STAssertEqualObjects(newInvite.email, invite.email, @"Wrong email");
    STAssertEqualObjects(newInvite.jiveId, invite.jiveId, @"Wrong id");
    STAssertEqualObjects(newInvite.invitee.location, invitee.location, @"Wrong invitee");
    STAssertEqualObjects(newInvite.inviter.location, inviter.location, @"Wrong inviter");
    STAssertEqualObjects(newInvite.place.displayName, place.displayName, @"Wrong place");
    STAssertEqualObjects(newInvite.published, invite.published, @"Wrong published");
    STAssertEqualObjects(newInvite.revokeDate, invite.revokeDate, @"Wrong revokeDate");
    STAssertEqualObjects(newInvite.revoker.location, revoker.location, @"Wrong revoker");
    STAssertEqualObjects(newInvite.sentDate, invite.sentDate, @"Wrong sentDate");
    STAssertEquals(newInvite.state, JiveInviteFulfilled, @"Wrong state");
    STAssertEqualObjects(newInvite.type, @"invite", @"Wrong type");
    STAssertEqualObjects(newInvite.updated, invite.updated, @"Wrong updated");
    STAssertEquals([newInvite.resources count], [invite.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newInvite.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingStateValues {
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:14];
    
    [JSON setValue:@"1234" forKey:@"id"];
    [JSON setValue:@"deleted" forKey:@"state"];
    
    JiveInvite *newInvite = [JiveInvite instanceFromJSON:JSON];
    
    STAssertEquals(newInvite.state, JiveInviteDeleted, @"Wrong state");
    
    [JSON setValue:@"revoked" forKey:@"state"];
    newInvite = [JiveInvite instanceFromJSON:JSON];
    STAssertEquals(newInvite.state, JiveInviteRevoked, @"Wrong state");
    
    [JSON setValue:@"sent" forKey:@"state"];
    newInvite = [JiveInvite instanceFromJSON:JSON];
    STAssertEquals(newInvite.state, JiveInviteSent, @"Wrong state");
}

- (void)testContentParsingStateInvalidValues {
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:14];
    
    [JSON setValue:@"1234" forKey:@"id"];
    [JSON setValue:@"delete" forKey:@"state"];
    
    JiveInvite *newInvite = [JiveInvite instanceFromJSON:JSON];
    
    STAssertEquals(newInvite.state, 0, @"Wrong state");
    
    [JSON setValue:@"revoke" forKey:@"state"];
    newInvite = [JiveInvite instanceFromJSON:JSON];
    STAssertEquals(newInvite.state, 0, @"Wrong state");
    
    [JSON setValue:@"sen" forKey:@"state"];
    newInvite = [JiveInvite instanceFromJSON:JSON];
    STAssertEquals(newInvite.state, 0, @"Wrong state");
}

@end