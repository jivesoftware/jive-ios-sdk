//
//  JiveCategory.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveCategoryTests.h"
#import "JiveResourceEntry.h"
#import "NSThread+JiveISO8601DateFormatter.h"

@implementation JiveCategoryTests

@synthesize category;

- (void)setUp {
    category = [[JiveCategory alloc] init];
}

- (void)tearDown {
    category = nil;
}

- (void)testToJSON {
    NSString *description = @"description";
    NSNumber *followerCount = [NSNumber numberWithInt:7];
    NSString *jiveId = @"1234";
    NSNumber *likeCount = [NSNumber numberWithInt:4];
    NSString *name = @"name";
    NSString *place = @"/place/54321";
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *tag = @"First";
    NSDate *updated = [NSDate dateWithTimeIntervalSince1970:1000.123];
    NSDictionary *JSON = [category toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"category", @"Wrong type");
    
    [category setValue:description forKey:@"description"];
    [category setValue:followerCount forKey:@"followerCount"];
    [category setValue:jiveId forKey:@"jiveId"];
    [category setValue:likeCount forKey:@"likeCount"];
    [category setValue:name forKey:@"name"];
    [category setValue:place forKey:@"place"];
    [category setValue:published forKey:@"published"];
    [category setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [category setValue:@"type" forKey:@"type"];
    [category setValue:updated forKey:@"updated"];
    
    JSON = [category toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"description"], description, @"Wrong description.");
    STAssertEqualObjects([JSON objectForKey:@"name"], name, @"Wrong name.");
    STAssertEqualObjects([JSON objectForKey:@"type"], category.type, @"Wrong type");
}

- (void)testToJSON_alternate {
    NSString *description = @"alternate";
    NSNumber *followerCount = [NSNumber numberWithInt:17];
    NSString *jiveId = @"5432";
    NSNumber *likeCount = [NSNumber numberWithInt:40];
    NSString *name = @"place";
    NSString *place = @"/content/76543";
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:1000.123];
    NSString *tag = @"Gigantic";
    NSDate *updated = [NSDate dateWithTimeIntervalSince1970:0];
    
    [category setValue:description forKey:@"description"];
    [category setValue:followerCount forKey:@"followerCount"];
    [category setValue:jiveId forKey:@"jiveId"];
    [category setValue:likeCount forKey:@"likeCount"];
    [category setValue:name forKey:@"name"];
    [category setValue:place forKey:@"place"];
    [category setValue:published forKey:@"published"];
    [category setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [category setValue:updated forKey:@"updated"];
    
    NSDictionary *JSON = [category toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"description"], description, @"Wrong description.");
    STAssertEqualObjects([JSON objectForKey:@"name"], name, @"Wrong name.");
    STAssertEqualObjects([JSON objectForKey:@"type"], category.type, @"Wrong type");
}

- (void)testCategoryParsing {
    NSString *photoURI = @"http://dummy.com/photo.png";
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:photoURI forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:11];
    NSString *description = @"description";
    NSNumber *followerCount = [NSNumber numberWithInt:7];
    NSString *jiveId = @"1234";
    NSNumber *likeCount = [NSNumber numberWithInt:4];
    NSString *name = @"name";
    NSString *place = @"/place/54321";
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *tag = @"First";
    NSDate *updated = [NSDate dateWithTimeIntervalSince1970:1000.123];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    
    [JSON setValue:description forKey:@"description"];
    [JSON setValue:followerCount forKey:@"followerCount"];
    [JSON setValue:jiveId forKey:@"jiveId"];
    [JSON setValue:likeCount forKey:@"likeCount"];
    [JSON setValue:name forKey:@"name"];
    [JSON setValue:place forKey:@"place"];
    [JSON setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    [JSON setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [JSON setValue:@"type" forKey:@"type"];
    [JSON setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    category = [JiveCategory instanceFromJSON:JSON];
    
    STAssertEquals([category class], [JiveCategory class], @"Wrong item class");
    STAssertEqualObjects(category.description, description, @"Wrong description");
    STAssertEqualObjects(category.followerCount, followerCount, @"Wrong follower count");
    STAssertEqualObjects(category.jiveId, jiveId, @"Wrong id");
    STAssertEqualObjects(category.likeCount, likeCount, @"Wrong likeCount");
    STAssertEqualObjects(category.name, name, @"Wrong name");
    STAssertEqualObjects(category.place, place, @"Wrong place");
    STAssertEqualObjects(category.published, published, @"Wrong published date");
    STAssertEqualObjects(category.type, @"category", @"Wrong type");
    STAssertEqualObjects(category.updated, updated, @"Wrong updated date");
    STAssertEquals([category.tags count], (NSUInteger)1, @"Wrong number of tag objects");
    STAssertEqualObjects([category.tags objectAtIndex:0], tag, @"Wrong tag object");
    STAssertEquals([category.resources count], (NSUInteger)1, @"Wrong number of resource objects");
    STAssertEqualObjects([[(JiveResourceEntry *)[category.resources objectForKey:resourceKey] ref] absoluteString], photoURI, @"Wrong resource object");
}

- (void)testCategoryParsingAlternate {
    NSString *photoURI = @"http://com.dummy/png.photo";
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:photoURI forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:11];
    NSString *description = @"alternate";
    NSNumber *followerCount = [NSNumber numberWithInt:17];
    NSString *jiveId = @"5432";
    NSNumber *likeCount = [NSNumber numberWithInt:40];
    NSString *name = @"place";
    NSString *place = @"/content/76543";
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:1000.123];
    NSString *tag = @"Gigantic";
    NSDate *updated = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    
    [JSON setValue:description forKey:@"description"];
    [JSON setValue:followerCount forKey:@"followerCount"];
    [JSON setValue:jiveId forKey:@"jiveId"];
    [JSON setValue:likeCount forKey:@"likeCount"];
    [JSON setValue:name forKey:@"name"];
    [JSON setValue:place forKey:@"place"];
    [JSON setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    [JSON setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [JSON setValue:@"type" forKey:@"type"];
    [JSON setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    category = [JiveCategory instanceFromJSON:JSON];
    
    STAssertEquals([category class], [JiveCategory class], @"Wrong item class");
    STAssertEqualObjects(category.description, description, @"Wrong description");
    STAssertEqualObjects(category.followerCount, followerCount, @"Wrong follower count");
    STAssertEqualObjects(category.jiveId, jiveId, @"Wrong id");
    STAssertEqualObjects(category.likeCount, likeCount, @"Wrong likeCount");
    STAssertEqualObjects(category.name, name, @"Wrong name");
    STAssertEqualObjects(category.place, place, @"Wrong place");
    STAssertEqualObjects(category.published, published, @"Wrong published date");
    STAssertEqualObjects(category.type, @"category", @"Wrong type");
    STAssertEqualObjects(category.updated, updated, @"Wrong updated date");
    STAssertEquals([category.tags count], (NSUInteger)1, @"Wrong number of tag objects");
    STAssertEqualObjects([category.tags objectAtIndex:0], tag, @"Wrong tag object");
    STAssertEquals([category.resources count], (NSUInteger)1, @"Wrong number of resource objects");
    STAssertEqualObjects([[(JiveResourceEntry *)[category.resources objectForKey:resourceKey] ref] absoluteString], photoURI, @"Wrong resource object");
}

@end
