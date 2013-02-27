//
//  JivePlaceTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
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

#import "JivePlaceTests.h"
#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"
#import "JiveSummary.h"
#import "JiveResourceEntry.h"

@interface DummyPlace : JivePlace

@end

@implementation DummyPlace

- (NSString *)type {
    return @"dummy";
}

@end

@implementation JivePlaceTests

@synthesize place;

- (void)setUp {
    place = [[DummyPlace alloc] init];
}

- (void)tearDown {
    place = nil;
}

- (void)testHandlePrimitivePropertyFromJSON {
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
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"First";
    NSDictionary *JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], place.type, @"Wrong type");
    
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    place.displayName = @"testName";
    [place setValue:@"1234" forKey:@"jiveId"];
    place.description = @"USA";
    [place setValue:@"Status update" forKey:@"status"];
    [place setValue:@"Body" forKey:@"highlightBody"];
    [place setValue:@"Subject" forKey:@"highlightSubject"];
    [place setValue:@"Tags" forKey:@"highlightTags"];
    [place setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [place setValue:[NSNumber numberWithInt:6] forKey:@"likeCount"];
    [place setValue:[NSNumber numberWithInt:33] forKey:@"viewCount"];
    place.name = @"test name";
    [place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [place setValue:parentContent forKey:@"parentContent"];
    [place setValue:parentPlace forKey:@"parentPlace"];
    [place setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    place.parent = @"Parent";
    [place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanTrue];
    
    JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)19, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"name"], place.name, @"Wrong name.");
    STAssertEqualObjects([JSON objectForKey:@"displayName"], place.displayName, @"Wrong display name.");
    STAssertEqualObjects([JSON objectForKey:@"id"], place.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"description"], place.description, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"status"], place.status, @"Wrong status update");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], place.highlightBody, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], place.highlightSubject, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], place.highlightTags, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"type"], place.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], place.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], place.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published date");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated date");
    STAssertEqualObjects([JSON objectForKey:@"parent"], place.parent, @"Wrong parent");
    
    NSNumber *visibility = [JSON objectForKey:@"visibleToExternalContributors"];
    
    STAssertNotNil(visibility, @"Missing visibility");
    if (visibility)
        STAssertTrue([visibility boolValue], @"Wrong visiblity");
    
    NSDictionary *parentContentJSON = [JSON objectForKey:@"parentContent"];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong user name");
    
    NSDictionary *parentPlaceJSON = [JSON objectForKey:@"parentPlace"];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong user name");

    NSArray *contentTypesJSON = [JSON objectForKey:@"contentTypes"];
    
    STAssertTrue([[contentTypesJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    STAssertEquals([contentTypesJSON count], (NSUInteger)1, @"Wrong number of elements in the contentTypes array");
    STAssertEqualObjects([contentTypesJSON objectAtIndex:0], contentType, @"contentType object not converted");
}

- (void)testToJSON_alternate {
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    [parentContent setValue:@"not content" forKey:@"name"];
    [parentPlace setValue:@"not place" forKey:@"name"];
    place.displayName = @"Alternate";
    [place setValue:@"87654" forKey:@"jiveId"];
    place.description = @"Foxtrot";
    [place setValue:@"Working for the man" forKey:@"status"];
    [place setValue:@"not Body" forKey:@"highlightBody"];
    [place setValue:@"not Subject" forKey:@"highlightSubject"];
    [place setValue:@"not Tags" forKey:@"highlightTags"];
    [place setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [place setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [place setValue:[NSNumber numberWithInt:12] forKey:@"viewCount"];
    place.name = @"test name";
    [place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [place setValue:parentContent forKey:@"parentContent"];
    [place setValue:parentPlace forKey:@"parentPlace"];
    place.parent = @"Goofy";

    NSDictionary *JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)17, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"name"], place.name, @"Wrong name.");
    STAssertEqualObjects([JSON objectForKey:@"displayName"], place.displayName, @"Wrong display name.");
    STAssertEqualObjects([JSON objectForKey:@"id"], place.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"description"], place.description, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"status"], place.status, @"Wrong status update");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], place.highlightBody, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], place.highlightSubject, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], place.highlightTags, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"type"], place.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], place.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], place.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published date");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated date");
    STAssertEqualObjects([JSON objectForKey:@"parent"], place.parent, @"Wrong parent");
    STAssertNil([JSON objectForKey:@"visibleToExternalContributors"], @"Visibility included?");
    
    NSDictionary *parentContentJSON = [JSON objectForKey:@"parentContent"];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong user name");
    
    NSDictionary *parentPlaceJSON = [JSON objectForKey:@"parentPlace"];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong user name");
}

- (void)testToJSON_contentTypes {
    NSString *contentType1 = @"First";
    NSString *contentType2 = @"Last";
    
    [place setValue:[NSArray arrayWithObject:contentType1] forKey:@"contentTypes"];
    
    NSDictionary *JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], place.type, @"Wrong type");

    NSArray *addressJSON = [JSON objectForKey:@"contentTypes"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the contentTypes array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], contentType1, @"Wrong contentType value");
    
    [place setValue:[place.contentTypes arrayByAddingObject:contentType2] forKey:@"contentTypes"];
    
    JSON = [place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], place.type, @"Wrong type");

    addressJSON = [JSON objectForKey:@"contentTypes"];
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the contentTypes array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], contentType1, @"Wrong contentType 1 value");
    STAssertEqualObjects([addressJSON objectAtIndex:1], contentType2, @"Wrong contentType 2 value");
}

