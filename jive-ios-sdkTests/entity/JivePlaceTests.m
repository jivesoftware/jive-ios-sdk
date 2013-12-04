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
#import "JiveObject_internal.h"
#import "JiveTypedObject_internal.h"

@interface DummyPlace : JivePlace

@end

@implementation DummyPlace

- (NSString *)type {
    return @"dummy";
}

@end

@implementation JivePlaceTests

- (JivePlace *)place {
    return (JivePlace *)self.typedObject;
}

- (void)setUp {
    [super setUp];
    self.object = [[DummyPlace alloc] init];
}

- (void)testHandlePrimitivePropertyFromJSON {
    STAssertFalse(self.place.visibleToExternalContributors, @"PRECONDITION: default is false");
    
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanTrue];
    STAssertTrue(self.place.visibleToExternalContributors, @"Set to true");
    
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanFalse];
    STAssertFalse(self.place.visibleToExternalContributors, @"Back to false");
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
    NSDictionary *JSON = [self.place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.place.type, @"Wrong type");
    
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.place.displayName = @"testName";
    [self.place setValue:@"1234" forKey:@"jiveId"];
    self.place.jiveDescription = @"USA";
    [self.place setValue:@"Status update" forKey:@"status"];
    [self.place setValue:@"Body" forKey:@"highlightBody"];
    [self.place setValue:@"Subject" forKey:@"highlightSubject"];
    [self.place setValue:@"Tags" forKey:@"highlightTags"];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:@"likeCount"];
    [self.place setValue:[NSNumber numberWithInt:33] forKey:@"viewCount"];
    self.place.name = @"test name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.place setValue:parentContent forKey:@"parentContent"];
    [self.place setValue:parentPlace forKey:@"parentPlace"];
    [self.place setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    self.place.parent = @"Parent";
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanTrue];
    
    JSON = [self.place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)19, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"name"], self.place.name, @"Wrong name.");
    STAssertEqualObjects([JSON objectForKey:@"displayName"], self.place.displayName, @"Wrong display name.");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.place.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"description"], self.place.jiveDescription, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"status"], self.place.status, @"Wrong status update");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], self.place.highlightBody, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], self.place.highlightSubject, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], self.place.highlightTags, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.place.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], self.place.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], self.place.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], self.place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published date");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated date");
    STAssertEqualObjects([JSON objectForKey:@"parent"], self.place.parent, @"Wrong parent");
    
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
    self.place.displayName = @"Alternate";
    [self.place setValue:@"87654" forKey:@"jiveId"];
    self.place.jiveDescription = @"Foxtrot";
    [self.place setValue:@"Working for the man" forKey:@"status"];
    [self.place setValue:@"not Body" forKey:@"highlightBody"];
    [self.place setValue:@"not Subject" forKey:@"highlightSubject"];
    [self.place setValue:@"not Tags" forKey:@"highlightTags"];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [self.place setValue:[NSNumber numberWithInt:12] forKey:@"viewCount"];
    self.place.name = @"test name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.place setValue:parentContent forKey:@"parentContent"];
    [self.place setValue:parentPlace forKey:@"parentPlace"];
    self.place.parent = @"Goofy";

    NSDictionary *JSON = [self.place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)17, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"name"], self.place.name, @"Wrong name.");
    STAssertEqualObjects([JSON objectForKey:@"displayName"], self.place.displayName, @"Wrong display name.");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.place.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"description"], self.place.jiveDescription, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"status"], self.place.status, @"Wrong status update");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], self.place.highlightBody, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], self.place.highlightSubject, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], self.place.highlightTags, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.place.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], self.place.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], self.place.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], self.place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published date");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated date");
    STAssertEqualObjects([JSON objectForKey:@"parent"], self.place.parent, @"Wrong parent");
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
    
    [self.place setValue:[NSArray arrayWithObject:contentType1] forKey:@"contentTypes"];
    
    NSDictionary *JSON = [self.place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.place.type, @"Wrong type");

    NSArray *addressJSON = [JSON objectForKey:@"contentTypes"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the contentTypes array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], contentType1, @"Wrong contentType value");
    
    [self.place setValue:[self.place.contentTypes arrayByAddingObject:contentType2] forKey:@"contentTypes"];
    
    JSON = [self.place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.place.type, @"Wrong type");

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
    self.place.displayName = @"testName";
    [self.place setValue:@"1234" forKey:@"jiveId"];
    self.place.jiveDescription = @"USA";
    [self.place setValue:@"Working for the man" forKey:@"status"];
    [self.place setValue:@"Body" forKey:@"highlightBody"];
    [self.place setValue:@"Subject" forKey:@"highlightSubject"];
    [self.place setValue:@"Tags" forKey:@"highlightTags"];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:@"likeCount"];
    [self.place setValue:[NSNumber numberWithInt:33] forKey:@"viewCount"];
    self.place.name = @"name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.place setValue:parentContent forKey:@"parentContent"];
    [self.place setValue:parentPlace forKey:@"parentPlace"];
    [self.place setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    self.place.parent = @"Parent";
    [self.place setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"visibleToExternalContributors"
                    withObject:(__bridge id)kCFBooleanTrue];
    
    id JSON = [self.place toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JivePlace *newPlace = [JivePlace objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newPlace class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
    STAssertEqualObjects(newPlace.displayName, self.place.displayName, @"Wrong display name");
    STAssertEqualObjects(newPlace.followerCount, self.place.followerCount, @"Wrong follower count");
    STAssertEqualObjects(newPlace.likeCount, self.place.likeCount, @"Wrong like count");
    STAssertEqualObjects(newPlace.viewCount, self.place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newPlace.jiveId, self.place.jiveId, @"Wrong id");
    STAssertEqualObjects(newPlace.jiveDescription, self.place.jiveDescription, @"Wrong description");
    STAssertEqualObjects(newPlace.name, self.place.name, @"Wrong name");
    STAssertEqualObjects(newPlace.published, self.place.published, @"Wrong published date");
    STAssertEqualObjects(newPlace.status, self.place.status, @"Wrong status");
    STAssertEqualObjects(newPlace.highlightBody, self.place.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newPlace.highlightSubject, self.place.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newPlace.highlightTags, self.place.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newPlace.updated, self.place.updated, @"Wrong updated date");
    STAssertEqualObjects(newPlace.parent, self.place.parent, @"Wrong parent");
    STAssertEqualObjects(newPlace.parentContent.name, parentContent.name, @"Wrong parentContent name");
    STAssertEqualObjects(newPlace.parentPlace.name, parentPlace.name, @"Wrong parentPlace name");
    STAssertTrue(newPlace.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newPlace.contentTypes count], [self.place.contentTypes count], @"Wrong number of contentType objects");
    STAssertEqualObjects([newPlace.contentTypes objectAtIndex:0], [self.place.contentTypes objectAtIndex:0], @"Wrong contentType object class");
    STAssertEquals([newPlace.resources count], [self.place.resources count], @"Wrong number of resource objects");
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
    self.place.displayName = @"display name";
    [self.place setValue:@"87654" forKey:@"jiveId"];
    self.place.jiveDescription = @"New Mexico";
    [self.place setValue:@"No status" forKey:@"status"];
    [self.place setValue:@"not Body" forKey:@"highlightBody"];
    [self.place setValue:@"not Subject" forKey:@"highlightSubject"];
    [self.place setValue:@"not Tags" forKey:@"highlightTags"];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [self.place setValue:[NSNumber numberWithInt:12] forKey:@"viewCount"];
    self.place.name = @"Alternate";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.place setValue:parentContent forKey:@"parentContent"];
    [self.place setValue:parentPlace forKey:@"parentPlace"];
    [self.place setValue:[NSArray arrayWithObject:contentType] forKey:@"contentTypes"];
    self.place.parent = @"Goofy";
    [self.place setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.place toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JivePlace *newPlace = [JivePlace objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newPlace class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
    STAssertEqualObjects(newPlace.displayName, self.place.displayName, @"Wrong display name");
    STAssertEqualObjects(newPlace.followerCount, self.place.followerCount, @"Wrong follower count");
    STAssertEqualObjects(newPlace.likeCount, self.place.likeCount, @"Wrong like count");
    STAssertEqualObjects(newPlace.viewCount, self.place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newPlace.jiveId, self.place.jiveId, @"Wrong id");
    STAssertEqualObjects(newPlace.jiveDescription, self.place.jiveDescription, @"Wrong description");
    STAssertEqualObjects(newPlace.name, self.place.name, @"Wrong name");
    STAssertEqualObjects(newPlace.published, self.place.published, @"Wrong published date");
    STAssertEqualObjects(newPlace.status, self.place.status, @"Wrong status");
    STAssertEqualObjects(newPlace.highlightBody, self.place.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newPlace.highlightSubject, self.place.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newPlace.highlightTags, self.place.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newPlace.updated, self.place.updated, @"Wrong updated date");
    STAssertEqualObjects(newPlace.parent, self.place.parent, @"Wrong parent");
    STAssertEqualObjects(newPlace.parentContent.name, parentContent.name, @"Wrong parentContent name");
    STAssertEqualObjects(newPlace.parentPlace.name, parentPlace.name, @"Wrong parentPlace name");
    STAssertFalse(newPlace.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newPlace.contentTypes count], [self.place.contentTypes count], @"Wrong number of contentType objects");
    STAssertEqualObjects([newPlace.contentTypes objectAtIndex:0], [self.place.contentTypes objectAtIndex:0], @"Wrong contentType object class");
    STAssertEquals([newPlace.resources count], [self.place.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newPlace.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
