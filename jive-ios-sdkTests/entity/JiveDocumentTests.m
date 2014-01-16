//
//  JiveDocumentTests.m
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

#import "JiveDocumentTests.h"
#import "JivePerson.h"
#import "JiveAttachment.h"
#import "JiveOutcomeType.h"

@implementation JiveDocumentTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveDocument alloc] init];
}

- (JiveDocument *)document {
    return (JiveDocument *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.document.type, @"document", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.document.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.document class],
                         @"Document class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.document class],
                         @"Document class not registered with JiveContent.");
}

- (void)testDocumentToJSON {
    JiveAttachment *attachment = [JiveAttachment new];
    JivePerson *approver = [JivePerson new];
    JivePerson *author = [JivePerson new];
    JivePerson *editor = [JivePerson new];
    JivePerson *updater = [JivePerson new];
    JiveOutcomeType *outcome = [JiveOutcomeType new];
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
    editor.location = @"Spire";
    updater.location = @"cloud";
    [outcome setValue:@"outcome" forKey:JiveOutcomeTypeAttributes.jiveId];
    self.document.approvers = @[approver];
    self.document.attachments = @[attachment];
    self.document.authors = @[author];
    self.document.authorship = @"open";
    self.document.categories = @[category];
    [self.document setValue:editor forKey:JiveDocumentAttributes.editingBy];
    self.document.fromQuest = @"fromQuest";
    [self.document setValue:@[outcome] forKey:JiveDocumentAttributes.outcomeTypes];
    [self.document setValue:@{outcome.jiveId: @1} forKey:JiveDocumentAttributes.outcomeCounts];
    self.document.outcomeTypeNames = @[outcome.jiveId];
    self.document.restrictComments = @YES;
    self.document.tags = @[tag];
    [self.document setValue:updater forKey:JiveDocumentAttributes.updater];
    self.document.users = @[personURI];
    self.document.visibility = @"hidden";
    [self.document setValue:@YES forKey:JiveDocumentAttributes.visibleToExternalContributors];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)12, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.authorship],
                         self.document.authorship, @"Wrong authorship");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.fromQuest],
                         self.document.fromQuest, @"Wrong fromQuest");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibility],
                         self.document.visibility, @"Wrong visibility");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveDocumentAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.contentType], attachment.contentType, @"Wrong value");
    
    NSArray *approversJSON = [JSON objectForKey:JiveDocumentAttributes.approvers];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    STAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([approverJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.location], approver.location, @"Wrong value");
    
    NSArray *authorsJSON = [JSON objectForKey:JiveDocumentAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    STAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location], author.location, @"Wrong value");
    
    NSArray *usersJSON = [JSON objectForKey:JiveDocumentAttributes.users];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([usersJSON objectAtIndex:0], personURI, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveDocumentAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveDocumentAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveDocumentAttributes.outcomeTypeNames];
    
    STAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([outcomeTypeNamesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(outcomeTypeNamesJSON[0], outcome.jiveId, @"Wrong value");
}

- (void)testDocumentToJSON_alternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *editor = [JivePerson new];
    JivePerson *user = [[JivePerson alloc] init];
    JivePerson *updater = [JivePerson new];
    JiveOutcomeType *outcome = [JiveOutcomeType new];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    NSString *decision = @"decision";
    
    attachment.contentType = @"place";
    approver.location = @"Restaurant";
    author.location = @"Subway";
    editor.location = @"Elevator";
    user.location = @"Theater";
    updater.location = @"Taxi";
    [outcome setValue:@"failed" forKey:JiveOutcomeTypeAttributes.jiveId];
    self.document.approvers = @[approver];
    self.document.attachments = @[attachment];
    self.document.authors = @[author];
    self.document.authorship = @"limited";
    self.document.categories = @[category];
    [self.document setValue:editor forKey:JiveDocumentAttributes.editingBy];
    self.document.fromQuest = @"toAnyone";
    [self.document setValue:@[outcome] forKey:JiveDocumentAttributes.outcomeTypes];
    [self.document setValue:@{outcome.jiveId: @1} forKey:JiveDocumentAttributes.outcomeCounts];
    self.document.outcomeTypeNames = @[outcome.jiveId, decision];
    self.document.tags = @[tag];
    [self.document setValue:updater forKey:JiveDocumentAttributes.updater];
    self.document.users = @[user];
    self.document.visibility = @"people";

    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.authorship],
                         self.document.authorship, @"Wrong authorship");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.fromQuest],
                         self.document.fromQuest, @"Wrong fromQuest");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibility],
                         self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveDocumentAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.contentType], attachment.contentType, @"Wrong value");
    
    NSArray *approversJSON = [JSON objectForKey:JiveDocumentAttributes.approvers];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    STAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([approverJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.location], approver.location, @"Wrong value");
    
    NSArray *authorsJSON = [JSON objectForKey:JiveDocumentAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    STAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location], author.location, @"Wrong value");
    
    NSArray *usersJSON = [JSON objectForKey:JiveDocumentAttributes.users];
    NSDictionary *userJSON = [usersJSON objectAtIndex:0];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([userJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([userJSON objectForKey:JivePersonAttributes.location], user.location, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveDocumentAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveDocumentAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveDocumentAttributes.outcomeTypeNames];
    
    STAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([outcomeTypeNamesJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(outcomeTypeNamesJSON[0], outcome.jiveId, @"Wrong value");
    STAssertEqualObjects(outcomeTypeNamesJSON[1], decision, @"Wrong value");
}

- (void)testDocumentPersistentJSON_boolProperties {
    self.document.restrictComments = @YES;
    
    NSDictionary *JSON = [self.document persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibleToExternalContributors],
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");

    [self.document setValue:@YES forKey:JiveDocumentAttributes.visibleToExternalContributors];
    JSON = [self.document persistentJSON];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibleToExternalContributors],
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");

    self.document.restrictComments = @NO;
    JSON = [self.document persistentJSON];
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibleToExternalContributors],
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");
}

- (void)testToJSON_attachments {
    JiveAttachment *attachment1 = [[JiveAttachment alloc] init];
    JiveAttachment *attachment2 = [[JiveAttachment alloc] init];
    
    attachment1.contentType = @"document";
    attachment2.contentType = @"question";
    [self.document setValue:[NSArray arrayWithObject:attachment1]
                     forKey:JiveDocumentAttributes.attachments];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveDocumentAttributes.attachments];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    STAssertEqualObjects([object1 objectForKey:JiveAttachmentAttributes.contentType], attachment1.contentType, @"Wrong value");
    
    [self.document setValue:[self.document.attachments arrayByAddingObject:attachment2]
                     forKey:JiveDocumentAttributes.attachments];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveDocumentAttributes.attachments];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:JiveAttachmentAttributes.contentType], attachment1.contentType, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:JiveAttachmentAttributes.contentType], attachment2.contentType, @"Wrong value 2");
}

