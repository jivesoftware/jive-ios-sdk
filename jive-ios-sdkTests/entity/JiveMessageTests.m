//
//  JiveMessageTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/27/12.
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

#import "JiveMessageTests.h"
#import "JiveAttachment.h"
#import "JiveOutcomeType.h"

@implementation JiveMessageTests

- (void)setUp {
    [super setUp];
    self.object = [JiveMessage new];
}

- (JiveMessage *)message {
    return (JiveMessage *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.message.type, @"message", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.message.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.message class], @"Message class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.message class], @"Message class not registered with JiveContent.");
}

- (void)testMessageToJSON {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.message toJSONDictionary];
    NSString *outcomeTypeName = @"helpful";
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], @"message", @"Wrong type");
    
    attachment.contentType = @"person";
    [outcomeType setValue:outcomeTypeName forKey:JiveOutcomeTypeAttributes.name];
    self.message.attachments = @[attachment];
    self.message.helpful = @YES;
    [self.message setValue:@[tag] forKey:JiveMessageAttributes.tags];
    [self.message setValue:@"/person/5432" forKey:JiveMessageAttributes.discussion];
    [self.message setValue:@YES forKey:JiveMessageAttributes.visibleToExternalContributors];
    self.message.outcomeTypeNames = @[outcomeTypeName];
    [self.message setValue:@[outcomeType] forKey:JiveMessageAttributes.outcomeTypes];
    
    JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.helpful], self.message.helpful,
                         @"Wrong helpful flag");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveMessageAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"contentType"],
                         attachment.contentType,
                         @"Wrong value");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveMessageAttributes.outcomeTypeNames];
    
    STAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"outcomeTypeNames not converted");
    STAssertEquals([outcomeTypeNamesJSON count], (NSUInteger)1, @"outcomeTypeNames dictionary had the wrong number of entries");
    STAssertEqualObjects([outcomeTypeNamesJSON objectAtIndex:0], outcomeTypeName, @"outcomeTypeNames value");
}

- (void)testMessageToJSON_alternate {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    NSString *tag = @"concise";
    NSString *outcomeTypeName = @"testType";
    
    attachment.contentType = @"place";
    [outcomeType setValue:outcomeTypeName forKey:JiveOutcomeTypeAttributes.name];
    self.message.attachments = @[attachment];
    [self.message setValue:@[tag] forKey:JiveMessageAttributes.tags];
    [self.message setValue:@"/place/123456" forKey:JiveMessageAttributes.discussion];
    self.message.answer = @YES;
    self.message.outcomeTypeNames = @[outcomeTypeName];
    [self.message setValue:@[outcomeType] forKey:JiveMessageAttributes.outcomeTypes];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type,
                         @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.answer], self.message.answer,
                         @"Wrong answer");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveMessageAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"contentType"], attachment.contentType, @"Wrong value");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveMessageAttributes.outcomeTypeNames];
    
    STAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"outcomeTypeNames not converted");
    STAssertEquals([outcomeTypeNamesJSON count], (NSUInteger)1, @"outcomeTypeNames dictionary had the wrong number of entries");
    STAssertEqualObjects([outcomeTypeNamesJSON objectAtIndex:0], outcomeTypeName, @"outcomeTypeNames value");
}

- (void)testMessagePersistentJSON {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.message persistentJSON];
    NSString *outcomeTypeName = @"helpful";
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], @"message", @"Wrong type");
    
    attachment.contentType = @"person";
    [outcomeType setValue:outcomeTypeName forKey:JiveOutcomeTypeAttributes.name];
    self.message.attachments = @[attachment];
    [self.message setValue:@[tag] forKey:JiveMessageAttributes.tags];
    [self.message setValue:@"/person/5432" forKey:JiveMessageAttributes.discussion];
    [self.message setValue:@YES forKey:JiveMessageAttributes.visibleToExternalContributors];
    self.message.outcomeTypeNames = @[outcomeTypeName];
    [self.message setValue:@[outcomeType] forKey:JiveMessageAttributes.outcomeTypes];
    
    JSON = [self.message persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.discussion],
                         self.message.discussion, @"Wrong discussion");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.visibleToExternalContributors],
                         self.message.visibleToExternalContributors,
                         @"Wrong visibleToExternalContributors");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveMessageAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"contentType"],
                         attachment.contentType,
                         @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveMessageAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveMessageAttributes.outcomeTypeNames];
    
    STAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"outcomeTypeNames not converted");
    STAssertEquals([outcomeTypeNamesJSON count], (NSUInteger)1, @"outcomeTypeNames dictionary had the wrong number of entries");
    STAssertEqualObjects([outcomeTypeNamesJSON objectAtIndex:0], outcomeTypeName, @"outcomeTypeNames value");
    
    NSArray *outcomeTypesJSON = [JSON objectForKey:JiveMessageAttributes.outcomeTypes];
    NSDictionary *outcomeTypeJSON = outcomeTypesJSON[0];
    
    STAssertTrue([[outcomeTypesJSON class] isSubclassOfClass:[NSArray class]], @"outcomeTypes not converted");
    STAssertEquals([outcomeTypesJSON count], (NSUInteger)1, @"outcomeTypes dictionary had the wrong number of entries");
    STAssertEqualObjects([outcomeTypeJSON objectForKey:JiveOutcomeTypeAttributes.name],
                         outcomeTypeName, @"outcomeTypeJSON name value");
}

