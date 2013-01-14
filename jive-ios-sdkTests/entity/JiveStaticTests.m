//
//  JiveStaticTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveStaticTests.h"
#import "JiveBlog.h"
#import "JiveResourceEntry.h"

@implementation JiveStaticTests

@synthesize jiveStatic;

- (void)setUp {
    jiveStatic = [[JiveStatic alloc] init];
}

- (void)tearDown {
    jiveStatic = nil;
}

- (void)testToJSON {
    JivePerson *author = [[JivePerson alloc] init];
    JiveBlog *place = [[JiveBlog alloc] init];
    NSDictionary *JSON = [jiveStatic toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"static", @"Wrong type");
    
    author.location = @"author";
    place.displayName = @"place";
    jiveStatic.description = @"description";
    jiveStatic.filename = @"filename";
    [jiveStatic setValue:@"1234" forKey:@"jiveId"];
    [jiveStatic setValue:author forKey:@"author"];
    [jiveStatic setValue:place forKey:@"place"];
    [jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    JSON = [jiveStatic toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], jiveStatic.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"type"], jiveStatic.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"description"], jiveStatic.description, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"filename"], jiveStatic.filename, @"Wrong filename");
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
    
    author.location = @"Gibson";
    place.displayName = @"Home";
    jiveStatic.description = @"nothing";
    jiveStatic.filename = @"bad ju ju";
    [jiveStatic setValue:@"8743" forKey:@"jiveId"];
    [jiveStatic setValue:author forKey:@"author"];
    [jiveStatic setValue:place forKey:@"place"];
    [jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    NSDictionary *JSON = [jiveStatic toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], jiveStatic.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"type"], jiveStatic.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"description"], jiveStatic.description, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"filename"], jiveStatic.filename, @"Wrong filename");
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
    author.location = @"author";
    place.displayName = @"place";
    jiveStatic.description = @"description";
    jiveStatic.filename = @"filename";
    [jiveStatic setValue:@"1234" forKey:@"jiveId"];
    [jiveStatic setValue:author forKey:@"author"];
    [jiveStatic setValue:place forKey:@"place"];
    [jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"updated"];
    [jiveStatic setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [jiveStatic toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStatic *newStatic = [JiveStatic instanceFromJSON:JSON];
    
    STAssertTrue([[newStatic class] isSubclassOfClass:[jiveStatic class]], @"Wrong item class");
    STAssertEqualObjects(newStatic.jiveId, jiveStatic.jiveId, @"Wrong id");
    STAssertEqualObjects(newStatic.type, jiveStatic.type, @"Wrong type");
    STAssertEqualObjects(newStatic.description, jiveStatic.description, @"Wrong description");
    STAssertEqualObjects(newStatic.filename, jiveStatic.filename, @"Wrong filename");
    STAssertEqualObjects(newStatic.published, jiveStatic.published, @"Wrong published");
    STAssertEqualObjects(newStatic.updated, jiveStatic.updated, @"Wrong updated");
    STAssertEqualObjects(newStatic.author.location, jiveStatic.author.location, @"Wrong author.location");
    STAssertEqualObjects(newStatic.place.displayName, jiveStatic.place.displayName, @"Wrong place.displayName");
    STAssertEquals([newStatic.resources count], [jiveStatic.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newStatic.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
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
    author.location = @"Gibson";
    place.displayName = @"Home";
    jiveStatic.description = @"nothing";
    jiveStatic.filename = @"bad ju ju";
    [jiveStatic setValue:@"8743" forKey:@"jiveId"];
    [jiveStatic setValue:author forKey:@"author"];
    [jiveStatic setValue:place forKey:@"place"];
    [jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"published"];
    [jiveStatic setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [jiveStatic setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [jiveStatic toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStatic *newStatic = [JiveStatic instanceFromJSON:JSON];
    
    STAssertTrue([[newStatic class] isSubclassOfClass:[jiveStatic class]], @"Wrong item class");
    STAssertEqualObjects(newStatic.jiveId, jiveStatic.jiveId, @"Wrong id");
    STAssertEqualObjects(newStatic.type, jiveStatic.type, @"Wrong type");
    STAssertEqualObjects(newStatic.description, jiveStatic.description, @"Wrong description");
    STAssertEqualObjects(newStatic.filename, jiveStatic.filename, @"Wrong filename");
    STAssertEqualObjects(newStatic.published, jiveStatic.published, @"Wrong published");
    STAssertEqualObjects(newStatic.updated, jiveStatic.updated, @"Wrong updated");
    STAssertEqualObjects(newStatic.author.location, jiveStatic.author.location, @"Wrong author.location");
    STAssertEqualObjects(newStatic.place.displayName, jiveStatic.place.displayName, @"Wrong place.displayName");
    STAssertEquals([newStatic.resources count], [jiveStatic.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newStatic.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
