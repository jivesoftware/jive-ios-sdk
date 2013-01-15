//
//  JiveDocumentTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDocumentTests.h"
#import "JivePerson.h"
#import "JiveAttachment.h"

@implementation JiveDocumentTests

- (void)setUp {
    self.content = [[JiveDocument alloc] init];
}

- (JiveDocument *)document {
    return (JiveDocument *)self.content;
}

- (void)testAnnouncementToJSON {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *author = [[JivePerson alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *personURI = @"/person/1234";
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"document", @"Wrong type");
    
    attachment.contentType = @"person";
    approver.location = @"Tower";
    author.location = @"location";
    self.document.approvers = [NSArray arrayWithObject:approver];
    self.document.attachments = [NSArray arrayWithObject:attachment];
    self.document.authors = [NSArray arrayWithObject:author];
    self.document.authorship = @"open";
    self.document.categories = [NSArray arrayWithObject:category];
    self.document.fromQuest = @"fromQuest";
    [self.document setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.document setValue:[NSArray arrayWithObject:personURI] forKey:@"users"];
    self.document.visibility = @"hidden";
    self.document.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"authorship"], self.document.authorship, @"Wrong authorship");
    STAssertEqualObjects([JSON objectForKey:@"fromQuest"], self.document.fromQuest, @"Wrong fromQuest");
    STAssertEqualObjects([JSON objectForKey:@"visibility"], self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.document.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *attachmentsJSON = [JSON objectForKey:@"attachments"];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"contentType"], attachment.contentType, @"Wrong value");
    
    NSArray *approversJSON = [JSON objectForKey:@"approvers"];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    STAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([approverJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([approverJSON objectForKey:@"location"], approver.location, @"Wrong value");
    
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
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    
    attachment.contentType = @"place";
    approver.location = @"Restaurant";
    author.location = @"Subway";
    user.location = @"Theater";
    self.document.approvers = [NSArray arrayWithObject:approver];
    self.document.attachments = [NSArray arrayWithObject:attachment];
    self.document.authors = [NSArray arrayWithObject:author];
    self.document.authorship = @"limited";
    self.document.categories = [NSArray arrayWithObject:category];
    self.document.fromQuest = @"toAnyone";
    [self.document setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.document setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.document.visibility = @"people";
    self.document.restrictComments = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"authorship"], self.document.authorship, @"Wrong authorship");
    STAssertEqualObjects([JSON objectForKey:@"fromQuest"], self.document.fromQuest, @"Wrong fromQuest");
    STAssertEqualObjects([JSON objectForKey:@"visibility"], self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:@"restrictComments"], self.document.restrictComments, @"Wrong restrictComments");
    
    NSArray *attachmentsJSON = [JSON objectForKey:@"attachments"];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"contentType"], attachment.contentType, @"Wrong value");
    
    NSArray *approversJSON = [JSON objectForKey:@"approvers"];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    STAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([approverJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([approverJSON objectForKey:@"location"], approver.location, @"Wrong value");
    
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

- (void)testAnnouncementToJSON_boolProperties {
    self.document.restrictComments = [NSNumber numberWithBool:YES];
    self.document.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"restrictComments"], self.document.restrictComments, @"Wrong restrictComments");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.document.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

- (void)testToJSON_attachments {
    JiveAttachment *attachment1 = [[JiveAttachment alloc] init];
    JiveAttachment *attachment2 = [[JiveAttachment alloc] init];
    
    attachment1.contentType = @"document";
    attachment2.contentType = @"question";
    [self.document setValue:[NSArray arrayWithObject:attachment1] forKey:@"attachments"];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:@"attachments"];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    STAssertEqualObjects([object1 objectForKey:@"contentType"], attachment1.contentType, @"Wrong value");
    
    [self.document setValue:[self.document.attachments arrayByAddingObject:attachment2] forKey:@"attachments"];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    array = [JSON objectForKey:@"attachments"];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"contentType"], attachment1.contentType, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"contentType"], attachment2.contentType, @"Wrong value 2");
}

- (void)testToJSON_approvers {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"location";
    person2.location = @"Tower";
    [self.document setValue:[NSArray arrayWithObject:person1] forKey:@"approvers"];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:@"approvers"];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"approvers array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value");
    
    [self.document setValue:[self.document.approvers arrayByAddingObject:person2] forKey:@"approvers"];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    array = [JSON objectForKey:@"approvers"];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"approvers array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"location"], person2.location, @"Wrong value 2");
}

