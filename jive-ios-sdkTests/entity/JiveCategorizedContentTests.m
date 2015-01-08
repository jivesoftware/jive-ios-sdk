//
//  JiveCategorizedContentTests.m
//  
//
//  Created by Orson Bushnell on 11/19/14.
//
//

#import "JiveCategorizedContentTests.h"


@interface MockJiveCategorizedContent : JiveCategorizedContent

@end

@interface JiveStructuredOutcomeContentTest (JiveCategorizedContentTests)

- (void)testStructuredOutcomeContentParsing;
- (void)testStructuredOutcomeContentParsingAlternate;

@end


@implementation MockJiveCategorizedContent

- (NSString *)type {
    return @"Categorized test.";
}

@end

@implementation JiveCategorizedContentTests

- (void)setUp {
    [super setUp];
    self.object = [MockJiveCategorizedContent new];
}

- (JiveCategorizedContent *)categorizedContent {
    return (JiveCategorizedContent *)self.structuredOutcome;
}

- (void)initializeCategorizedContent {
    NSString *category = @"category";
    JivePerson *author = [JivePerson new];
    NSString *personURI = @"/person/1234";
    
    author.location = @"location";
    [author setValue:@"no name" forKey:JivePersonAttributes.displayName];
    self.categorizedContent.categories = @[category];
    self.categorizedContent.extendedAuthors = @[author];
    self.categorizedContent.users = @[personURI];
    self.categorizedContent.visibility = @"all";
    
}

- (void)initializeAlternateCategorizedContent {
    NSString *category = @"denomination";
    JivePerson *author = [JivePerson new];
    JivePerson *user = [JivePerson new];
    
    author.location = @"Boulder";
    [author setValue:@"Jive" forKey:JivePersonAttributes.displayName];
    user.location = @"location";
    [user setValue:@"no name" forKey:JivePersonAttributes.displayName];
    self.categorizedContent.categories = @[category];
    self.categorizedContent.extendedAuthors = @[author];
    self.categorizedContent.users = @[user];
    self.categorizedContent.visibility = @"people";
}

- (void)testAuthorableContentToJSON {
    NSDictionary *JSON = [self.categorizedContent toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertNotNil(JSON[JiveTypedObjectAttributes.type], @"Wrong type");
    
    [self initializeCategorizedContent];
    
    JSON = [self.categorizedContent toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveCategorizedContentAttributes.visibility],
                         self.categorizedContent.visibility, @"Wrong visibility");
    
    NSArray *categoriesJSON = JSON[JiveCategorizedContentAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Categories array had the wrong number of entries");
    STAssertEqualObjects(categoriesJSON[0], self.categorizedContent.categories[0], @"Wrong value");
    
    NSArray *extendedAuthorsJSON = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    NSDictionary *authorJSON = [extendedAuthorsJSON lastObject];
    
    STAssertTrue([[extendedAuthorsJSON class] isSubclassOfClass:[NSArray class]], @"ExtendedAuthors array not converted");
    STAssertEquals([extendedAuthorsJSON count], (NSUInteger)1, @"ExtendedAuthors array had the wrong number of entries");
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"ExtendedAuthors dictionary had the wrong number of entries");
    STAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong author");
    
    NSArray *usersJSON = JSON[JiveCategorizedContentAttributes.users];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Users array had the wrong number of entries");
    STAssertEqualObjects(usersJSON[0], self.categorizedContent.users[0], @"Wrong user");
}

