//
//  JiveFavoriteTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
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

#import "JiveFavoriteTests.h"

@implementation JiveFavoriteTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveFavorite alloc] init];
}

- (JiveFavorite *)favorite {
    return (JiveFavorite *)self.content;
}

- (id) entityForClass:(Class) entityClass
        fromJSONNamed:(NSString *)jsonName {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:jsonName
                                                                          ofType:@"json"];
    NSData *rawJson = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:rawJson
                                                         options:0
                                                           error:NULL];
    id entity = [entityClass objectFromJSON:JSON withInstance:nil];
    return entity;
}

- (void)testType {
    STAssertEqualObjects(self.favorite.type, @"favorite", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.favorite.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.favorite class], @"Favorite class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.favorite class], @"Favorite class not registered with JiveContent.");
}

- (void)initializeFavorite {
    JiveExternalURLEntity *favoriteObject = [JiveExternalURLEntity new];
    
    favoriteObject.url = [NSURL URLWithString:@"http://dummy.com"];
    [favoriteObject setValue:@"12345" forKeyPath:JiveContentAttributes.status];
    self.favorite.private = @YES;
    self.favorite.favoriteObject = favoriteObject;
}

- (void)initializeAlternateFavorite {
    JiveDocument *favoriteObject = [JiveDocument new];
    
    [favoriteObject setValue:@"54321" forKeyPath:JiveContentAttributes.status];
    self.favorite.favoriteObject = favoriteObject;
}

