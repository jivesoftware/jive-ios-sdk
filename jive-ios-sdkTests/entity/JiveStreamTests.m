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

#import "JiveTypedObjectTests.h"
#import "JiveStream_internal.h"
#import "JiveResourceEntry.h"
#import "JiveTypedObject_internal.h"


@interface JiveStreamTests : JiveTypedObjectTests

@property (nonatomic, readonly) JiveStream *stream;
@property (nonatomic, strong) JivePerson *person;

@end


@implementation JiveStreamTests

- (JiveStream *)stream {
    return (JiveStream *)self.typedObject;
}

- (void)setUp {
    [super setUp];
    self.object = [JiveStream new];
    self.person = [JivePerson new];
}

- (void)tearDown {
    self.person = nil;
    [super tearDown];
}

- (void)setupTestStream {
    self.person.location = @"location";
    self.stream.name = @"name";
    self.stream.receiveEmails = @YES;
    [self.stream setValue:@5 forKeyPath:JiveStreamAttributes.count];
    [self.stream setValue:@"1234" forKey:JiveObjectAttributes.jiveId];
    [self.stream setValue:self.person forKey:JiveStreamAttributes.person];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0]
                   forKey:JiveStreamAttributes.published];
    [self.stream setValue:JiveStreamSourceValues.connections forKey:JiveStreamAttributes.source];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                   forKey:JiveStreamAttributes.updated];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:56789]
                   forKey:JiveStreamAttributes.updatesNew];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:3456]
                   forKey:JiveStreamAttributes.updatesPrevious];
}

- (void)setupAlternateTestStream {
    self.person.location = @"Tower";
    self.stream.name = @"William";
    [self.stream setValue:@"Writing" forKey:@"subject"];
    [self.stream setValue:@"another non-type" forKey:JiveTypedObjectAttributes.type];
    [self.stream setValue:@"8743" forKey:JiveObjectAttributes.jiveId];
    [self.stream setValue:self.person forKey:JiveStreamAttributes.person];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                   forKey:JiveStreamAttributes.published];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0]
                   forKey:JiveStreamAttributes.updated];
    [self.stream setValue:@50 forKeyPath:JiveStreamAttributes.count];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:3456]
                   forKey:JiveStreamAttributes.updatesNew];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:56789]
                   forKey:JiveStreamAttributes.updatesPrevious];
}

- (void)testStreamToJSON {
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self setupTestStream];
    [self.stream setValue:@"not a real type" forKey:JiveTypedObjectAttributes.type];
    
    STAssertNoThrow(JSON = [self.stream toJSONDictionary], @"This is the method under test");
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.name], self.stream.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.receiveEmails],
                         self.stream.receiveEmails, @"Wrong receiveEmails");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.source], self.stream.source, @"Wrong source");
}

- (void)testStreamToJSON_alternate {
    [self setupAlternateTestStream];
    
    NSDictionary *JSON;
    
    STAssertNoThrow(JSON = [self.stream toJSONDictionary], @"This is the method under test");
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.name], self.stream.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.source],
                         JiveStreamSourceValues.custom, @"Wrong source");
}

- (void)testStreamPersistentJSON {
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self setupTestStream];
    [self.stream setValue:@"not a real type" forKey:JiveTypedObjectAttributes.type];
    
    STAssertNoThrow(JSON = [self.stream persistentJSON], @"This is the method under test");
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.receiveEmails],
                         self.stream.receiveEmails, @"Wrong receiveEmails");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.count], self.stream.count, nil);
    STAssertEqualObjects([JSON objectForKey:JiveObjectConstants.id], self.stream.jiveId, nil);
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.name], self.stream.name, nil);
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.source],
                         JiveStreamSourceValues.connections, nil);
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, nil);
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.published],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.updated],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:JiveStreamJSONAttributes.newUpdates],
                         @"1970-01-01T15:46:29.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:JiveStreamJSONAttributes.previousUpdates],
                         @"1970-01-01T00:57:36.000+0000", @"Wrong updated");
    
    NSDictionary *personJSON = [JSON objectForKey:JiveStreamAttributes.person];
    
    STAssertTrue([[personJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([personJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([personJSON objectForKey:JivePersonAttributes.location],
                         self.person.location, @"Wrong value");
}

- (void)testStreamPersistentJSON_alternate {
    [self setupAlternateTestStream];
    
    NSDictionary *JSON;
    
    STAssertNoThrow(JSON = [self.stream persistentJSON], @"This is the method under test");
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.count], self.stream.count, nil);
    STAssertEqualObjects([JSON objectForKey:JiveObjectConstants.id], self.stream.jiveId, nil);
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.name], self.stream.name, nil);
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.source],
                         JiveStreamSourceValues.custom, nil);
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, nil);
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.published],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:JiveStreamAttributes.updated],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:JiveStreamJSONAttributes.newUpdates],
                         @"1970-01-01T00:57:36.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:JiveStreamJSONAttributes.previousUpdates],
                         @"1970-01-01T15:46:29.000+0000", @"Wrong updated");
    
    NSDictionary *personJSON = [JSON objectForKey:JiveStreamAttributes.person];
    
    STAssertTrue([[personJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([personJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([personJSON objectForKey:JivePersonAttributes.location],
                         self.person.location, @"Wrong value");
}

- (void)testStreamParsing {
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    
    [self setupTestStream];
    [resource setValue:[NSURL URLWithString:contentType] forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [self.stream setValue:@{resourceKey:resource}
               forKeyPath:JiveTypedObjectAttributesHidden.resources];
    
    NSDictionary *JSON;
    
    STAssertNoThrow(JSON = [self.stream persistentJSON], @"PRECONDITION");
    
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
    STAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref],
                         resource.ref, @"Wrong resource object");
    STAssertEqualObjects(newStream.count, self.stream.count, nil);
    STAssertEqualObjects(newStream.updatesNew, self.stream.updatesNew, nil);
    STAssertEqualObjects(newStream.updatesPrevious, self.stream.updatesPrevious, nil);
}

- (void)testStreamParsingAlternate {
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    
    [self setupAlternateTestStream];
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [self.stream setValue:@{resourceKey:resource}
               forKeyPath:JiveTypedObjectAttributesHidden.resources];
    
    NSDictionary *JSON;
    
    STAssertNoThrow(JSON = [self.stream persistentJSON], @"PRECONDITION");
    
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
    STAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref],
                         resource.ref, @"Wrong resource object");
    STAssertEqualObjects(newStream.count, self.stream.count, nil);
    STAssertEqualObjects(newStream.updatesNew, self.stream.updatesNew, nil);
    STAssertEqualObjects(newStream.updatesPrevious, self.stream.updatesPrevious, nil);
}

@end