- (void)testAuthorableContentToJSON_alternate {
    [self initializeAlternateCategorizedContent];
    
    NSDictionary *JSON = [self.categorizedContent toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveCategorizedContentAttributes.visibility],
                         self.categorizedContent.visibility, @"Wrong visibility");
    
    NSArray *categoriesJSON = JSON[JiveCategorizedContentAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Categories array had the wrong number of entries");
    STAssertEqualObjects(categoriesJSON[0], self.categorizedContent.categories[0], @"Wrong value");
    
    NSArray *extendedAuthorsJSON = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    NSDictionary *authorJSON = [extendedAuthorsJSON lastObject];
    
    STAssertTrue([[extendedAuthorsJSON class] isSubclassOfClass:[NSArray class]], @"ExtendedAuthors array not converted");
    STAssertEquals([extendedAuthorsJSON count], (NSUInteger)1, @"ExtendedAuthors array had the wrong number of entries");
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"ExtendedAuthors dictionary had the wrong number of entries");
    STAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong author");
    
    NSArray *usersJSON = JSON[JiveCategorizedContentAttributes.users];
    NSDictionary *userJSON = [usersJSON lastObject];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Users array not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Users array had the wrong number of entries");
    STAssertTrue([[userJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    STAssertEquals([userJSON count], (NSUInteger)2, @"User dictionary had the wrong number of entries");
    STAssertEqualObjects(userJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.users[0]).location, @"Wrong user");
}

- (void)testToJSON_extendedAuthors {
    JivePerson *person1 = [JivePerson new];
    JivePerson *person2 = [JivePerson new];
    
    person1.location = @"Tower";
    person2.location = @"Subway";
    [self.categorizedContent setValue:@[person1] forKey:JiveCategorizedContentAttributes.extendedAuthors];
    
    NSDictionary *JSON = [self.categorizedContent toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    
    NSArray *array = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    id object1 = array[0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.categorizedContent setValue:[self.categorizedContent.extendedAuthors arrayByAddingObject:person2]
                               forKey:JiveCategorizedContentAttributes.extendedAuthors];
    
    JSON = [self.categorizedContent toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    
    array = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    object1 = array[0];
    
    id object2 = array[1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testToJSON_users {
    JivePerson *person1 = [JivePerson new];
    JivePerson *person2 = [JivePerson new];
    
    person1.location = @"Tower";
    person2.location = @"Subway";
    [self.categorizedContent setValue:@[person1] forKey:JiveCategorizedContentAttributes.users];
    
    NSDictionary *JSON = [self.categorizedContent toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    
    NSArray *array = JSON[JiveCategorizedContentAttributes.users];
    id object1 = array[0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.categorizedContent setValue:[self.categorizedContent.users arrayByAddingObject:person2]
                               forKey:JiveCategorizedContentAttributes.users];
    
    JSON = [self.categorizedContent toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    
    array = JSON[JiveCategorizedContentAttributes.users];
    object1 = array[0];
    
    id object2 = array[1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testAuthorableContentPersistentJSON {
    NSDictionary *JSON = [self.categorizedContent persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.categorizedContent.type, @"Wrong type");
    
    [self initializeCategorizedContent];
    
    JSON = [self.categorizedContent persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.categorizedContent.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveCategorizedContentAttributes.visibility],
                         self.categorizedContent.visibility, @"Wrong visibility");
    
    NSArray *usersJSON = [JSON objectForKey:JiveCategorizedContentAttributes.users];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(usersJSON[0], self.categorizedContent.users[0], @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveCategorizedContentAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(categoriesJSON[0], self.categorizedContent.categories[0], @"Wrong value");
    
    NSArray *extendedAuthorsJSON = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    NSDictionary *authorJSON = [extendedAuthorsJSON lastObject];
    
    STAssertTrue([[extendedAuthorsJSON class] isSubclassOfClass:[NSArray class]], @"ExtendedAuthors array not converted");
    STAssertEquals([extendedAuthorsJSON count], (NSUInteger)1, @"ExtendedAuthors array had the wrong number of entries");
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    STAssertEquals([authorJSON count], (NSUInteger)3, @"ExtendedAuthors dictionary had the wrong number of entries");
    STAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong author");
    STAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).displayName, @"Wrong display name");
}

- (void)testAuthorableContentPersistentJSON_alternate {
    [self initializeAlternateCategorizedContent];
    
    NSDictionary *JSON = [self.categorizedContent persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.categorizedContent.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveCategorizedContentAttributes.visibility],
                         self.categorizedContent.visibility, @"Wrong visibility");
    
    NSArray *usersJSON = [JSON objectForKey:JiveCategorizedContentAttributes.users];
    NSDictionary *userJSON = usersJSON[0];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([userJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([userJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.users[0]).location, @"Wrong value");
    STAssertEqualObjects([userJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.categorizedContent.users[0]).displayName, @"Wrong display name");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveCategorizedContentAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(categoriesJSON[0], self.categorizedContent.categories[0], @"Wrong value");
    
    NSArray *extendedAuthorsJSON = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    NSDictionary *authorJSON = [extendedAuthorsJSON lastObject];
    
    STAssertTrue([[extendedAuthorsJSON class] isSubclassOfClass:[NSArray class]], @"ExtendedAuthors array not converted");
    STAssertEquals([extendedAuthorsJSON count], (NSUInteger)1, @"ExtendedAuthors array had the wrong number of entries");
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    STAssertEquals([authorJSON count], (NSUInteger)3, @"ExtendedAuthors dictionary had the wrong number of entries");
    STAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong author");
    STAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).displayName, @"Wrong display name");
}

- (void)testAuthorableContentParsing {
    [self initializeCategorizedContent];
    
    self.categorizedContent.users = nil;
    id JSON = [self.categorizedContent persistentJSON];
    JiveCategorizedContent *newContent = [MockJiveCategorizedContent objectFromJSON:JSON
                                                                     withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.categorizedContent class]],
                 @"Wrong item class: %@", [newContent class]);
    STAssertEqualObjects(newContent.type, self.categorizedContent.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibility, self.categorizedContent.visibility, @"Wrong visibility");
    STAssertEquals([newContent.categories count], [self.categorizedContent.categories count], @"Wrong categories count");
    STAssertEqualObjects(newContent.categories[0], self.categorizedContent.categories[0], @"Wrong category");
    
    STAssertEquals([newContent.users count], [self.categorizedContent.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        JivePerson *convertedPerson = newContent.users[0];
        STAssertEquals([convertedPerson class], [JivePerson class], @"Wrong user object class");
        if ([[convertedPerson class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([convertedPerson location],
                                 ((JivePerson *)self.categorizedContent.users[0]).location, @"Wrong user object");
    }
    
    STAssertEquals([newContent.extendedAuthors count],
                   [self.categorizedContent.extendedAuthors count], @"Wrong number of extendedAuthor objects");
    if ([newContent.extendedAuthors count] > 0) {
        JivePerson *convertedPerson = newContent.extendedAuthors[0];
        STAssertEquals([convertedPerson class], [JivePerson class], @"Wrong user object class");
        if ([[convertedPerson class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([convertedPerson location],
                                 ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong user object");
    }
}

- (void)testAuthorableContentParsing_alternate {
    [self initializeAlternateCategorizedContent];
    
    id JSON = [self.categorizedContent persistentJSON];
    JiveCategorizedContent *newContent = [MockJiveCategorizedContent objectFromJSON:JSON
                                                                     withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.categorizedContent class]],
                 @"Wrong item class: %@", [newContent class]);
    STAssertEqualObjects(newContent.type, self.categorizedContent.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibility, self.categorizedContent.visibility, @"Wrong visibility");
    STAssertEquals([newContent.categories count], [self.categorizedContent.categories count], @"Wrong categories count");
    STAssertEqualObjects(newContent.categories[0], self.categorizedContent.categories[0], @"Wrong category");
    
    STAssertEquals([newContent.users count], [self.categorizedContent.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        JivePerson *convertedPerson = newContent.users[0];
        STAssertEquals([convertedPerson class], [JivePerson class], @"Wrong user object class");
        if ([[convertedPerson class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([convertedPerson location],
                                 ((JivePerson *)self.categorizedContent.users[0]).location, @"Wrong user object");
    }
    
    STAssertEquals([newContent.extendedAuthors count],
                   [self.categorizedContent.extendedAuthors count], @"Wrong number of extendedAuthor objects");
    if ([newContent.extendedAuthors count] > 0) {
        JivePerson *convertedPerson = newContent.extendedAuthors[0];
        STAssertEquals([convertedPerson class], [JivePerson class], @"Wrong user object class");
        if ([[convertedPerson class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([convertedPerson location],
                                 ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong user object");
    }
}

- (BOOL)isNotMockCategorized {
    return [self.categorizedContent class] != [MockJiveCategorizedContent class];
}

- (void)testStructuredOutcomeContentParsing {
    if ([self isNotMockCategorized]) {
        [super testStructuredOutcomeContentParsing];
    }
}

- (void)testStructuredOutcomeContentParsingAlternate {
    if ([self isNotMockCategorized]) {
        [super testStructuredOutcomeContentParsingAlternate];
    }
}

@end
