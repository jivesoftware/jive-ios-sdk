//
//  JivePostTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePostTests.h"
#import "JiveAttachment.h"

@implementation JivePostTests

- (void)setUp {
    self.content = [[JivePost alloc] init];
}

- (JivePost *)poll {
    return (JivePost *)self.content;
}

- (void)testPostToJSON {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"post", @"Wrong type");
    
    attachment.contentType = @"person";
    self.poll.attachments = [NSArray arrayWithObject:attachment];
    self.poll.categories = [NSArray arrayWithObject:category];
    [self.poll setValue:@"permalink" forKey:@"permalink"];
    [self.poll setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"publishDate"];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.poll.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.poll.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"permalink"], self.poll.permalink, @"Wrong permalink");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEqualObjects([JSON objectForKey:@"publishDate"], @"1970-01-01T00:00:00.000+0000", @"Wrong publishDate");
    
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
    
    NSArray *categoriesJSON = [JSON objectForKey:@"categories"];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
}

- (void)testPostToJSON_alternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    
    attachment.contentType = @"place";
    self.poll.attachments = [NSArray arrayWithObject:attachment];
    self.poll.categories = [NSArray arrayWithObject:category];
    [self.poll setValue:@"http://dummy.com" forKey:@"permalink"];
    [self.poll setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"publishDate"];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.poll.restrictComments = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.poll.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"permalink"], self.poll.permalink, @"Wrong permalink");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEqualObjects([JSON objectForKey:@"publishDate"], @"1970-01-01T00:16:40.123+0000", @"Wrong publishDate");
    
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
    
    NSArray *categoriesJSON = [JSON objectForKey:@"categories"];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
}

- (void)testToJSON_attachments {
    JiveAttachment *attachment1 = [[JiveAttachment alloc] init];
    JiveAttachment *attachment2 = [[JiveAttachment alloc] init];
    
    attachment1.contentType = @"document";
    attachment2.contentType = @"question";
    [self.poll setValue:[NSArray arrayWithObject:attachment1] forKey:@"attachments"];
    
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.poll.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:@"attachments"];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    STAssertEqualObjects([object1 objectForKey:@"contentType"], attachment1.contentType, @"Wrong value");
    
    [self.poll setValue:[self.poll.attachments arrayByAddingObject:attachment2] forKey:@"attachments"];
    
    JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.poll.type, @"Wrong type");
    
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

- (void)testPostParsing {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    
    attachment.contentType = @"person";
    self.poll.attachments = [NSArray arrayWithObject:attachment];
    self.poll.categories = [NSArray arrayWithObject:category];
    [self.poll setValue:@"permalink" forKey:@"permalink"];
    [self.poll setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"publishDate"];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.poll.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.poll toJSONDictionary];
    JivePost *newContent = [JivePost instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.poll class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.poll.type, @"Wrong type");
    STAssertEqualObjects(newContent.permalink, self.poll.permalink, @"Wrong permalink");
    STAssertEqualObjects(newContent.publishDate, self.poll.publishDate, @"Wrong publishDate");
    STAssertEqualObjects(newContent.restrictComments, self.poll.restrictComments, @"Wrong restrictComments");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.poll.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.poll.categories count], @"Wrong number of categories");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.attachments count], [self.poll.attachments count], @"Wrong number of attachment objects");
    if ([newContent.attachments count] > 0) {
        id convertedObject = [newContent.attachments objectAtIndex:0];
        STAssertEquals([convertedObject class], [JiveAttachment class], @"Wrong attachment object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveAttachment class]])
            STAssertEqualObjects([(JiveAttachment *)convertedObject contentType], attachment.contentType, @"Wrong attachment object");
    }
}

- (void)testPostParsingAlternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    
    attachment.contentType = @"place";
    self.poll.attachments = [NSArray arrayWithObject:attachment];
    self.poll.categories = [NSArray arrayWithObject:category];
    [self.poll setValue:@"http://dummy.com" forKey:@"permalink"];
    [self.poll setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"publishDate"];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.poll.restrictComments = [NSNumber numberWithBool:YES];
    
    id JSON = [self.poll toJSONDictionary];
    JivePost *newContent = [JivePost instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.poll class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.poll.type, @"Wrong type");
    STAssertEqualObjects(newContent.permalink, self.poll.permalink, @"Wrong permalink");
    STAssertEqualObjects(newContent.publishDate, self.poll.publishDate, @"Wrong publishDate");
    STAssertEqualObjects(newContent.restrictComments, self.poll.restrictComments, @"Wrong restrictComments");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.poll.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.poll.categories count], @"Wrong number of categories");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.attachments count], [self.poll.attachments count], @"Wrong number of attachment objects");
    if ([newContent.attachments count] > 0) {
        id convertedObject = [newContent.attachments objectAtIndex:0];
        STAssertEquals([convertedObject class], [JiveAttachment class], @"Wrong attachment object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveAttachment class]])
            STAssertEqualObjects([(JiveAttachment *)convertedObject contentType], attachment.contentType, @"Wrong attachment object");
    }
}

@end
