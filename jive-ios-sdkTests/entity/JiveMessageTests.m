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

@implementation JiveMessageTests

- (void)setUp {
    self.content = [[JiveMessage alloc] init];
}

- (JiveMessage *)message {
    return (JiveMessage *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.message.type, @"message", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.message.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.message class], @"Message class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.message class], @"Message class not registered with JiveContent.");
}

- (void)testAnnouncementToJSON {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"message", @"Wrong type");
    
    attachment.contentType = @"person";
    self.message.attachments = [NSArray arrayWithObject:attachment];
    [self.message setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.message setValue:@"/person/5432" forKey:@"discussion"];
    [self.message setValue:[NSNumber numberWithBool:YES] forKey:@"visibleToExternalContributors"];
    
    JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.message.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"discussion"], self.message.discussion, @"Wrong discussion");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.message.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *attachmentsJSON = [JSON objectForKey:@"attachments"];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"contentType"], attachment.contentType, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testAnnouncementToJSON_alternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *tag = @"concise";
    
    attachment.contentType = @"place";
    self.message.attachments = [NSArray arrayWithObject:attachment];
    [self.message setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.message setValue:@"/place/123456" forKey:@"discussion"];
    self.message.answer = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.message.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"discussion"], self.message.discussion, @"Wrong discussion");
    STAssertEqualObjects([JSON objectForKey:@"answer"], self.message.answer, @"Wrong answer");
    
    NSArray *attachmentsJSON = [JSON objectForKey:@"attachments"];
    NSDictionary *itemJSON = [attachmentsJSON objectAtIndex:0];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"contentType"], attachment.contentType, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testAnnouncementToJSON_helpful {
    self.message.helpful = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.message.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"helpful"], self.message.helpful, @"Wrong helpful");
}

- (void)testAnnouncementToJSON_boolProperties {
    self.message.answer = [NSNumber numberWithBool:YES];
    self.message.helpful = [NSNumber numberWithBool:YES];
    [self.message setValue:[NSNumber numberWithBool:YES] forKey:@"visibleToExternalContributors"];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.message.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"answer"], self.message.answer, @"Wrong answer");
    STAssertEqualObjects([JSON objectForKey:@"helpful"], self.message.helpful, @"Wrong helpful");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.message.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

- (void)testToJSON_attachments {
    JiveAttachment *attachment1 = [[JiveAttachment alloc] init];
    JiveAttachment *attachment2 = [[JiveAttachment alloc] init];
    
    attachment1.contentType = @"message";
    attachment2.contentType = @"question";
    [self.message setValue:[NSArray arrayWithObject:attachment1] forKey:@"attachments"];
    
    NSDictionary *JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.message.type, @"Wrong type");
    
    NSArray *addressJSON = [JSON objectForKey:@"attachments"];
    id object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    STAssertEqualObjects([object1 objectForKey:@"contentType"], attachment1.contentType, @"Wrong value");
    
    [self.message setValue:[self.message.attachments arrayByAddingObject:attachment2] forKey:@"attachments"];
    
    JSON = [self.message toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.message.type, @"Wrong type");
    
    addressJSON = [JSON objectForKey:@"attachments"];
    object1 = [addressJSON objectAtIndex:0];
    
    id object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"contentType"], attachment1.contentType, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"contentType"], attachment2.contentType, @"Wrong value 2");
}

- (void)testAnnouncementParsing {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *tag = @"wordy";
    
    attachment.contentType = @"person";
    self.message.attachments = [NSArray arrayWithObject:attachment];
    [self.message setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.message setValue:@"/person/5432" forKey:@"discussion"];
    self.message.answer = [NSNumber numberWithBool:YES];
    self.message.helpful = [NSNumber numberWithBool:YES];
    [self.message setValue:[NSNumber numberWithBool:YES] forKey:@"visibleToExternalContributors"];
    
    id JSON = [self.message toJSONDictionary];
    JiveMessage *newContent = [JiveMessage instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.message class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.message.type, @"Wrong type");
    STAssertEqualObjects(newContent.discussion, self.message.discussion, @"Wrong discussion");
    STAssertEquals([newContent.tags count], [self.message.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.attachments count], [self.message.attachments count], @"Wrong number of attachment objects");
    STAssertEqualObjects([(JiveAttachment *)[newContent.attachments objectAtIndex:0] contentType],
                         attachment.contentType,
                         @"Wrong attachment object");
    STAssertEqualObjects(newContent.answer, self.message.answer, @"Wrong answer");
    STAssertEqualObjects(newContent.helpful, self.message.helpful, @"Wrong helpful");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.message.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

- (void)testAnnouncementParsingAlternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *tag = @"concise";
    
    attachment.contentType = @"place";
    self.message.attachments = [NSArray arrayWithObject:attachment];
    [self.message setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.message setValue:@"/place/123456" forKey:@"discussion"];
    
    id JSON = [self.message toJSONDictionary];
    JiveMessage *newContent = [JiveMessage instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.message class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.message.type, @"Wrong type");
    STAssertEqualObjects(newContent.discussion, self.message.discussion, @"Wrong discussion");
    STAssertEquals([newContent.tags count], [self.message.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.attachments count], [self.message.attachments count], @"Wrong number of attachment objects");
    STAssertEqualObjects([(JiveAttachment *)[newContent.attachments objectAtIndex:0] contentType],
                         attachment.contentType,
                         @"Wrong attachment object");
}

@end
