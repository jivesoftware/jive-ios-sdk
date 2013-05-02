//
//  JiveShareTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveShareTests.h"

@implementation JiveShareTests

- (void)setUp {
    self.content = [[JiveShare alloc] init];
}

- (JiveShare *)share {
    return (JiveShare *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.share.type, @"share", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.share.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.share class], @"Share class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.share class], @"Share class not registered with JiveContent.");
}

- (void)testShareToJSON {
    NSString *tag = @"wordy";
    JivePerson *participant = [JivePerson new];
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    NSDictionary *JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"share", @"Wrong type");
    
    participant.status = @"Doing fine";
    sharedPlace.description = @"Going places";
    sharedContent.subject = @"What to do when you get there.";
    [self.share setValue:[NSArray arrayWithObject:participant] forKey:JiveShareAttributes.participants];
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    [self.share setValue:[NSArray arrayWithObject:tag] forKey:JiveShareAttributes.tags];
    [self.share setValue:[NSNumber numberWithBool:YES] forKey:JiveShareAttributes.visibleToExternalContributors];
    
    JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.share.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveShareAttributes.visibleToExternalContributors], self.share.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *participantsJSON = [JSON objectForKey:JiveShareAttributes.participants];
    NSDictionary *itemJSON = [participantsJSON objectAtIndex:0];
    
    STAssertTrue([[participantsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([participantsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"type"], participant.type, @"Wrong value");
    STAssertEqualObjects([itemJSON objectForKey:@"status"], participant.status, @"Wrong value");
    
    itemJSON = [JSON objectForKey:JiveShareAttributes.sharedContent];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveContentAttributes.subject], sharedContent.subject, @"Wrong description");
    
    itemJSON = [JSON objectForKey:JiveShareAttributes.sharedPlace];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JivePlaceAttributes.description], sharedPlace.description, @"Wrong description");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testShareToJSON_alternate {
    NSString *tag = @"concise";
    JivePerson *participant = [JivePerson new];
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    
    participant.status = @"Twisting and Turning";
    sharedPlace.description = @"Rock solid";
    sharedContent.subject = @"What to do in Denver when you're dead.";
    [self.share setValue:[NSArray arrayWithObject:participant] forKey:JiveShareAttributes.participants];
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    [self.share setValue:[NSArray arrayWithObject:tag] forKey:JiveShareAttributes.tags];
    
    NSDictionary *JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.share.type, @"Wrong type");
    STAssertNil([JSON objectForKey:JiveShareAttributes.visibleToExternalContributors], @"Wrong visibleToExternalContributors");
    
    NSArray *participantsJSON = [JSON objectForKey:JiveShareAttributes.participants];
    NSDictionary *itemJSON = [participantsJSON objectAtIndex:0];
    
    STAssertTrue([[participantsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([participantsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([itemJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"type"], participant.type, @"Wrong value");
    STAssertEqualObjects([itemJSON objectForKey:@"status"], participant.status, @"Wrong value");
    
    itemJSON = [JSON objectForKey:JiveShareAttributes.sharedContent];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveContentAttributes.subject], sharedContent.subject, @"Wrong description");
    
    itemJSON = [JSON objectForKey:JiveShareAttributes.sharedPlace];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JivePlaceAttributes.description], sharedPlace.description, @"Wrong description");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testToJSON_attachments {
    JivePerson *participant1 = [JivePerson new];
    JivePerson *participant2 = [JivePerson new];
    
    participant1.status = @"document";
    participant2.status = @"question";
    [self.share setValue:[NSArray arrayWithObject:participant1] forKey:JiveShareAttributes.participants];
    
    NSDictionary *JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.share.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveShareAttributes.participants];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    STAssertEqualObjects([object1 objectForKey:@"status"], participant1.status, @"Wrong value");
    
    [self.share setValue:[self.share.participants arrayByAddingObject:participant2] forKey:JiveShareAttributes.participants];
    
    JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.share.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveShareAttributes.participants];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"status"], participant1.status, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"status"], participant2.status, @"Wrong value 2");
}

- (void)testShareParsing {
    JivePerson *participant = [JivePerson new];
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    NSString *tag = @"wordy";
    
    participant.status = @"Doing fine";
    sharedPlace.description = @"Going places";
    sharedContent.subject = @"What to do when you get there.";
    [self.share setValue:[NSArray arrayWithObject:participant] forKey:JiveShareAttributes.participants];
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    [self.share setValue:[NSArray arrayWithObject:tag] forKey:JiveShareAttributes.tags];
    [self.share setValue:[NSNumber numberWithBool:YES] forKey:JiveShareAttributes.visibleToExternalContributors];
    
    id JSON = [self.share toJSONDictionary];
    JiveShare *newContent = [JiveShare instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.share class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.share.type, @"Wrong type");
    STAssertEqualObjects(newContent.sharedContent.subject, self.share.sharedContent.subject, @"Wrong shared content");
    STAssertEqualObjects(newContent.sharedPlace.description, self.share.sharedPlace.description, @"Wrong shared place");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.share.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.share.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.participants count], [self.share.participants count], @"Wrong number of participant objects");
    if ([newContent.participants count] > 0) {
        id convertedObject = [newContent.participants objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong participant object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject status], participant.status, @"Wrong participant object");
    }
}

- (void)testShareParsingAlternate {
    JivePerson *participant = [JivePerson new];
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    NSString *tag = @"concise";
    
    participant.status = @"Twisting and Turning";
    sharedPlace.description = @"Rock solid";
    sharedContent.subject = @"What to do in Denver when you're dead.";
    [self.share setValue:[NSArray arrayWithObject:participant] forKey:JiveShareAttributes.participants];
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    [self.share setValue:[NSArray arrayWithObject:tag] forKey:JiveShareAttributes.tags];
    
    id JSON = [self.share toJSONDictionary];
    JiveShare *newContent = [JiveShare instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.share class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.share.type, @"Wrong type");
    STAssertEqualObjects(newContent.sharedContent.subject, self.share.sharedContent.subject, @"Wrong shared content");
    STAssertEqualObjects(newContent.sharedPlace.description, self.share.sharedPlace.description, @"Wrong shared place");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.share.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.share.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.participants count], [self.share.participants count], @"Wrong number of participant objects");
    if ([newContent.participants count] > 0) {
        id convertedObject = [newContent.participants objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong participant object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject status], participant.status, @"Wrong participant object");
    }
}

@end