- (void)testToJSON_approvers {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"location";
    person2.location = @"Tower";
    [self.document setValue:[NSArray arrayWithObject:person1]
                     forKey:JiveDocumentAttributes.approvers];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveDocumentAttributes.approvers];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"approvers array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.document setValue:[self.document.approvers arrayByAddingObject:person2]
                     forKey:JiveDocumentAttributes.approvers];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveDocumentAttributes.approvers];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"approvers array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testToJSON_authors {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"location";
    person2.location = @"Tower";
    [self.document setValue:[NSArray arrayWithObject:person1] forKey:JiveDocumentAttributes.authors];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveDocumentAttributes.authors];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.document setValue:[self.document.authors arrayByAddingObject:person2]
                     forKey:JiveDocumentAttributes.authors];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveDocumentAttributes.authors];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testToJSON_users {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"location";
    person2.location = @"Tower";
    [self.document setValue:[NSArray arrayWithObject:person1] forKey:JiveDocumentAttributes.users];
    
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveDocumentAttributes.users];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.document setValue:[self.document.users arrayByAddingObject:person2]
                     forKey:JiveDocumentAttributes.users];
    
    JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveDocumentAttributes.users];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testDocumentPersistentJSON {
    JiveAttachment *attachment = [JiveAttachment new];
    JivePerson *approver = [JivePerson new];
    JivePerson *author = [JivePerson new];
    JivePerson *editor = [JivePerson new];
    JivePerson *updater = [JivePerson new];
    JiveOutcomeType *outcome = [JiveOutcomeType new];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *personURI = @"/person/1234";
    NSNumber *outcomeCount = @1;
    NSDictionary *JSON = [self.document toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"document", @"Wrong type");
    
    attachment.contentType = @"person";
    [attachment setValue:@55 forKey:JiveAttachmentAttributes.size];
    approver.location = @"Tower";
    [approver setValue:approver.location forKey:JivePersonAttributes.displayName];
    author.location = @"location";
    [author setValue:author.location forKey:JivePersonAttributes.displayName];
    editor.location = @"Spire";
    [editor setValue:editor.location forKey:JivePersonAttributes.displayName];
    updater.location = @"cloud";
    [updater setValue:updater.location forKey:JivePersonAttributes.displayName];
    [outcome setValue:@"outcome" forKey:JiveOutcomeTypeAttributes.jiveId];
    [outcome setValue:outcome.jiveId forKey:JiveOutcomeTypeAttributes.name];
    self.document.approvers = @[approver];
    self.document.attachments = @[attachment];
    self.document.authors = @[author];
    self.document.authorship = @"open";
    self.document.categories = @[category];
    [self.document setValue:editor forKey:JiveDocumentAttributes.editingBy];
    self.document.fromQuest = @"fromQuest";
    [self.document setValue:@[outcome] forKey:JiveDocumentAttributes.outcomeTypes];
    [self.document setValue:@{outcome.jiveId:outcomeCount} forKey:JiveDocumentAttributes.outcomeCounts];
    self.document.outcomeTypeNames = @[outcome.jiveId];
    self.document.restrictComments = @YES;
    self.document.tags = @[tag];
    [self.document setValue:updater forKey:JiveDocumentAttributes.updater];
    self.document.users = @[personURI];
    self.document.visibility = @"hidden";
    [self.document setValue:@YES forKey:JiveDocumentAttributes.visibleToExternalContributors];
    
    JSON = [self.document persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)17, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.authorship],
                         self.document.authorship, @"Wrong authorship");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.fromQuest],
                         self.document.fromQuest, @"Wrong fromQuest");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrict comments");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibility],
                         self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibleToExternalContributors],
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveDocumentAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.contentType],
                         attachment.contentType, @"Wrong value");
    STAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.size], attachment.size, @"Wrong size");
    
    NSArray *approversJSON = [JSON objectForKey:JiveDocumentAttributes.approvers];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    STAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([approverJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.location],
                         approver.location, @"Wrong value");
    STAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.displayName],
                         approver.displayName, @"Wrong display name");
    
    NSArray *authorsJSON = [JSON objectForKey:JiveDocumentAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    STAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([authorJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location], author.location, @"Wrong value");
    STAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.displayName],
                         author.displayName, @"Wrong display name");
    
    NSDictionary *editorJSON = [JSON objectForKey:JiveDocumentAttributes.editingBy];
    
    STAssertTrue([[editorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([editorJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([editorJSON objectForKey:JivePersonAttributes.location], editor.location,
                         @"Wrong value");
    STAssertEqualObjects([editorJSON objectForKey:JivePersonAttributes.displayName],
                         editor.displayName, @"Wrong display name");
    
    NSDictionary *updaterJSON = [JSON objectForKey:JiveDocumentAttributes.updater];
    
    STAssertTrue([[updaterJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([updaterJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([updaterJSON objectForKey:JivePersonAttributes.location], updater.location,
                         @"Wrong value");
    STAssertEqualObjects([updaterJSON objectForKey:JivePersonAttributes.displayName],
                         updater.displayName, @"Wrong display name");
    
    NSArray *usersJSON = [JSON objectForKey:JiveDocumentAttributes.users];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([usersJSON objectAtIndex:0], personURI, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveDocumentAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveDocumentAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveDocumentAttributes.outcomeTypeNames];
    
    STAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([outcomeTypeNamesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(outcomeTypeNamesJSON[0], outcome.jiveId, @"Wrong value");
    
    NSArray *outcomeTypesJSON = [JSON objectForKey:JiveDocumentAttributes.outcomeTypes];
    NSDictionary *outcomeJSON = [outcomeTypesJSON objectAtIndex:0];
    
    STAssertTrue([[outcomeTypesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([outcomeTypesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([outcomeJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(outcomeJSON[@"id"], outcome.jiveId, @"Wrong value");
    STAssertEqualObjects(outcomeJSON[JiveOutcomeTypeAttributes.name], outcome.name, @"Wrong value");
    
    NSDictionary *outcomeCountsJSON = [JSON objectForKey:JiveDocumentAttributes.outcomeCounts];
    
    STAssertTrue([[outcomeCountsJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([outcomeTypesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(outcomeCountsJSON[outcome.jiveId], outcomeCount, @"Wrong value");
}

- (void)testDocumentPersistentJSON_alternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *editor = [JivePerson new];
    JivePerson *user = [[JivePerson alloc] init];
    JivePerson *updater = [JivePerson new];
    JiveOutcomeType *outcome = [JiveOutcomeType new];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    NSNumber *outcomeCount = @5;
    
    attachment.contentType = @"place";
    [attachment setValue:@938272 forKey:JiveAttachmentAttributes.size];
    approver.location = @"Restaurant";
    [approver setValue:approver.location forKey:JivePersonAttributes.displayName];
    author.location = @"Subway";
    [author setValue:author.location forKey:JivePersonAttributes.displayName];
    editor.location = @"Elevator";
    [editor setValue:editor.location forKey:JivePersonAttributes.displayName];
    user.location = @"Theater";
    [user setValue:user.location forKey:JivePersonAttributes.displayName];
    updater.location = @"Taxi";
    [updater setValue:updater.location forKey:JivePersonAttributes.displayName];
    [outcome setValue:@"Hotel" forKey:JiveOutcomeTypeAttributes.jiveId];
    [outcome setValue:outcome.jiveId forKey:JiveOutcomeTypeAttributes.name];
    self.document.approvers = @[approver];
    self.document.attachments = @[attachment];
    self.document.authors = @[author];
    self.document.authorship = @"limited";
    self.document.categories = @[category];
    [self.document setValue:editor forKey:JiveDocumentAttributes.editingBy];
    self.document.fromQuest = @"toAnyone";
    [self.document setValue:@[outcome] forKey:JiveDocumentAttributes.outcomeTypes];
    [self.document setValue:@{outcome.jiveId:outcomeCount} forKey:JiveDocumentAttributes.outcomeCounts];
    self.document.outcomeTypeNames = @[outcome.jiveId];
    self.document.tags = @[tag];
    [self.document setValue:updater forKey:JiveDocumentAttributes.updater];
    self.document.users = @[user];
    self.document.visibility = @"people";
    
    NSDictionary *JSON = [self.document persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)15, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.document.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.authorship],
                         self.document.authorship, @"Wrong authorship");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.fromQuest],
                         self.document.fromQuest, @"Wrong fromQuest");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrict comments");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.visibility],
                         self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:JiveDocumentAttributes.restrictComments],
                         self.document.restrictComments, @"Wrong restrictComments");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveDocumentAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.contentType],
                         attachment.contentType, @"Wrong value");
    STAssertEqualObjects([itemJSON objectForKey:JiveAttachmentAttributes.size], attachment.size, @"Wrong size");
    
    NSArray *approversJSON = [JSON objectForKey:JiveDocumentAttributes.approvers];
    NSDictionary *approverJSON = [approversJSON objectAtIndex:0];
    
    STAssertTrue([[approversJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([approversJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([approverJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.location],
                         approver.location, @"Wrong value");
    STAssertEqualObjects([approverJSON objectForKey:JivePersonAttributes.displayName],
                         approver.displayName, @"Wrong display name");
    
    NSArray *authorsJSON = [JSON objectForKey:JiveDocumentAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    STAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([authorJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location], author.location,
                         @"Wrong value");
    STAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.displayName],
                         author.displayName, @"Wrong display name");
    
    NSDictionary *editorJSON = [JSON objectForKey:JiveDocumentAttributes.editingBy];
    
    STAssertTrue([[editorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([editorJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([editorJSON objectForKey:JivePersonAttributes.location], editor.location,
                         @"Wrong value");
    STAssertEqualObjects([editorJSON objectForKey:JivePersonAttributes.displayName],
                         editor.displayName, @"Wrong display name");
    
    NSDictionary *updaterJSON = [JSON objectForKey:JiveDocumentAttributes.updater];
    
    STAssertTrue([[updaterJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([updaterJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([updaterJSON objectForKey:JivePersonAttributes.location], updater.location,
                         @"Wrong value");
    STAssertEqualObjects([updaterJSON objectForKey:JivePersonAttributes.displayName],
                         updater.displayName, @"Wrong display name");
    
    NSArray *usersJSON = [JSON objectForKey:JiveDocumentAttributes.users];
    NSDictionary *userJSON = [usersJSON objectAtIndex:0];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([userJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([userJSON objectForKey:JivePersonAttributes.location], user.location, @"Wrong value");
    STAssertEqualObjects([userJSON objectForKey:JivePersonAttributes.displayName],
                         user.displayName, @"Wrong display name");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveDocumentAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveDocumentAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveDocumentAttributes.outcomeTypeNames];
    
    STAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([outcomeTypeNamesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(outcomeTypeNamesJSON[0], outcome.jiveId, @"Wrong value");
    
    NSArray *outcomeTypesJSON = [JSON objectForKey:JiveDocumentAttributes.outcomeTypes];
    NSDictionary *outcomeJSON = [outcomeTypesJSON objectAtIndex:0];
    
    STAssertTrue([[outcomeTypesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([outcomeTypesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([outcomeJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(outcomeJSON[@"id"], outcome.jiveId, @"Wrong value");
    STAssertEqualObjects(outcomeJSON[JiveOutcomeTypeAttributes.name], outcome.name, @"Wrong value");
    
    NSDictionary *outcomeCountsJSON = [JSON objectForKey:JiveDocumentAttributes.outcomeCounts];
    
    STAssertTrue([[outcomeCountsJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([outcomeTypesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(outcomeCountsJSON[outcome.jiveId], outcomeCount, @"Wrong value");
}

- (void)testDocumentParsing {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *editor = [JivePerson new];
    JivePerson *updater = [JivePerson new];
    JiveOutcomeType *outcome = [JiveOutcomeType new];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *personURI = @"/person/1234";
    NSNumber *outcomeCount = @1;
    
    attachment.contentType = @"person";
    approver.location = @"Tower";
    author.location = @"location";
    editor.location = @"Spire";
    updater.location = @"cloud";
    [outcome setValue:@"outcome" forKey:JiveOutcomeTypeAttributes.jiveId];
    self.document.approvers = @[approver];
    self.document.attachments = @[attachment];
    self.document.authors = @[author];
    self.document.authorship = @"open";
    self.document.categories = @[category];
    [self.document setValue:editor forKey:JiveDocumentAttributes.editingBy];
    self.document.fromQuest = @"fromQuest";
    [self.document setValue:@[outcome] forKey:JiveDocumentAttributes.outcomeTypes];
    [self.document setValue:@{outcome.jiveId: outcomeCount} forKey:JiveDocumentAttributes.outcomeCounts];
    self.document.outcomeTypeNames = @[outcome.jiveId];
    self.document.restrictComments = @YES;
    self.document.tags = @[tag];
    [self.document setValue:updater forKey:JiveDocumentAttributes.updater];
    self.document.users = @[personURI];
    self.document.visibility = @"hidden";
    [self.document setValue:@YES forKey:JiveDocumentAttributes.visibleToExternalContributors];
    
    id JSON = [self.document persistentJSON];
    JiveDocument *newContent = [JiveDocument objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.document class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.document.type, @"Wrong type");
    STAssertEquals([newContent.approvers count], [self.document.approvers count], @"Wrong number of approver objects");
    STAssertEquals([newContent.attachments count], [self.document.attachments count], @"Wrong number of attachment objects");
    STAssertEquals([newContent.authors count], [self.document.authors count], @"Wrong number of author objects");
    STAssertEqualObjects(newContent.authorship, self.document.authorship, @"Wrong authorship");
    STAssertEquals([newContent.categories count], [self.document.categories count], @"Wrong number of categories");
    STAssertEqualObjects(newContent.categories[0], category, @"Wrong category");
    STAssertEqualObjects(newContent.editingBy.location, editor.location, @"Wrong editor");
    STAssertEqualObjects(newContent.fromQuest, self.document.fromQuest, @"Wrong fromQuest");
    STAssertEquals(newContent.outcomeCounts.count, self.document.outcomeCounts.count, @"Wrong outcomeCounts count");
    STAssertEqualObjects(newContent.outcomeCounts[outcome.jiveId], outcomeCount, @"Wrong outcome count");
    STAssertEquals(newContent.outcomeTypeNames.count, self.document.outcomeTypeNames.count, @"Wrong outcomeTypeNames count");
    STAssertEqualObjects(newContent.outcomeTypeNames[0], outcome.jiveId, @"Wrong outcome name");
    STAssertEquals(newContent.outcomeTypes.count, self.document.outcomeTypes.count, @"Wrong outcomeTypes count");
    STAssertEquals(newContent.tags.count, self.document.tags.count, @"Wrong tags count");
    STAssertEqualObjects(newContent.tags[0], tag, @"Wrong tag");
    STAssertEqualObjects(newContent.updater.location, updater.location, @"Wrong updater");
    STAssertEquals([newContent.users count], [self.document.users count], @"Wrong number of user objects");
    STAssertEqualObjects(newContent.users[0], personURI, @"Wrong personURI");
    STAssertEqualObjects(newContent.visibility, self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors,
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");

    if ([newContent.approvers count] > 0) {
        id convertedObject = [newContent.approvers objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong approver object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], approver.location, @"Wrong approver object");
    }
    
    if ([newContent.attachments count] > 0) {
        id convertedObject = [newContent.attachments objectAtIndex:0];
        STAssertEquals([convertedObject class], [JiveAttachment class], @"Wrong attachment object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveAttachment class]])
            STAssertEqualObjects([(JiveAttachment *)convertedObject contentType],
                                 attachment.contentType, @"Wrong attachment object");
    }
    
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], author.location, @"Wrong author object");
    }
    
    if ([newContent.outcomeTypes count] > 0) {
        id convertedObject = newContent.outcomeTypes[0];
        STAssertEquals([convertedObject class], [JiveOutcomeType class], @"Wrong outcomeType object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveOutcomeType class]])
            STAssertEqualObjects([(JiveOutcomeType *)convertedObject jiveId], outcome.jiveId, @"Wrong outcome type");
    }
}

- (void)testDocumentParsingAlternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    JivePerson *approver = [[JivePerson alloc] init];
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *editor = [JivePerson new];
    JivePerson *user = [[JivePerson alloc] init];
    JivePerson *updater = [JivePerson new];
    JiveOutcomeType *outcome = [JiveOutcomeType new];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    NSNumber *outcomeCount = @5;
    
    attachment.contentType = @"place";
    approver.location = @"Restaurant";
    author.location = @"Subway";
    editor.location = @"Elevator";
    user.location = @"Theater";
    updater.location = @"Taxi";
    [outcome setValue:@"failed" forKey:JiveOutcomeTypeAttributes.jiveId];
    self.document.approvers = @[approver];
    self.document.attachments = @[attachment];
    self.document.authors = @[author];
    self.document.authorship = @"limited";
    self.document.categories = @[category];
    [self.document setValue:editor forKey:JiveDocumentAttributes.editingBy];
    self.document.fromQuest = @"toAnyone";
    [self.document setValue:@[outcome] forKey:JiveDocumentAttributes.outcomeTypes];
    [self.document setValue:@{outcome.jiveId: outcomeCount} forKey:JiveDocumentAttributes.outcomeCounts];
    self.document.outcomeTypeNames = @[outcome.jiveId];
    self.document.tags = @[tag];
    [self.document setValue:updater forKey:JiveDocumentAttributes.updater];
    self.document.users = @[user];
    self.document.visibility = @"people";
    
    id JSON = [self.document persistentJSON];
    JiveDocument *newContent = [JiveDocument objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.document class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.document.type, @"Wrong type");
    STAssertEquals([newContent.approvers count], [self.document.approvers count], @"Wrong number of approver objects");
    STAssertEquals([newContent.attachments count], [self.document.attachments count], @"Wrong number of attachment objects");
    STAssertEquals([newContent.authors count], [self.document.authors count], @"Wrong number of author objects");
    STAssertEqualObjects(newContent.authorship, self.document.authorship, @"Wrong authorship");
    STAssertEquals([newContent.categories count], [self.document.categories count], @"Wrong number of categories");
    STAssertEqualObjects(newContent.categories[0], category, @"Wrong category");
    STAssertEqualObjects(newContent.editingBy.location, editor.location, @"Wrong editor");
    STAssertEqualObjects(newContent.fromQuest, self.document.fromQuest, @"Wrong fromQuest");
    STAssertEquals(newContent.outcomeCounts.count, self.document.outcomeCounts.count, @"Wrong outcomeCounts count");
    STAssertEqualObjects(newContent.outcomeCounts[outcome.jiveId], outcomeCount, @"Wrong outcome count");
    STAssertEquals(newContent.outcomeTypeNames.count, self.document.outcomeTypeNames.count, @"Wrong outcomeTypeNames count");
    STAssertEqualObjects(newContent.outcomeTypeNames[0], outcome.jiveId, @"Wrong outcome name");
    STAssertEquals(newContent.outcomeTypes.count, self.document.outcomeTypes.count, @"Wrong outcomeTypes count");
    STAssertEquals(newContent.tags.count, self.document.tags.count, @"Wrong tags count");
    STAssertEqualObjects(newContent.tags[0], tag, @"Wrong tag");
    STAssertEqualObjects(newContent.updater.location, updater.location, @"Wrong updater");
    STAssertEquals([newContent.users count], [self.document.users count], @"Wrong number of user objects");
    STAssertEqualObjects(newContent.visibility, self.document.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors,
                         self.document.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");
    
    if ([newContent.approvers count] > 0) {
        id convertedObject = [newContent.approvers objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong approver object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], approver.location, @"Wrong approver object");
    }
    
    if ([newContent.attachments count] > 0) {
        id convertedObject = [newContent.attachments objectAtIndex:0];
        STAssertEquals([convertedObject class], [JiveAttachment class], @"Wrong attachment object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveAttachment class]])
            STAssertEqualObjects([(JiveAttachment *)convertedObject contentType],
                                 attachment.contentType, @"Wrong attachment object");
    }
    
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], author.location, @"Wrong author object");
    }
    
    if ([newContent.outcomeTypes count] > 0) {
        id convertedObject = newContent.outcomeTypes[0];
        STAssertEquals([convertedObject class], [JiveOutcomeType class], @"Wrong outcomeType object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveOutcomeType class]])
            STAssertEqualObjects([(JiveOutcomeType *)convertedObject jiveId], outcome.jiveId, @"Wrong outcome type");
    }
    
    if ([newContent.users count] > 0) {
        id convertedObject = [newContent.users objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong user object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject location], user.location, @"Wrong user object");
    }
}

@end
