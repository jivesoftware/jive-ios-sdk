//
//  JiveStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
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

#import "JiveStreamTests.h"
#import "JiveResourceEntry.h"

@implementation JiveStreamTests

- (JiveStream *)stream {
    return (JiveStream *)self.typedObject;
}

- (void)setUp {
    [super setUp];
    self.object = [[JiveStream alloc] init];
}

- (void)testToJSON {
    JivePerson *person = [[JivePerson alloc] init];
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    person.location = @"location";
    self.stream.name = @"name";
    self.stream.receiveEmails = [NSNumber numberWithBool:YES];
    [self.stream setValue:@"source" forKey:@"source"];
    [self.stream setValue:@"not a real type" forKey:@"type"];
    [self.stream setValue:@"1234" forKey:@"jiveId"];
    [self.stream setValue:person forKey:@"person"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"name"], self.stream.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"receiveEmails"], self.stream.receiveEmails, @"Wrong receiveEmails");
    STAssertEqualObjects([JSON objectForKey:@"source"], self.stream.source, @"Wrong source");
}

- (void)testToJSON_alternate {
    JivePerson *person = [[JivePerson alloc] init];
    
    person.location = @"Tower";
    self.stream.name = @"William";
    [self.stream setValue:@"Writing" forKey:@"subject"];
    [self.stream setValue:@"another non-type" forKey:@"type"];
    [self.stream setValue:@"8743" forKey:@"jiveId"];
    [self.stream setValue:person forKey:@"author"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"name"], self.stream.name, @"Wrong name");
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
    person.location = @"location";
    self.stream.name = @"name";
    self.stream.receiveEmails = [NSNumber numberWithBool:YES];
    [self.stream setValue:@"source" forKey:@"source"];
    [self.stream setValue:@"not a real type" forKey:@"type"];
    [self.stream setValue:@"1234" forKey:@"jiveId"];
    [self.stream setValue:person forKey:@"person"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.stream setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[self.stream toJSONDictionary];
    
    [JSON setValue:self.stream.type forKey:@"type"];
    [JSON setValue:self.stream.jiveId forKey:@"id"];
    [JSON setValue:[person toJSONDictionary] forKey:@"person"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"published"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"updated"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStream *newStream = [JiveStream objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.jiveId, self.stream.jiveId, @"Wrong id");
    STAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.name, self.stream.name, @"Wrong name");
    STAssertEqualObjects(newStream.receiveEmails, self.stream.receiveEmails, @"Wrong receiveEmails");
    STAssertEqualObjects(newStream.source, self.stream.source, @"Wrong source");
    STAssertEqualObjects(newStream.person.location, self.stream.person.location, @"Wrong person");
    STAssertEqualObjects(newStream.published, self.stream.published, @"Wrong published");
    STAssertEqualObjects(newStream.updated, self.stream.updated, @"Wrong updated");
    STAssertEquals([newStream.resources count], [self.stream.resources count], @"Wrong number of resource objects");
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
    person.location = @"Tower";
    self.stream.name = @"William";
    [self.stream setValue:@"Writing" forKey:@"subject"];
    [self.stream setValue:@"another non-type" forKey:@"type"];
    [self.stream setValue:@"8743" forKey:@"jiveId"];
    [self.stream setValue:person forKey:@"person"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.stream setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[self.stream toJSONDictionary];
    
    [JSON setValue:self.stream.type forKey:@"type"];
    [JSON setValue:self.stream.jiveId forKey:@"id"];
    [JSON setValue:[person toJSONDictionary] forKey:@"person"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"published"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"updated"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStream *newStream = [JiveStream objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.jiveId, self.stream.jiveId, @"Wrong id");
    STAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.name, self.stream.name, @"Wrong name");
    STAssertEqualObjects(newStream.receiveEmails, self.stream.receiveEmails, @"Wrong receiveEmails");
    STAssertEqualObjects(newStream.source, @"custom", @"Wrong source");
    STAssertEqualObjects(newStream.person.location, self.stream.person.location, @"Wrong person");
    STAssertEqualObjects(newStream.published, self.stream.published, @"Wrong published");
    STAssertEqualObjects(newStream.updated, self.stream.updated, @"Wrong updated");
    STAssertEquals([newStream.resources count], [self.stream.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
