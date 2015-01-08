//
//  JiveStaticTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveStaticTests.h"
#import "JiveBlog.h"
#import "JiveResourceEntry.h"

@implementation JiveStaticTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveStatic alloc] init];
}

- (JiveStatic *)jiveStatic {
    return (JiveStatic *)self.object;
}

- (void)testToJSON {
    JivePerson *author = [[JivePerson alloc] init];
    JiveBlog *place = [[JiveBlog alloc] init];
    NSDictionary *JSON = [self.jiveStatic toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"static", @"Wrong type");
    
    author.location = @"location";
    place.displayName = @"place";
    self.jiveStatic.jiveDescription = @"description";
    self.jiveStatic.filename = @"filename";
    [self.jiveStatic setValue:@"1234" forKey:@"jiveId"];
    [self.jiveStatic setValue:author forKey:@"author"];
    [self.jiveStatic setValue:place forKey:@"place"];
    [self.jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    JSON = [self.jiveStatic toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.jiveStatic.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.jiveStatic.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"description"], self.jiveStatic.jiveDescription, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"filename"], self.jiveStatic.filename, @"Wrong filename");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    
    NSDictionary *authorJSON = [JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:@"location"], author.location, @"Wrong value");
    
    NSDictionary *placeJSON = [JSON objectForKey:@"place"];
    
    STAssertTrue([[placeJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([placeJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([placeJSON objectForKey:@"displayName"], place.displayName, @"Wrong value");
}

- (void)testToJSON_alternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveBlog *place = [[JiveBlog alloc] init];
    
    author.location = @"Tower";
    place.displayName = @"Home";
    self.jiveStatic.jiveDescription = @"nothing";
    self.jiveStatic.filename = @"bad ju ju";
    [self.jiveStatic setValue:@"8743" forKey:@"jiveId"];
    [self.jiveStatic setValue:author forKey:@"author"];
    [self.jiveStatic setValue:place forKey:@"place"];
    [self.jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    NSDictionary *JSON = [self.jiveStatic toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.jiveStatic.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.jiveStatic.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"description"], self.jiveStatic.jiveDescription, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"filename"], self.jiveStatic.filename, @"Wrong filename");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    
    NSDictionary *authorJSON = [JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:@"location"], author.location, @"Wrong value");
    
    NSDictionary *placeJSON = [JSON objectForKey:@"place"];
    
    STAssertTrue([[placeJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([placeJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([placeJSON objectForKey:@"displayName"], place.displayName, @"Wrong value");
}

- (void)testContentParsing {
    JivePerson *author = [[JivePerson alloc] init];
    JiveBlog *place = [[JiveBlog alloc] init];
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    author.location = @"location";
    place.displayName = @"place";
    self.jiveStatic.jiveDescription = @"description";
    self.jiveStatic.filename = @"filename";
    [self.jiveStatic setValue:@"1234" forKey:@"jiveId"];
    [self.jiveStatic setValue:author forKey:@"author"];
    [self.jiveStatic setValue:place forKey:@"place"];
    [self.jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"updated"];
    [self.jiveStatic setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.jiveStatic toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStatic *newStatic = [JiveStatic objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newStatic class] isSubclassOfClass:[self.jiveStatic class]], @"Wrong item class");
    STAssertEqualObjects(newStatic.jiveId, self.jiveStatic.jiveId, @"Wrong id");
    STAssertEqualObjects(newStatic.type, self.jiveStatic.type, @"Wrong type");
    STAssertEqualObjects(newStatic.jiveDescription, self.jiveStatic.jiveDescription, @"Wrong description");
    STAssertEqualObjects(newStatic.filename, self.jiveStatic.filename, @"Wrong filename");
    STAssertEqualObjects(newStatic.published, self.jiveStatic.published, @"Wrong published");
    STAssertEqualObjects(newStatic.updated, self.jiveStatic.updated, @"Wrong updated");
    STAssertEqualObjects(newStatic.author.location, self.jiveStatic.author.location, @"Wrong author.location");
    STAssertEqualObjects(newStatic.place.displayName, self.jiveStatic.place.displayName, @"Wrong place.displayName");
}

- (void)testContentParsingAlternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveBlog *place = [[JiveBlog alloc] init];
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    author.location = @"Tower";
    place.displayName = @"Home";
    self.jiveStatic.jiveDescription = @"nothing";
    self.jiveStatic.filename = @"bad ju ju";
    [self.jiveStatic setValue:@"8743" forKey:@"jiveId"];
    [self.jiveStatic setValue:author forKey:@"author"];
    [self.jiveStatic setValue:place forKey:@"place"];
    [self.jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"published"];
    [self.jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.jiveStatic setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.jiveStatic toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStatic *newStatic = [JiveStatic objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newStatic class] isSubclassOfClass:[self.jiveStatic class]], @"Wrong item class");
    STAssertEqualObjects(newStatic.jiveId, self.jiveStatic.jiveId, @"Wrong id");
    STAssertEqualObjects(newStatic.type, self.jiveStatic.type, @"Wrong type");
    STAssertEqualObjects(newStatic.jiveDescription, self.jiveStatic.jiveDescription, @"Wrong description");
    STAssertEqualObjects(newStatic.filename, self.jiveStatic.filename, @"Wrong filename");
    STAssertEqualObjects(newStatic.published, self.jiveStatic.published, @"Wrong published");
    STAssertEqualObjects(newStatic.updated, self.jiveStatic.updated, @"Wrong updated");
    STAssertEqualObjects(newStatic.author.location, self.jiveStatic.author.location, @"Wrong author.location");
    STAssertEqualObjects(newStatic.place.displayName, self.jiveStatic.place.displayName, @"Wrong place.displayName");
}

@end