- (void)testToJSON_authors {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"location";
    person2.location = @"Tower";
    [self.document setValue:[NSArray arrayWithObject:person1] forKey:@"authors"];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:@"authors"];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value");
    
    [self.document setValue:[self.document.authors arrayByAddingObject:person2] forKey:@"authors"];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
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
    
    person1.location = @"location";
    person2.location = @"Tower";
    [self.document setValue:[NSArray arrayWithObject:person1] forKey:@"users"];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:@"users"];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:@"location"], person1.location, @"Wrong value");
    
    [self.document setValue:[self.document.users arrayByAddingObject:person2] forKey:@"users"];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
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
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    
    attachment.contentType = @"person";
    approver.location = @"Tower";
    author.location = @"location";
    user.location = @"mountain";
    self.document.approvers = [NSArray arrayWithObject:approver];
    self.document.attachments = [NSArray arrayWithObject:attachment];
    self.document.authors = [NSArray arrayWithObject:author];
    self.document.authorship = @"open";
    self.document.categories = [NSArray arrayWithObject:category];
    self.document.fromQuest = @"fromQuest";
    [self.document setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.document setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.document.visibility = @"hidden";
    self.document.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.document toJSONDictionary];
    JiveDocument *newContent = [JiveDocument instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.document class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.document.type, @"Wrong type");
    STAssertEqualObjects(newContent.authorship, self.document.authorship, @"Wrong authorship");
    STAssertEqualObjects(newContent.fromQuest, self.document.fromQuest, @"Wrong fromQuest");
    STAssertEqualObjects(newContent.visibility, self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.document.visibleToExternalContributors, @"Wrong visibleToExternalContributors");

    STAssertEquals([newContent.tags count], [self.document.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.document.categories count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.attachments count], [self.document.attachments count], @"Wrong number of attachment objects");
    if ([newContent.attachments count] > 0) {
        id convertedObject = [newContent.attachments objectAtIndex:0];
        STAssertEquals([convertedObject class], [JiveAttachment class], @"Wrong attachment object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveAttachment class]])
            STAssertEqualObjects([(JiveAttachment *)convertedObject contentType], attachment.contentType, @"Wrong attachment object");
    }
    STAssertEquals([newContent.approvers count], [self.document.approvers count], @"Wrong number of approver objects");
    if ([newContent.approvers count] > 0) {
        id convertedObject = [newContent.approvers objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong approver object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], approver.location, @"Wrong approver object");
    }
    STAssertEquals([newContent.authors count], [self.document.authors count], @"Wrong number of author objects");
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], author.location, @"Wrong author object");
    }
    STAssertEquals([newContent.users count], [self.document.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        id convertedObject = [newContent.users objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong user object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], user.location, @"Wrong user object");
    }
}

- (void)testAnnouncementParsingAlternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    
    attachment.contentType = @"place";
    approver.location = @"Restaurant";
    author.location = @"Subway";
    user.location = @"Theater";
    self.document.approvers = [NSArray arrayWithObject:approver];
    self.document.attachments = [NSArray arrayWithObject:attachment];
    self.document.authors = [NSArray arrayWithObject:author];
    self.document.authorship = @"limited";
    self.document.categories = [NSArray arrayWithObject:category];
    self.document.fromQuest = @"toAnyone";
    [self.document setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.document setValue:[NSArray arrayWithObject:user] forKey:@"users"];
    self.document.visibility = @"people";
    self.document.restrictComments = [NSNumber numberWithBool:YES];
    
    id JSON = [self.document toJSONDictionary];
    JiveDocument *newContent = [JiveDocument instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.document class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.document.type, @"Wrong type");
    STAssertEqualObjects(newContent.authorship, self.document.authorship, @"Wrong authorship");
    STAssertEqualObjects(newContent.fromQuest, self.document.fromQuest, @"Wrong fromQuest");
    STAssertEqualObjects(newContent.visibility, self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.document.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    STAssertEquals([newContent.tags count], [self.document.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.document.categories count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.attachments count], [self.document.attachments count], @"Wrong number of attachment objects");
    if ([newContent.attachments count] > 0) {
        id convertedObject = [newContent.attachments objectAtIndex:0];
        STAssertEquals([convertedObject class], [JiveAttachment class], @"Wrong attachment object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveAttachment class]])
            STAssertEqualObjects([(JiveAttachment *)convertedObject contentType], attachment.contentType, @"Wrong attachment object");
    }
    STAssertEquals([newContent.approvers count], [self.document.approvers count], @"Wrong number of approver objects");
    if ([newContent.approvers count] > 0) {
        id convertedObject = [newContent.approvers objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong approver object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], approver.location, @"Wrong approver object");
    }
    STAssertEquals([newContent.authors count], [self.document.authors count], @"Wrong number of author objects");
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], author.location, @"Wrong author object");
    }
    STAssertEquals([newContent.users count], [self.document.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        id convertedObject = [newContent.users objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong user object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], user.location, @"Wrong user object");
    }
}

@end
