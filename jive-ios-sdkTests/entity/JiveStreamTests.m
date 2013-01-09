//
//  JiveStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveStreamTests.h"
#import "JiveResourceEntry.h"

@implementation JiveStreamTests

@synthesize stream;

- (void)setUp {
    stream = [[JiveStream alloc] init];
}

- (void)tearDown {
    stream = nil;
}

- (void)testToJSON {
    JivePerson *person = [[JivePerson alloc] init];
    NSDictionary *JSON = [stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    person.location = @"author";
    stream.name = @"name";
    stream.receiveEmails = [NSNumber numberWithBool:YES];
    [stream setValue:@"source" forKey:@"source"];
    [stream setValue:@"not a real type" forKey:@"type"];
    [stream setValue:@"1234" forKey:@"jiveId"];
    [stream setValue:person forKey:@"person"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    JSON = [stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"name"], stream.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"receiveEmails"], stream.receiveEmails, @"Wrong receiveEmails");
    STAssertEqualObjects([JSON objectForKey:@"source"], stream.source, @"Wrong source");
}

- (void)testToJSON_alternate {
    JivePerson *person = [[JivePerson alloc] init];
    
    person.location = @"Gibson";
    stream.name = @"William";
    [stream setValue:@"Writing" forKey:@"subject"];
    [stream setValue:@"another non-type" forKey:@"type"];
    [stream setValue:@"8743" forKey:@"jiveId"];
    [stream setValue:person forKey:@"author"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    NSDictionary *JSON = [stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"name"], stream.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"source"], @"custom", @"Wrong source");
}

- (void)testContentParsing {
    JivePerson *person = [[JivePerson alloc] init];
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    person.location = @"author";
    stream.name = @"name";
    stream.receiveEmails = [NSNumber numberWithBool:YES];
    [stream setValue:@"source" forKey:@"source"];
    [stream setValue:@"not a real type" forKey:@"type"];
    [stream setValue:@"1234" forKey:@"jiveId"];
    [stream setValue:person forKey:@"person"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [stream setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[stream toJSONDictionary];
    
    [JSON setValue:stream.type forKey:@"type"];
    [JSON setValue:stream.jiveId forKey:@"id"];
    [JSON setValue:[person toJSONDictionary] forKey:@"person"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"published"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"updated"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStream *newStream = [JiveStream instanceFromJSON:JSON];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.jiveId, stream.jiveId, @"Wrong id");
    STAssertEqualObjects(newStream.type, stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.name, stream.name, @"Wrong name");
    STAssertEqualObjects(newStream.receiveEmails, stream.receiveEmails, @"Wrong receiveEmails");
    STAssertEqualObjects(newStream.source, stream.source, @"Wrong source");
    STAssertEqualObjects(newStream.person.location, stream.person.location, @"Wrong person");
    STAssertEqualObjects(newStream.published, stream.published, @"Wrong published");
    STAssertEqualObjects(newStream.updated, stream.updated, @"Wrong updated");
    STAssertEquals([newStream.resources count], [stream.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingAlternate {
    JivePerson *person = [[JivePerson alloc] init];
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    person.location = @"Gibson";
    stream.name = @"William";
    [stream setValue:@"Writing" forKey:@"subject"];
    [stream setValue:@"another non-type" forKey:@"type"];
    [stream setValue:@"8743" forKey:@"jiveId"];
    [stream setValue:person forKey:@"person"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [stream setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[stream toJSONDictionary];
    
    [JSON setValue:stream.type forKey:@"type"];
    [JSON setValue:stream.jiveId forKey:@"id"];
    [JSON setValue:[person toJSONDictionary] forKey:@"person"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"published"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"updated"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStream *newStream = [JiveStream instanceFromJSON:JSON];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.jiveId, stream.jiveId, @"Wrong id");
    STAssertEqualObjects(newStream.type, stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.name, stream.name, @"Wrong name");
    STAssertEqualObjects(newStream.receiveEmails, stream.receiveEmails, @"Wrong receiveEmails");
    STAssertEqualObjects(newStream.source, @"custom", @"Wrong source");
    STAssertEqualObjects(newStream.person.location, stream.person.location, @"Wrong person");
    STAssertEqualObjects(newStream.published, stream.published, @"Wrong published");
    STAssertEqualObjects(newStream.updated, stream.updated, @"Wrong updated");
    STAssertEquals([newStream.resources count], [stream.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
