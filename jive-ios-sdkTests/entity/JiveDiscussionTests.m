//
//  JiveDiscussonTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDiscussionTests.h"

@implementation JiveDiscussionTests

- (void)setUp {
    self.content = [[JiveDiscussion alloc] init];
}

- (JiveDiscussion *)discussion {
    return (JiveDiscussion *)self.content;
}

- (void)testAnnouncementToJSON {
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *personURI = @"/person/1234";
    NSDictionary *JSON = [self.discussion toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"discussion", @"Wrong type");
    
    self.discussion.categories = [NSArray arrayWithObject:category];
    [self.discussion setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.discussion setValue:[NSArray arrayWithObject:personURI] forKey:@"users"];
    self.discussion.visibility = @"all";
    self.discussion.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.discussion toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.discussion.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"visibility"], self.discussion.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.discussion.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
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
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    
    user.location = @"one";
    self.discussion.categories = [NSArray arrayWithObject:category];
    [self.discussion setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.discussion setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.discussion.visibility = @"people";
    self.discussion.question = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.discussion toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.discussion.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"visibility"], self.discussion.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:@"question"], self.discussion.question, @"Wrong question");
    
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

- (void)testAnnouncementToJSON_boolProperties {
    self.discussion.question = [NSNumber numberWithBool:YES];
    self.discussion.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.discussion toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.discussion.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"question"], self.discussion.question, @"Wrong question");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.discussion.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

- (void)testToJSON_users {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"discussion";
    person2.location = @"question";
    [self.discussion setValue:[NSArray arrayWithObject:person1] forKey:@"users"];
    
    NSDictionary *JSON = [self.discussion toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.discussion.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:@"users"];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value");
    
    [self.discussion setValue:[self.discussion.users arrayByAddingObject:person2] forKey:@"users"];
    
    JSON = [self.discussion toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.discussion.type, @"Wrong type");
    
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
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    
    user.location = @"user";
    self.discussion.categories = [NSArray arrayWithObject:category];
    [self.discussion setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.discussion setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.discussion.visibility = @"all";
    self.discussion.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.discussion toJSONDictionary];
    JiveDiscussion *newContent = [JiveDiscussion instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.discussion class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.discussion.type, @"Wrong type");
    STAssertEqualObjects(newContent.question, self.discussion.question, @"Wrong question");
    STAssertEqualObjects(newContent.visibility, self.discussion.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.discussion.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.discussion.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.discussion.categories count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.users count], [self.discussion.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        id convertedObject = [newContent.users objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong user object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], user.location, @"Wrong user object");
    }
}

- (void)testAnnouncementParsingAlternate {
   JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    
    user.location = @"one";
    self.discussion.categories = [NSArray arrayWithObject:category];
    [self.discussion setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.discussion setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.discussion.visibility = @"people";
    self.discussion.question = [NSNumber numberWithBool:YES];
    
    id JSON = [self.discussion toJSONDictionary];
    JiveDiscussion *newContent = [JiveDiscussion instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.discussion class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.discussion.type, @"Wrong type");
    STAssertEqualObjects(newContent.question, self.discussion.question, @"Wrong question");
    STAssertEqualObjects(newContent.visibility, self.discussion.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.discussion.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.discussion.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.discussion.categories count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.users count], [self.discussion.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        id convertedObject = [newContent.users objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong user object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], user.location, @"Wrong user object");
    }
}

@end
