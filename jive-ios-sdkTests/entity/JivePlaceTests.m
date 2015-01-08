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
#import <OCMock/OCMock.h>

extern struct JivePlaceResourceAttributes {
    __unsafe_unretained NSString *activity;
    __unsafe_unretained NSString *announcements;
    __unsafe_unretained NSString *avatar;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *checkPoints;
    __unsafe_unretained NSString *childPlaces;
    __unsafe_unretained NSString *contents;
    __unsafe_unretained NSString *extprops;
    __unsafe_unretained NSString *featuredContent;
    __unsafe_unretained NSString *followingIn;
    __unsafe_unretained NSString *html;
    __unsafe_unretained NSString *invites;
    __unsafe_unretained NSString *members;
    __unsafe_unretained NSString *statics;
    __unsafe_unretained NSString *tasks;
} const JivePlaceResourceAttributes;

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
    NSString *key = JiveTypedObjectAttributes.type;
    NSMutableDictionary *typeSpecifier = [@{key:@"blog"} mutableCopy];
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
    NSDictionary *JSON;
    
    STAssertNoThrow(JSON = [self.place toJSONDictionary], nil);
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");
    
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.place.displayName = @"testName";
    [self.place setValue:@"1234" forKey:@"jiveId"];
    self.place.jiveDescription = @"USA";
    [self.place setValue:@"Status update" forKey:JivePlaceAttributes.status];
    [self.place setValue:@"Body" forKey:JivePlaceAttributes.highlightBody];
    [self.place setValue:@"Subject" forKey:JivePlaceAttributes.highlightSubject];
    [self.place setValue:@"Tags" forKey:JivePlaceAttributes.highlightTags];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:JivePlaceAttributes.followerCount];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:JivePlaceAttributes.likeCount];
    [self.place setValue:[NSNumber numberWithInt:33] forKey:JivePlaceAttributes.viewCount];
    self.place.name = @"test name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePlaceAttributes.published];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePlaceAttributes.updated];
    [self.place setValue:parentContent forKey:JivePlaceAttributes.parentContent];
    [self.place setValue:parentPlace forKey:JivePlaceAttributes.parentPlace];
    [self.place setValue:[NSArray arrayWithObject:contentType]
                  forKey:JivePlaceAttributes.contentTypes];
    self.place.parent = @"Parent";
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanTrue];
    [self.place setValue:@"testIconCss" forKey:JivePlaceAttributes.iconCss];
    [self.place setValue:@"not here" forKey:JivePlaceAttributes.placeID];
    
    STAssertNoThrow(JSON = [self.place toJSONDictionary], nil);
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)19, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.name], self.place.name, @"Wrong name.");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.displayName],
                         self.place.displayName, @"Wrong display name.");
    STAssertEqualObjects([JSON objectForKey:JiveObjectConstants.id], self.place.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"description"], self.place.jiveDescription, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.status], self.place.status, @"Wrong status update");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightBody],
                         self.place.highlightBody, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightSubject],
                         self.place.highlightSubject, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightTags],
                         self.place.highlightTags, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.followerCount],
                         self.place.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.likeCount], self.place.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.viewCount], self.place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.published], @"1970-01-01T00:00:00.000+0000", @"Wrong published date");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.updated], @"1970-01-01T00:16:40.123+0000", @"Wrong updated date");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.parent], self.place.parent, @"Wrong parent");
    
    NSNumber *visibility = [JSON objectForKey:JivePlaceAttributes.visibleToExternalContributors];
    
    STAssertNotNil(visibility, @"Missing visibility");
    if (visibility)
        STAssertTrue([visibility boolValue], @"Wrong visiblity");
    
    NSDictionary *parentContentJSON = [JSON objectForKey:JivePlaceAttributes.parentContent];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong user name");
    
    NSDictionary *parentPlaceJSON = [JSON objectForKey:JivePlaceAttributes.parentPlace];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong user name");

    NSArray *contentTypesJSON = [JSON objectForKey:JivePlaceAttributes.contentTypes];
    
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
    [self.place setValue:@"Working for the man" forKey:JivePlaceAttributes.status];
    [self.place setValue:@"not Body" forKey:JivePlaceAttributes.highlightBody];
    [self.place setValue:@"not Subject" forKey:JivePlaceAttributes.highlightSubject];
    [self.place setValue:@"not Tags" forKey:JivePlaceAttributes.highlightTags];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:JivePlaceAttributes.followerCount];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:JivePlaceAttributes.likeCount];
    [self.place setValue:[NSNumber numberWithInt:12] forKey:JivePlaceAttributes.viewCount];
    self.place.name = @"test name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePlaceAttributes.published];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePlaceAttributes.updated];
    [self.place setValue:parentContent forKey:JivePlaceAttributes.parentContent];
    [self.place setValue:parentPlace forKey:JivePlaceAttributes.parentPlace];
    self.place.parent = @"Goofy";

    NSDictionary *JSON;
    
    STAssertNoThrow(JSON = [self.place toJSONDictionary], nil);
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)17, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.name], self.place.name, @"Wrong name.");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.displayName],
                         self.place.displayName, @"Wrong display name.");
    STAssertEqualObjects([JSON objectForKey:JiveObjectConstants.id], self.place.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"description"], self.place.jiveDescription, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.status], self.place.status, @"Wrong status update");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightBody],
                         self.place.highlightBody, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightSubject],
                         self.place.highlightSubject, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightTags],
                         self.place.highlightTags, @"Wrong thumbnail url");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.followerCount],
                         self.place.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.likeCount], self.place.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.viewCount], self.place.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.published], @"1970-01-01T00:16:40.123+0000", @"Wrong published date");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.updated], @"1970-01-01T00:00:00.000+0000", @"Wrong updated date");
    STAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.parent], self.place.parent, @"Wrong parent");
    STAssertNil([JSON objectForKey:JivePlaceAttributes.visibleToExternalContributors], @"Visibility included?");
    
    NSDictionary *parentContentJSON = [JSON objectForKey:JivePlaceAttributes.parentContent];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong user name");
    
    NSDictionary *parentPlaceJSON = [JSON objectForKey:JivePlaceAttributes.parentPlace];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong user name");
}

