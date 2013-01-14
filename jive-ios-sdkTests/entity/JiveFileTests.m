//
//  JiveFileTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveFileTests.h"
#import "JivePerson.h"

@implementation JiveFileTests

- (void)setUp {
    self.content = [[JiveFile alloc] init];
}

- (JiveFile *)file {
    return (JiveFile *)self.content;
}

- (void)testAnnouncementToJSON {
    JivePerson *author = [[JivePerson alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *personURI = @"/person/1234";
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"file", @"Wrong type");
    
    author.location = @"author";
    self.file.authors = [NSArray arrayWithObject:author];
    self.file.authorship = @"open";
    [self.file setValue:[NSURL URLWithString:@"http://dummy.com/text.txt"] forKey:@"binaryURL"];
    self.file.categories = [NSArray arrayWithObject:category];
    [self.file setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.file setValue:[NSArray arrayWithObject:personURI] forKey:@"users"];
    self.file.visibility = @"hidden";
    self.file.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)9, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.file.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"authorship"], self.file.authorship, @"Wrong authorship");
    STAssertEqualObjects([JSON objectForKey:@"binaryURL"], [self.file.binaryURL absoluteString], @"Wrong binaryURL");
    STAssertEqualObjects([JSON objectForKey:@"visibility"], self.file.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.file.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *authorsJSON = [JSON objectForKey:@"authors"];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    STAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:@"location"], author.location, @"Wrong value");
    
    NSArray *usersJSON = [JSON objectForKey:@"users"];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([usersJSON objectAtIndex:0], personURI, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:@"categories"];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
}

- (void)testAnnouncementToJSON_alternate {
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    
    author.location = @"James Joyce";
    user.location = @"one";
    self.file.authors = [NSArray arrayWithObject:author];
    self.file.authorship = @"limited";
    [self.file setValue:[NSURL URLWithString:@"http://super.com/mos.png"] forKey:@"binaryURL"];
    self.file.categories = [NSArray arrayWithObject:category];
    [self.file setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.file setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.file.visibility = @"people";
    
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.file.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"authorship"], self.file.authorship, @"Wrong authorship");
    STAssertEqualObjects([JSON objectForKey:@"binaryURL"], [self.file.binaryURL absoluteString], @"Wrong binaryURL");
    STAssertEqualObjects([JSON objectForKey:@"visibility"], self.file.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.file.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *authorsJSON = [JSON objectForKey:@"authors"];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    STAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:@"location"], author.location, @"Wrong value");
    
    NSArray *usersJSON = [JSON objectForKey:@"users"];
    NSDictionary *userJSON = [usersJSON objectAtIndex:0];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([userJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([userJSON objectForKey:@"location"], user.location, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:@"categories"];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
}

- (void)testToJSON_authors {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"file";
    person2.location = @"question";
    [self.file setValue:[NSArray arrayWithObject:person1] forKey:@"authors"];
    
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.file.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:@"authors"];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value");
    
    [self.file setValue:[self.file.authors arrayByAddingObject:person2] forKey:@"authors"];
    
    JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.file.type, @"Wrong type");
    
    array = [JSON objectForKey:@"authors"];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"location"], person2.location, @"Wrong value 2");
}

- (void)testToJSON_users {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"file";
    person2.location = @"question";
    [self.file setValue:[NSArray arrayWithObject:person1] forKey:@"users"];
    
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.file.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:@"users"];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value");
    
    [self.file setValue:[self.file.users arrayByAddingObject:person2] forKey:@"users"];
    
    JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.file.type, @"Wrong type");
    
    array = [JSON objectForKey:@"users"];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"location"], person2.location, @"Wrong value 2");
}

- (void)testAnnouncementParsing {
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    
    author.location = @"author";
    user.location = @"user";
    self.file.authors = [NSArray arrayWithObject:author];
    self.file.authorship = @"open";
    [self.file setValue:[NSURL URLWithString:@"http://dummy.com/text.txt"] forKey:@"binaryURL"];
    self.file.categories = [NSArray arrayWithObject:category];
    [self.file setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.file setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.file.visibility = @"hidden";
    self.file.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.file toJSONDictionary];
    JiveFile *newContent = [JiveFile instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.file class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.file.type, @"Wrong type");
    STAssertEqualObjects(newContent.authorship, self.file.authorship, @"Wrong authorship");
    STAssertEqualObjects(newContent.binaryURL, self.file.binaryURL, @"Wrong binaryURL");
    STAssertEqualObjects(newContent.visibility, self.file.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.file.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.file.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.file.categories count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.authors count], [self.file.authors count], @"Wrong number of author objects");
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], author.location, @"Wrong author object");
    }
    
    STAssertEquals([newContent.users count], [self.file.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        id convertedObject = [newContent.users objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong user object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], user.location, @"Wrong user object");
    }
}

- (void)testAnnouncementParsingAlternate {
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    
    author.location = @"James Joyce";
    user.location = @"one";
    self.file.authors = [NSArray arrayWithObject:author];
    self.file.authorship = @"limited";
    [self.file setValue:[NSURL URLWithString:@"http://super.com/mos.png"] forKey:@"binaryURL"];
    self.file.categories = [NSArray arrayWithObject:category];
    [self.file setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.file setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.file.visibility = @"people";
    
    id JSON = [self.file toJSONDictionary];
    JiveFile *newContent = [JiveFile instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.file class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.file.type, @"Wrong type");
    STAssertEqualObjects(newContent.authorship, self.file.authorship, @"Wrong authorship");
    STAssertEqualObjects(newContent.binaryURL, self.file.binaryURL, @"Wrong binaryURL");
    STAssertEqualObjects(newContent.visibility, self.file.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.file.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.file.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.file.categories count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.authors count], [self.file.authors count], @"Wrong number of author objects");
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], author.location, @"Wrong author object");
    }
    
    STAssertEquals([newContent.users count], [self.file.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        id convertedObject = [newContent.users objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong user object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], user.location, @"Wrong user object");
    }
}

@end