- (void)testFavoriteToJSON {
    NSDictionary *JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"favorite", @"Wrong type");
    
    [self initializeFavorite];
    
    JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.favorite.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveFavoriteAttributes.private], self.favorite.private, @"Wrong private");
    
    NSDictionary *favoriteObject = JSON[JiveFavoriteAttributes.favoriteObject];
    
    STAssertTrue([[favoriteObject class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([favoriteObject count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(favoriteObject[JiveTypedObjectAttributes.type],
                         self.favorite.favoriteObject.type, @"Wrong type");
    STAssertEqualObjects(favoriteObject[JiveExternalURLEntityAttributes.url],
                         [((JiveExternalURLEntity *)self.favorite.favoriteObject).url absoluteString], @"Wrong url");
}

- (void)testFavoriteToJSON_alternate {
    NSDictionary *JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"favorite", @"Wrong type");
    
    [self initializeAlternateFavorite];
    
    JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.favorite.type, @"Wrong type");
    
    NSDictionary *favoriteObject = JSON[JiveFavoriteAttributes.favoriteObject];
    
    STAssertTrue([[favoriteObject class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([favoriteObject count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(favoriteObject[JiveTypedObjectAttributes.type],
                         self.favorite.favoriteObject.type, @"Wrong type");
}

- (void)testFavoritePersistentJSON {
    NSDictionary *JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"favorite", @"Wrong type");
    
    [self initializeFavorite];
    
    JSON = [self.favorite persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.favorite.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveFavoriteAttributes.private], self.favorite.private, @"Wrong private");
    
    NSDictionary *favoriteObject = JSON[JiveFavoriteAttributes.favoriteObject];
    
    STAssertTrue([[favoriteObject class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([favoriteObject count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(favoriteObject[JiveTypedObjectAttributes.type],
                         self.favorite.favoriteObject.type, @"Wrong type");
    STAssertEqualObjects(favoriteObject[JiveExternalURLEntityAttributes.url],
                         [((JiveExternalURLEntity *)self.favorite.favoriteObject).url absoluteString], @"Wrong url");
    STAssertEqualObjects(favoriteObject[JiveContentAttributes.status],
                         self.favorite.favoriteObject.status, @"Wrong status");
}

- (void)testFavoritePersistentJSON_alternate {
    NSDictionary *JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"favorite", @"Wrong type");
    
    [self initializeAlternateFavorite];
    
    JSON = [self.favorite persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.favorite.type, @"Wrong type");
    
    NSDictionary *favoriteObject = JSON[JiveFavoriteAttributes.favoriteObject];
    
    STAssertTrue([[favoriteObject class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([favoriteObject count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(favoriteObject[JiveTypedObjectAttributes.type],
                         self.favorite.favoriteObject.type, @"Wrong type");
    STAssertEqualObjects(favoriteObject[JiveContentAttributes.status],
                         self.favorite.favoriteObject.status, @"Wrong status");
}

- (void)testFavoriteParsing {
    [self initializeFavorite];
    
    id JSON = [self.favorite persistentJSON];
    JiveFavorite *newContent = [JiveFavorite objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.favorite class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.favorite.type, @"Wrong type");
    STAssertEqualObjects(newContent.private, self.favorite.private, @"Wrong private");
    STAssertEqualObjects(newContent.favoriteObject.type, self.favorite.favoriteObject.type, @"Wrong favoriteObject");
    STAssertEqualObjects(newContent.favoriteObject.status, self.favorite.favoriteObject.status, @"Wrong favoriteObject");
    STAssertEqualObjects([((JiveExternalURLEntity *)newContent.favoriteObject).url absoluteString],
                         [((JiveExternalURLEntity *)self.favorite.favoriteObject).url absoluteString], @"Wrong favoriteObject");
}

- (void)testFavoriteParsing_alternate {
    [self initializeAlternateFavorite];
    
    id JSON = [self.favorite persistentJSON];
    JiveFavorite *newContent = [JiveFavorite objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.favorite class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.favorite.type, @"Wrong type");
    STAssertEqualObjects(newContent.private, self.favorite.private, @"Wrong private");
    STAssertEqualObjects(newContent.favoriteObject.type, self.favorite.favoriteObject.type, @"Wrong favoriteObject");
    STAssertEqualObjects(newContent.favoriteObject.status, self.favorite.favoriteObject.status, @"Wrong favoriteObject");
}

- (void)test_createFavoriteForContent_name {
    JiveContent *source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_alternate"];
    NSString *name = @"first name";
    NSString *notes = @"first notes";
    JiveFavorite *favorite = [JiveFavorite createFavoriteForContent:source name:name notes:notes];
    
    STAssertEqualObjects(favorite.subject, name, nil);
    STAssertEqualObjects([((JiveExternalURLEntity *)favorite.favoriteObject).url absoluteString],
                         [source.selfRef absoluteString], nil);
    STAssertEqualObjects(favorite.notes, notes, nil);
    STAssertEqualObjects(favorite.content.type, @"text/html", nil);
    
    name = @"second name";
    notes = @"second notes";
    favorite = [JiveFavorite createFavoriteForContent:source name:name notes:notes];
    STAssertEqualObjects(favorite.subject, name, nil);
    STAssertEqualObjects([((JiveExternalURLEntity *)favorite.favoriteObject).url absoluteString],
                         [source.selfRef absoluteString], nil);
    STAssertEqualObjects(favorite.notes, notes, nil);
    STAssertEqualObjects(favorite.content.type, @"text/html", nil);
    
    source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    name = @"third name";
    notes = @"third notes";
    favorite = [JiveFavorite createFavoriteForContent:source name:name notes:notes];
    STAssertEqualObjects(favorite.subject, name, nil);
    STAssertEqualObjects([((JiveExternalURLEntity *)favorite.favoriteObject).url absoluteString],
                         [source.selfRef absoluteString], nil);
    STAssertEqualObjects(favorite.notes, notes, nil);
    STAssertEqualObjects(favorite.content.type, @"text/html", nil);
    
    source = [self entityForClass:[JiveContent class] fromJSONNamed:@"content_by_id"];
    name = @"Fourth name";
    notes = nil;
    favorite = [JiveFavorite createFavoriteForContent:source name:name notes:notes];
    STAssertEqualObjects(favorite.subject, name, nil);
    STAssertEqualObjects([((JiveExternalURLEntity *)favorite.favoriteObject).url absoluteString],
                         [source.selfRef absoluteString], nil);
    STAssertEqualObjects(favorite.notes, @"", nil);
    STAssertEqualObjects(favorite.content.type, @"text/html", nil);
    
    notes = @"This really is a note";
    favorite.notes = notes;
    STAssertEqualObjects(favorite.content.text, notes, nil);
}

@end