- (void)testMessagePersistentJSON_alternate {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    NSString *tag = @"concise";
    NSString *outcomeTypeName = @"testType";
    
    attachment.contentType = @"place";
    [outcomeType setValue:outcomeTypeName forKey:JiveOutcomeTypeAttributes.name];
    self.message.attachments = @[attachment];
    [self.message setValue:@[tag] forKey:JiveMessageAttributes.tags];
    [self.message setValue:@"/place/123456" forKey:JiveMessageAttributes.discussion];
    self.message.answer = @YES;
    self.message.outcomeTypeNames = @[outcomeTypeName];
    [self.message setValue:@[outcomeType] forKey:JiveMessageAttributes.outcomeTypes];
    
    NSDictionary *JSON = [self.message persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type,
                         @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.discussion],
                         self.message.discussion, @"Wrong discussion");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.answer], self.message.answer,
                         @"Wrong answer");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveMessageAttributes.attachments];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"contentType"], attachment.contentType, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveMessageAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveMessageAttributes.outcomeTypeNames];
    
    STAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"outcomeTypeNames not converted");
    STAssertEquals([outcomeTypeNamesJSON count], (NSUInteger)1, @"outcomeTypeNames dictionary had the wrong number of entries");
    STAssertEqualObjects([outcomeTypeNamesJSON objectAtIndex:0], outcomeTypeName, @"Wrong outcomeTypeNames");
    
    NSArray *outcomeTypesJSON = [JSON objectForKey:JiveMessageAttributes.outcomeTypes];
    NSDictionary *outcomeTypeJSON = outcomeTypesJSON[0];
    
    STAssertTrue([[outcomeTypesJSON class] isSubclassOfClass:[NSArray class]], @"outcomeTypes not converted");
    STAssertEquals([outcomeTypesJSON count], (NSUInteger)1, @"outcomeTypes dictionary had the wrong number of entries");
    STAssertEqualObjects([outcomeTypeJSON objectForKey:JiveOutcomeTypeAttributes.name],
                         outcomeTypeName, @"outcomeTypeJSON name value");
}

- (void)testMessageToJSON_helpful {
    self.message.helpful = @YES;
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type,
                         @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.helpful], self.message.helpful,
                         @"Wrong helpful");
}

- (void)testMessageToJSON_boolProperties {
    self.message.answer = @YES;
    self.message.helpful = @YES;
    [self.message setValue:@YES forKey:JiveMessageAttributes.visibleToExternalContributors];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type,
                         @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.answer], self.message.answer,
                         @"Wrong answer");
    STAssertEqualObjects([JSON objectForKey:JiveMessageAttributes.helpful], self.message.helpful,
                         @"Wrong helpful");
}

- (void)testToJSON_attachments {
    JiveAttachment *attachment1 = [JiveAttachment new];
    JiveAttachment *attachment2 = [JiveAttachment new];
    
    attachment1.contentType = @"message";
    attachment2.contentType = @"question";
    [self.message setValue:@[attachment1] forKey:JiveMessageAttributes.attachments];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    
    NSArray *addressJSON = [JSON objectForKey:JiveMessageAttributes.attachments];
    id object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    STAssertEqualObjects([object1 objectForKey:@"contentType"], attachment1.contentType, @"Wrong value");
    
    [self.message setValue:[self.message.attachments arrayByAddingObject:attachment2]
                    forKey:JiveMessageAttributes.attachments];
    
    JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type,
                         @"Wrong type");
    
    addressJSON = [JSON objectForKey:JiveMessageAttributes.attachments];
    object1 = [addressJSON objectAtIndex:0];
    
    id object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"contentType"], attachment1.contentType, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"contentType"], attachment2.contentType, @"Wrong value 2");
}

