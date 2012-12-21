//
//  JivePlaceTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlaceTests.h"
#import "JivePlace.h"
#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"
#import "JiveSummary.h"
#import "JiveResourceEntry.h"

@implementation JivePlaceTests

- (void)testHandlePrimitivePropertyFromJSON {
    
    JivePlace *place = [[JivePlace alloc] init];
    
    STAssertFalse(place.visibleToExternalContributors, @"PRECONDITION: default is false");
    
    [place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanTrue];
    STAssertTrue(place.visibleToExternalContributors, @"Set to true");
    
    [place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanFalse];
    STAssertFalse(place.visibleToExternalContributors, @"Back to false");
}

- (void)testEntityClass {
    
    NSString *key = @"type";
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:@"blog" forKey:key];
    SEL selector = @selector(entityClass:);
    
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveBlog class], @"Blog");
    
    [typeSpecifier setValue:@"group" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveGroup class], @"Group");
    
    [typeSpecifier setValue:@"project" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveProject class], @"Project");
    
    [typeSpecifier setValue:@"space" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveSpace class], @"Space");
    
    [typeSpecifier setValue:@"random" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JivePlace class], @"Out of bounds");
    
    [typeSpecifier setValue:@"Not random" forKey:key];
    STAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JivePlace class], @"Different out of bounds");
}

- (void)testToJSON {
    JivePlace *place = [[JivePlace alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"First";
    id JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    place.displayName = @"testName";
    [place setValue:@"1234" forKey:@"jiveId"];
    place.description = @"USA";
    [place setValue:@"Status update" forKey:@"status"];
    [place setValue:@"Body" forKey:@"highlightBody"];
    [place setValue:@"Subject" forKey:@"highlightSubject"];
    [place setValue:@"Tags" forKey:@"highlightTags"];
    place.type = @"place";
    [place setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [place setValue:[NSNumber numberWithInt:6] forKey:@"likeCount"];
    [place setValue:[NSNumber numberWithInt:33] forKey:@"viewCount"];
    [place setValue:@"test name" forKey:@"name"];
    [place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [place setValue:parentContent forKey:@"parentContent"];
    [place setValue:parentPlace forKey:@"parentPlace"];
    [place setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    place.parent = @"Parent";
    
    JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)18, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], place.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"displayName"], place.displayName, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], place.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"description"], place.description, @"Wrong description");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"status"], place.status, @"Wrong status update");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightBody"], place.highlightBody, @"Wrong thumbnail url");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightSubject"], place.highlightSubject, @"Wrong thumbnail url");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightTags"], place.highlightTags, @"Wrong thumbnail url");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], place.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followerCount"], place.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"likeCount"], place.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"viewCount"], place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published date");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated date");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"parent"], place.parent, @"Wrong parent");
    
    NSArray *parentContentJSON = [(NSDictionary *)JSON objectForKey:@"parentContent"];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong user name");
    
    NSArray *parentPlaceJSON = [(NSDictionary *)JSON objectForKey:@"parentPlace"];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong user name");

    NSArray *contentTypesJSON = [(NSDictionary *)JSON objectForKey:@"contentTypes"];
    
    STAssertTrue([[contentTypesJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    STAssertEquals([contentTypesJSON count], (NSUInteger)1, @"Wrong number of elements in the contentTypes array");
    STAssertEqualObjects([contentTypesJSON objectAtIndex:0], contentType, @"contentType object not converted");
}

- (void)testToJSON_alternate {
    JivePlace *place = [[JivePlace alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    id JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [parentContent setValue:@"not content" forKey:@"name"];
    [parentPlace setValue:@"not place" forKey:@"name"];
    place.displayName = @"Alternate";
    [place setValue:@"87654" forKey:@"jiveId"];
    place.description = @"Foxtrot";
    [place setValue:@"Working for the man" forKey:@"status"];
    [place setValue:@"not Body" forKey:@"highlightBody"];
    [place setValue:@"not Subject" forKey:@"highlightSubject"];
    [place setValue:@"not Tags" forKey:@"highlightTags"];
    place.type = @"place";
    [place setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [place setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [place setValue:[NSNumber numberWithInt:12] forKey:@"viewCount"];
    [place setValue:@"test name" forKey:@"name"];
    [place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [place setValue:parentContent forKey:@"parentContent"];
    [place setValue:parentPlace forKey:@"parentPlace"];
    place.parent = @"Goofy";

    JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)17, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], place.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"displayName"], place.displayName, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], place.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"description"], place.description, @"Wrong description");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"status"], place.status, @"Wrong status update");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightBody"], place.highlightBody, @"Wrong thumbnail url");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightSubject"], place.highlightSubject, @"Wrong thumbnail url");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightTags"], place.highlightTags, @"Wrong thumbnail url");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], place.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followerCount"], place.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"likeCount"], place.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"viewCount"], place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published date");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated date");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"parent"], place.parent, @"Wrong parent");
    
    NSArray *parentContentJSON = [(NSDictionary *)JSON objectForKey:@"parentContent"];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong user name");
    
    NSArray *parentPlaceJSON = [(NSDictionary *)JSON objectForKey:@"parentPlace"];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong user name");
}