- (void)testToJSON_contentTypes {
    NSString *contentType1 = @"First";
    NSString *contentType2 = @"Last";
    
    [self.place setValue:[NSArray arrayWithObject:contentType1]
                  forKey:JivePlaceAttributes.contentTypes];
    
    NSDictionary *JSON = [self.place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");

    NSArray *addressJSON = [JSON objectForKey:JivePlaceAttributes.contentTypes];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the contentTypes array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], contentType1, @"Wrong contentType value");
    
    [self.place setValue:[self.place.contentTypes arrayByAddingObject:contentType2]
                  forKey:JivePlaceAttributes.contentTypes];
    
    STAssertNoThrow(JSON = [self.place toJSONDictionary], nil);
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");

    addressJSON = [JSON objectForKey:JivePlaceAttributes.contentTypes];
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
    
    [resource setValue:[NSURL URLWithString:@"http://dummy.com"]
                forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.place.displayName = @"testName";
    [self.place setValue:@"1234" forKey:@"jiveId"];
    self.place.jiveDescription = @"USA";
    [self.place setValue:@"Working for the man" forKey:JivePlaceAttributes.status];
    [self.place setValue:@"Body" forKey:JivePlaceAttributes.highlightBody];
    [self.place setValue:@"Subject" forKey:JivePlaceAttributes.highlightSubject];
    [self.place setValue:@"Tags" forKey:JivePlaceAttributes.highlightTags];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:JivePlaceAttributes.followerCount];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:JivePlaceAttributes.likeCount];
    [self.place setValue:[NSNumber numberWithInt:33] forKey:JivePlaceAttributes.viewCount];
    self.place.name = @"name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePlaceAttributes.published];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePlaceAttributes.updated];
    [self.place setValue:parentContent forKey:JivePlaceAttributes.parentContent];
    [self.place setValue:parentPlace forKey:JivePlaceAttributes.parentPlace];
    [self.place setValue:[NSArray arrayWithObject:contentType]
                  forKey:JivePlaceAttributes.contentTypes];
    self.place.parent = @"Parent";
    [self.place setValue:@{resourceKey:resource} forKey:JiveTypedObjectAttributesHidden.resources];
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"visibleToExternalContributors"
                    withObject:(__bridge id)kCFBooleanTrue];
    [self.place setValue:@"testIconCss" forKey:JivePlaceAttributes.iconCss];
    [self.place setValue:@"not here" forKey:JivePlaceAttributes.placeID];
    
    id JSON;
    JivePlace *newPlace;
    
    STAssertNoThrow(JSON = [self.place persistentJSON], nil);
    STAssertNoThrow(newPlace = [JivePlace objectFromJSON:JSON withInstance:self.instance], nil);
    
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
    STAssertEqualObjects(newPlace.iconCss, self.place.iconCss, nil);
    STAssertEqualObjects(newPlace.placeID, self.place.placeID, nil);
}