- (void)testPlaceParsing {
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
    place.displayName = @"testName";
    [place setValue:@"1234" forKey:@"jiveId"];
    place.description = @"USA";
    [place setValue:@"Working for the man" forKey:@"status"];
    [place setValue:@"Body" forKey:@"highlightBody"];
    [place setValue:@"Subject" forKey:@"highlightSubject"];
    [place setValue:@"Tags" forKey:@"highlightTags"];
    [place setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [place setValue:[NSNumber numberWithInt:6] forKey:@"likeCount"];
    [place setValue:[NSNumber numberWithInt:33] forKey:@"viewCount"];
    place.name = @"name";
    [place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [place setValue:parentContent forKey:@"parentContent"];
    [place setValue:parentPlace forKey:@"parentPlace"];
    [place setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    place.parent = @"Parent";
    [place setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    [place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"visibleToExternalContributors"
                    withObject:(__bridge id)kCFBooleanTrue];
    
    id JSON = [place toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JivePlace *newPlace = [JivePlace instanceFromJSON:JSON];
    
    STAssertTrue([[newPlace class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
    STAssertEqualObjects(newPlace.displayName, place.displayName, @"Wrong display name");
    STAssertEqualObjects(newPlace.followerCount, place.followerCount, @"Wrong follower count");
    STAssertEqualObjects(newPlace.likeCount, place.likeCount, @"Wrong like count");
    STAssertEqualObjects(newPlace.viewCount, place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newPlace.jiveId, place.jiveId, @"Wrong id");
    STAssertEqualObjects(newPlace.description, place.description, @"Wrong description");
    STAssertEqualObjects(newPlace.name, place.name, @"Wrong name");
    STAssertEqualObjects(newPlace.published, place.published, @"Wrong published date");
    STAssertEqualObjects(newPlace.status, place.status, @"Wrong status");
    STAssertEqualObjects(newPlace.highlightBody, place.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newPlace.highlightSubject, place.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newPlace.highlightTags, place.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newPlace.updated, place.updated, @"Wrong updated date");
    STAssertEqualObjects(newPlace.parent, place.parent, @"Wrong parent");
    STAssertEqualObjects(newPlace.parentContent.name, parentContent.name, @"Wrong parentContent name");
    STAssertEqualObjects(newPlace.parentPlace.name, parentPlace.name, @"Wrong parentPlace name");
    STAssertTrue(newPlace.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newPlace.contentTypes count], [place.contentTypes count], @"Wrong number of contentType objects");
    STAssertEqualObjects([newPlace.contentTypes objectAtIndex:0], [place.contentTypes objectAtIndex:0], @"Wrong contentType object class");
    STAssertEquals([newPlace.resources count], [place.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newPlace.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testPlaceParsingAlternate {
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
    place.displayName = @"display name";
    [place setValue:@"87654" forKey:@"jiveId"];
    place.description = @"New Mexico";
    [place setValue:@"No status" forKey:@"status"];
    [place setValue:@"not Body" forKey:@"highlightBody"];
    [place setValue:@"not Subject" forKey:@"highlightSubject"];
    [place setValue:@"not Tags" forKey:@"highlightTags"];
    [place setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [place setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [place setValue:[NSNumber numberWithInt:12] forKey:@"viewCount"];
    place.name = @"Alternate";
    [place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [place setValue:parentContent forKey:@"parentContent"];
    [place setValue:parentPlace forKey:@"parentPlace"];
    [place setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    place.parent = @"Goofy";
    [place setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [place toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JivePlace *newPlace = [JivePlace instanceFromJSON:JSON];
    
    STAssertTrue([[newPlace class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
    STAssertEqualObjects(newPlace.displayName, place.displayName, @"Wrong display name");
    STAssertEqualObjects(newPlace.followerCount, place.followerCount, @"Wrong follower count");
    STAssertEqualObjects(newPlace.likeCount, place.likeCount, @"Wrong like count");
    STAssertEqualObjects(newPlace.viewCount, place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newPlace.jiveId, place.jiveId, @"Wrong id");
    STAssertEqualObjects(newPlace.description, place.description, @"Wrong description");
    STAssertEqualObjects(newPlace.name, place.name, @"Wrong name");
    STAssertEqualObjects(newPlace.published, place.published, @"Wrong published date");
    STAssertEqualObjects(newPlace.status, place.status, @"Wrong status");
    STAssertEqualObjects(newPlace.highlightBody, place.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newPlace.highlightSubject, place.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newPlace.highlightTags, place.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newPlace.updated, place.updated, @"Wrong updated date");
    STAssertEqualObjects(newPlace.parent, place.parent, @"Wrong parent");
    STAssertEqualObjects(newPlace.parentContent.name, parentContent.name, @"Wrong parentContent name");
    STAssertEqualObjects(newPlace.parentPlace.name, parentPlace.name, @"Wrong parentPlace name");
    STAssertFalse(newPlace.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newPlace.contentTypes count], [place.contentTypes count], @"Wrong number of contentType objects");
    STAssertEqualObjects([newPlace.contentTypes objectAtIndex:0], [place.contentTypes objectAtIndex:0], @"Wrong contentType object class");
    STAssertEquals([newPlace.resources count], [place.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newPlace.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