- (void)testToJSON_outcomeTypes {
    JiveOutcomeType *outcomeType1 = [JiveOutcomeType new];
    JiveOutcomeType *outcomeType2 = [JiveOutcomeType new];
    
    [outcomeType1 setValue:@"message" forKey:JiveOutcomeTypeAttributes.name];
    [outcomeType2 setValue:@"question" forKey:JiveOutcomeTypeAttributes.name];
    [self.message setValue:@[outcomeType1] forKey:JiveMessageAttributes.outcomeTypes];
    
    NSDictionary *JSON = [self.message persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type, @"Wrong type");
    
    NSArray *outcomeTypeJSON = [JSON objectForKey:JiveMessageAttributes.outcomeTypes];
    id object1 = [outcomeTypeJSON objectAtIndex:0];
    
    STAssertTrue([[outcomeTypeJSON class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([outcomeTypeJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    STAssertEqualObjects([object1 objectForKey:JiveOutcomeTypeAttributes.name], outcomeType1.name,
                         @"Wrong value");
    
    [self.message setValue:[self.message.outcomeTypes arrayByAddingObject:outcomeType2]
                    forKey:JiveMessageAttributes.outcomeTypes];
    
    JSON = [self.message persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.message.type,
                         @"Wrong type");
    
    outcomeTypeJSON = [JSON objectForKey:JiveMessageAttributes.outcomeTypes];
    object1 = [outcomeTypeJSON objectAtIndex:0];
    
    id object2 = [outcomeTypeJSON objectAtIndex:1];
    
    STAssertTrue([[outcomeTypeJSON class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([outcomeTypeJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:JiveOutcomeTypeAttributes.name], outcomeType1.name,
                         @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:JiveOutcomeTypeAttributes.name], outcomeType2.name,
                         @"Wrong value 2");
}

- (void)testMessageParsing {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    NSString *tag = @"wordy";
    NSString *outcomeTypeName = @"helpful";
    
    attachment.contentType = @"person";
    [outcomeType setValue:outcomeTypeName forKey:JiveOutcomeTypeAttributes.name];
    self.message.attachments = @[attachment];
    [self.message setValue:@[tag] forKey:JiveMessageAttributes.tags];
    [self.message setValue:@"/person/5432" forKey:JiveMessageAttributes.discussion];
    self.message.answer = @YES;
    self.message.helpful = @YES;
    [self.message setValue:@YES forKey:JiveMessageAttributes.visibleToExternalContributors];
    [self.message setValue:@[outcomeTypeName] forKey:JiveMessageAttributes.outcomeTypeNames];
    [self.message setValue:@[outcomeType] forKey:JiveMessageAttributes.outcomeTypes];
   
    id JSON = [self.message persistentJSON];
    JiveMessage *newContent = [JiveMessage objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.message class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.message.type, @"Wrong type");
    STAssertEqualObjects(newContent.discussion, self.message.discussion, @"Wrong discussion");
    STAssertEquals([newContent.tags count], [self.message.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.outcomeTypeNames count], (NSUInteger)1, @"outcomeTypeNames dictionary had the wrong number of entries");
    STAssertEqualObjects([newContent.outcomeTypeNames objectAtIndex:0], outcomeTypeName, @"Wrong outcomeTypeName");
    STAssertEquals([newContent.attachments count], [self.message.attachments count], @"Wrong number of attachment objects");
    STAssertEqualObjects([(JiveAttachment *)[newContent.attachments objectAtIndex:0] contentType],
                         attachment.contentType,
                         @"Wrong attachment object");
    STAssertEqualObjects(newContent.answer, self.message.answer, @"Wrong answer");
    STAssertEqualObjects(newContent.helpful, self.message.helpful, @"Wrong helpful");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.message.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.outcomeTypes count], (NSUInteger)1,
                   @"outcomeTypes dictionary had the wrong number of entries");
    STAssertEqualObjects(((JiveOutcomeType *)[newContent.outcomeTypes objectAtIndex:0]).name,
                         outcomeTypeName, @"Wrong outcomeType");
}

- (void)testMessageParsingAlternate {
    JiveAttachment *attachment = [JiveAttachment new];
    JiveOutcomeType *outcomeType = [JiveOutcomeType new];
    NSString *tag = @"concise";
    NSString *outcomeTypeName = @"testType";
    
    attachment.contentType = @"place";
    [outcomeType setValue:outcomeTypeName forKey:JiveOutcomeTypeAttributes.name];
    self.message.attachments = @[attachment];
    [self.message setValue:@[tag] forKey:JiveMessageAttributes.tags];
    [self.message setValue:@"/place/123456" forKey:JiveMessageAttributes.discussion];
    [self.message setValue:@[outcomeTypeName] forKey:JiveMessageAttributes.outcomeTypeNames];
    [self.message setValue:@[outcomeType] forKey:JiveMessageAttributes.outcomeTypes];
    
    id JSON = [self.message persistentJSON];
    JiveMessage *newContent = [JiveMessage objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.message class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.message.type, @"Wrong type");
    STAssertEqualObjects(newContent.discussion, self.message.discussion, @"Wrong discussion");
    STAssertEquals([newContent.tags count], [self.message.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.outcomeTypeNames count], (NSUInteger)1, @"outcomeTypeNames dictionary had the wrong number of entries");
    STAssertEqualObjects([newContent.outcomeTypeNames objectAtIndex:0], outcomeTypeName, @"Wrong outcomeTypeName");
    STAssertEquals([newContent.attachments count], [self.message.attachments count], @"Wrong number of attachment objects");
    STAssertEqualObjects([(JiveAttachment *)[newContent.attachments objectAtIndex:0] contentType],
                         attachment.contentType,
                         @"Wrong attachment object");
    STAssertEquals([newContent.outcomeTypes count], (NSUInteger)1,
                   @"outcomeTypes dictionary had the wrong number of entries");
    STAssertEqualObjects(((JiveOutcomeType *)[newContent.outcomeTypes objectAtIndex:0]).name,
                         outcomeTypeName, @"Wrong outcomeType");
}

@end