- (void)testToJSON_contentTypes {
    JivePlace *place = [[JivePlace alloc] init];
    NSString *contentType1 = @"First";
    NSString *contentType2 = @"Last";
    id JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [place setValue:[NSArray arrayWithObject:contentType1] forKey:@"contentTypes"];
    
    JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"contentTypes"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the contentTypes array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], contentType1, @"Wrong contentType value");
    
    [place setValue:[place.contentTypes arrayByAddingObject:contentType2] forKey:@"contentTypes"];
    
    JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [(NSDictionary *)JSON objectForKey:@"contentTypes"];
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the contentTypes array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], contentType1, @"Wrong contentType 1 value");
    STAssertEqualObjects([addressJSON objectAtIndex:1], contentType2, @"Wrong contentType 2 value");
}

- (void)testPlaceParsing {
    JivePlace *basePlace = [[JivePlace alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    basePlace.displayName = @"testName";
    [basePlace setValue:@"1234" forKey:@"jiveId"];
    basePlace.description = @"USA";
    [basePlace setValue:@"Working for the man" forKey:@"status"];
    [basePlace setValue:@"Body" forKey:@"highlightBody"];
    [basePlace setValue:@"Subject" forKey:@"highlightSubject"];
    [basePlace setValue:@"Tags" forKey:@"highlightTags"];
    basePlace.type = @"place";
    [basePlace setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [basePlace setValue:[NSNumber numberWithInt:6] forKey:@"likeCount"];
    [basePlace setValue:[NSNumber numberWithInt:33] forKey:@"viewCount"];
    [basePlace setValue:@"name" forKey:@"name"];
    [basePlace setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [basePlace setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [basePlace setValue:parentContent forKey:@"parentContent"];
    [basePlace setValue:parentPlace forKey:@"parentPlace"];
    [basePlace setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    basePlace.parent = @"Parent";
    [basePlace setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [basePlace toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JivePlace *place = [JivePlace instanceFromJSON:JSON];
    
    STAssertEquals([place class], [JivePlace class], @"Wrong item class");
    STAssertEqualObjects(place.displayName, basePlace.displayName, @"Wrong display name");
    STAssertEqualObjects(place.followerCount, basePlace.followerCount, @"Wrong follower count");
    STAssertEqualObjects(place.likeCount, basePlace.likeCount, @"Wrong like count");
    STAssertEqualObjects(place.viewCount, basePlace.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(place.jiveId, basePlace.jiveId, @"Wrong id");
    STAssertEqualObjects(place.description, basePlace.description, @"Wrong description");
    STAssertEqualObjects(place.name, basePlace.name, @"Wrong name");
    STAssertEqualObjects(place.published, basePlace.published, @"Wrong published date");
    STAssertEqualObjects(place.status, basePlace.status, @"Wrong status");
    STAssertEqualObjects(place.highlightBody, basePlace.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(place.highlightSubject, basePlace.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(place.highlightTags, basePlace.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(place.type, basePlace.type, @"Wrong type");
    STAssertEqualObjects(place.updated, basePlace.updated, @"Wrong updated date");
    STAssertEqualObjects(place.parent, basePlace.parent, @"Wrong parent");
    STAssertEqualObjects(place.parentContent.name, parentContent.name, @"Wrong parentContent name");
    STAssertEqualObjects(place.parentPlace.name, parentPlace.name, @"Wrong parentPlace name");
    STAssertEquals([place.contentTypes count], [basePlace.contentTypes count], @"Wrong number of contentType objects");
    STAssertEqualObjects([place.contentTypes objectAtIndex:0], [basePlace.contentTypes objectAtIndex:0], @"Wrong contentType object class");
    STAssertEquals([place.resources count], [basePlace.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[place.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testPlaceParsingAlternate {
    JivePlace *basePlace = [[JivePlace alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    [parentContent setValue:@"not content" forKey:@"name"];
    [parentPlace setValue:@"not place" forKey:@"name"];
    basePlace.displayName = @"display name";
    [basePlace setValue:@"87654" forKey:@"jiveId"];
    basePlace.description = @"New Mexico";
    [basePlace setValue:@"No status" forKey:@"status"];
    [basePlace setValue:@"not Body" forKey:@"highlightBody"];
    [basePlace setValue:@"not Subject" forKey:@"highlightSubject"];
    [basePlace setValue:@"not Tags" forKey:@"highlightTags"];
    basePlace.type = @"walaby";
    [basePlace setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [basePlace setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [basePlace setValue:[NSNumber numberWithInt:12] forKey:@"viewCount"];
    [basePlace setValue:@"Alternate" forKey:@"name"];
    [basePlace setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [basePlace setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [basePlace setValue:parentContent forKey:@"parentContent"];
    [basePlace setValue:parentPlace forKey:@"parentPlace"];
    [basePlace setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    basePlace.parent = @"Goofy";
    [basePlace setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [basePlace toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JivePlace *place = [JivePlace instanceFromJSON:JSON];
    
    STAssertEquals([place class], [JivePlace class], @"Wrong item class");
    STAssertEqualObjects(place.displayName, basePlace.displayName, @"Wrong display name");
    STAssertEqualObjects(place.followerCount, basePlace.followerCount, @"Wrong follower count");
    STAssertEqualObjects(place.likeCount, basePlace.likeCount, @"Wrong like count");
    STAssertEqualObjects(place.viewCount, basePlace.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(place.jiveId, basePlace.jiveId, @"Wrong id");
    STAssertEqualObjects(place.description, basePlace.description, @"Wrong description");
    STAssertEqualObjects(place.name, basePlace.name, @"Wrong name");
    STAssertEqualObjects(place.published, basePlace.published, @"Wrong published date");
    STAssertEqualObjects(place.status, basePlace.status, @"Wrong status");
    STAssertEqualObjects(place.highlightBody, basePlace.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(place.highlightSubject, basePlace.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(place.highlightTags, basePlace.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(place.type, basePlace.type, @"Wrong type");
    STAssertEqualObjects(place.updated, basePlace.updated, @"Wrong updated date");
    STAssertEqualObjects(place.parent, basePlace.parent, @"Wrong parent");
    STAssertEqualObjects(place.parentContent.name, parentContent.name, @"Wrong parentContent name");
    STAssertEqualObjects(place.parentPlace.name, parentPlace.name, @"Wrong parentPlace name");
    STAssertEquals([place.contentTypes count], [basePlace.contentTypes count], @"Wrong number of contentType objects");
    STAssertEqualObjects([place.contentTypes objectAtIndex:0], [basePlace.contentTypes objectAtIndex:0], @"Wrong contentType object class");
    STAssertEquals([place.resources count], [basePlace.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[place.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