- (void)testPlaceParsingAlternate {
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    
    [resource setValue:[NSURL URLWithString:@"https://dummy.com"]
                forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [parentContent setValue:@"not content" forKey:@"name"];
    [parentPlace setValue:@"not place" forKey:@"name"];
    self.place.displayName = @"display name";
    [self.place setValue:@"87654" forKey:JivePlaceAttributes.jiveId];
    self.place.jiveDescription = @"New Mexico";
    [self.place setValue:@"No status" forKey:JivePlaceAttributes.status];
    [self.place setValue:@"not Body" forKey:JivePlaceAttributes.highlightBody];
    [self.place setValue:@"not Subject" forKey:JivePlaceAttributes.highlightSubject];
    [self.place setValue:@"not Tags" forKey:JivePlaceAttributes.highlightTags];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:JivePlaceAttributes.followerCount];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:JivePlaceAttributes.likeCount];
    [self.place setValue:[NSNumber numberWithInt:12] forKey:JivePlaceAttributes.viewCount];
    self.place.name = @"Alternate";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePlaceAttributes.published];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePlaceAttributes.updated];
    [self.place setValue:parentContent forKey:JivePlaceAttributes.parentContent];
    [self.place setValue:parentPlace forKey:JivePlaceAttributes.parentPlace];
    [self.place setValue:[NSArray arrayWithObject:contentType]
                  forKey:JivePlaceAttributes.contentTypes];
    self.place.parent = @"Goofy";
    [self.place setValue:@{resourceKey:resource} forKey:JiveTypedObjectAttributesHidden.resources];
    [self.place setValue:@"dummy" forKey:JivePlaceAttributes.iconCss];
    [self.place setValue:@"Chicago" forKey:JivePlaceAttributes.placeID];
    
    id JSON;
    JivePlace *newPlace;
    
    STAssertNoThrow(JSON = [self.place persistentJSON], nil);
    STAssertNoThrow(newPlace = [JivePlace objectFromJSON:JSON withInstance:self.instance], nil);
    
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
    STAssertEqualObjects(newPlace.iconCss, self.place.iconCss, nil);
    STAssertEqualObjects(newPlace.placeID, self.place.placeID, nil);
}

- (void)test_canCreate {
    id mockedPlace = [OCMockObject partialMockForObject:self.place];
    
    // announcement
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.announcements, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canCreateAnnouncement], @"user cannot create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.announcements, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canCreateAnnouncement], @"user can create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // invite
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.invites, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canCreateInvite], @"user cannot create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.invites, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canCreateInvite], @"user can create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // member
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.members, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canCreateMember], @"user cannot create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.members, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canCreateMember], @"user can create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // task
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.tasks, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canCreateTask], @"user cannot create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.tasks, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canCreateTask], @"user can create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // content
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.contents, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canCreateContent], @"user cannot create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.contents, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canCreateContent], @"user can create this type");
    STAssertNoThrow([mockedPlace verify], nil);
}

- (void)test_canAdd {
    id mockedPlace = [OCMockObject partialMockForObject:self.place];
    
    // extprops
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.extprops, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canAddExtProps], @"user cannot add this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.extprops, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canAddExtProps], @"user can add this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // statics
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.statics, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canAddStatic], @"user cannot add this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.statics, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canAddStatic], @"user can add this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // categories
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.categories, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canAddCategory], @"user cannot add this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.categories, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canAddCategory], @"user can add this type");
    STAssertNoThrow([mockedPlace verify], nil);
}

- (void)test_canDelete {
    id mockedPlace = [OCMockObject partialMockForObject:self.place];
    
    // extprops
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasDeleteForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.extprops, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canDeleteExtProps], @"user cannot add this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasDeleteForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.extprops, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canDeleteExtProps], @"user can add this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // avatar
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasDeleteForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.avatar, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canDeleteAvatar], @"user cannot add this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasDeleteForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.avatar, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canDeleteAvatar], @"user can add this type");
    STAssertNoThrow([mockedPlace verify], nil);
}

- (void)test_canUpdate {
    id mockedPlace = [OCMockObject partialMockForObject:self.place];
    
    // avatar
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.avatar, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canUpdateAvatar], @"user cannot create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.avatar, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canUpdateAvatar], @"user can create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // checkPoints
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.checkPoints, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canUpdateCheckPoints], @"user cannot create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.checkPoints, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canUpdateCheckPoints], @"user can create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    
    // followingIn
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.followingIn, @"Wrong property requested.");
        return YES;
    }]];
    STAssertFalse([mockedPlace canUpdateFollowingIn], @"user cannot create this type");
    STAssertNoThrow([mockedPlace verify], nil);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEqualObjects(obj, JivePlaceResourceAttributes.followingIn, @"Wrong property requested.");
        return YES;
    }]];
    STAssertTrue([mockedPlace canUpdateFollowingIn], @"user can create this type");
    STAssertNoThrow([mockedPlace verify], nil);
}

@end
