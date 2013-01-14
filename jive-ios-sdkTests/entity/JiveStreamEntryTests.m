//
//  JiveStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveStreamEntryTests.h"
#import "JiveResourceEntry.h"

@implementation JiveStreamEntryTests

@synthesize stream;

- (void)setUp {
    stream = [[JiveStreamEntry alloc] init];
}

- (void)tearDown {
    stream = nil;
}

- (void)testToJSON {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *tag = @"wordy";
    NSDictionary *JSON = [stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    author.location = @"author";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    stream.parent = @"parent";
    [stream setValue:@"Subject" forKey:@"subject"];
    [stream setValue:@"not a real type" forKey:@"type"];
    [stream setValue:@"1234" forKey:@"jiveId"];
    [stream setValue:author forKey:@"author"];
    [stream setValue:contentBody forKey:@"content"];
    [stream setValue:parentContent forKey:@"parentContent"];
    [stream setValue:parentPlace forKey:@"parentPlace"];
    [stream setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [stream setValue:@"body" forKey:@"highlightBody"];
    [stream setValue:@"subject" forKey:@"highlightSubject"];
    [stream setValue:@"tags" forKey:@"highlightTags"];
    [stream setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [stream setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [stream setValue:@"status" forKey:@"status"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [stream setValue:@"verb" forKey:@"verb"];
    [stream setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    [stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [stream setValue:[NSNumber numberWithBool:YES] forKey:@"visibleToExternalContributors"];
    
    JSON = [stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)21, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], stream.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"type"], stream.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"parent"], stream.parent, @"Wrong parent");
    STAssertEqualObjects([JSON objectForKey:@"subject"], stream.subject, @"Wrong subject");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"replyCount"], stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([JSON objectForKey:@"status"], stream.status, @"Wrong status");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"verb"], stream.verb, @"Wrong verb");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], stream.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSDictionary *authorJSON = [JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:@"location"], author.location, @"Wrong value");
    
    NSDictionary *contentJSON = [JSON objectForKey:@"content"];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([contentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([contentJSON objectForKey:@"type"], contentBody.type, @"Wrong value");
    
    NSDictionary *parentContentJSON = [JSON objectForKey:@"parentContent"];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong value");
    
    NSDictionary *parentPlaceJSON = [JSON objectForKey:@"parentPlace"];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testToJSON_alternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *tag = @"concise";
    NSDictionary *JSON = [stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    author.location = @"Gibson";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    stream.parent = @"William";
    [stream setValue:@"Writing" forKey:@"subject"];
    [stream setValue:@"another non-type" forKey:@"type"];
    [stream setValue:@"8743" forKey:@"jiveId"];
    [stream setValue:author forKey:@"author"];
    [stream setValue:contentBody forKey:@"content"];
    [stream setValue:parentContent forKey:@"parentContent"];
    [stream setValue:parentPlace forKey:@"parentPlace"];
    [stream setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [stream setValue:@"green" forKey:@"highlightBody"];
    [stream setValue:@"white" forKey:@"highlightSubject"];
    [stream setValue:@"blue" forKey:@"highlightTags"];
    [stream setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [stream setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [stream setValue:@"upside down" forKey:@"status"];
    [stream setValue:@"noun" forKey:@"verb"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [stream setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    [stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    JSON = [stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)20, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], stream.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"type"], stream.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"parent"], stream.parent, @"Wrong parent");
    STAssertEqualObjects([JSON objectForKey:@"subject"], stream.subject, @"Wrong subject");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"replyCount"], stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([JSON objectForKey:@"status"], stream.status, @"Wrong status");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"verb"], stream.verb, @"Wrong verb");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], stream.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSDictionary *authorJSON = [JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:@"location"], author.location, @"Wrong value");
    
    NSDictionary *contentJSON = [JSON objectForKey:@"content"];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([contentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([contentJSON objectForKey:@"type"], contentBody.type, @"Wrong value");
    
    NSDictionary *parentContentJSON = [JSON objectForKey:@"parentContent"];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong value");
    
    NSDictionary *parentPlaceJSON = [JSON objectForKey:@"parentPlace"];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testContentParsing {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *tag = @"wordy";
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    author.location = @"author";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    stream.parent = @"parent";
    [stream setValue:@"Subject" forKey:@"subject"];
    [stream setValue:@"not a real type" forKey:@"type"];
    [stream setValue:@"1234" forKey:@"jiveId"];
    [stream setValue:author forKey:@"author"];
    [stream setValue:contentBody forKey:@"content"];
    [stream setValue:parentContent forKey:@"parentContent"];
    [stream setValue:parentPlace forKey:@"parentPlace"];
    [stream setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [stream setValue:@"body" forKey:@"highlightBody"];
    [stream setValue:@"subject" forKey:@"highlightSubject"];
    [stream setValue:@"tags" forKey:@"highlightTags"];
    [stream setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [stream setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [stream setValue:@"status" forKey:@"status"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"updated"];
    [stream setValue:@"verb" forKey:@"verb"];
    [stream setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    [stream setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    [stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [stream setValue:[NSNumber numberWithBool:YES] forKey:@"visibleToExternalContributors"];
    
    id JSON = [stream toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStreamEntry *newStream = [JiveStreamEntry instanceFromJSON:JSON];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.jiveId, stream.jiveId, @"Wrong id");
    STAssertEqualObjects(newStream.type, stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.parent, stream.parent, @"Wrong parent");
    STAssertEqualObjects(newStream.subject, stream.subject, @"Wrong subject");
    STAssertEqualObjects(newStream.followerCount, stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newStream.highlightBody, stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newStream.highlightSubject, stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newStream.highlightTags, stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newStream.likeCount, stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newStream.published, stream.published, @"Wrong published");
    STAssertEqualObjects(newStream.replyCount, stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newStream.status, stream.status, @"Wrong status");
    STAssertEqualObjects(newStream.updated, stream.updated, @"Wrong updated");
    STAssertEqualObjects(newStream.viewCount, stream.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newStream.author.location, stream.author.location, @"Wrong author.location");
    STAssertEqualObjects(newStream.content.type, stream.content.type, @"Wrong content.type");
    STAssertEqualObjects(newStream.parentContent.name, stream.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newStream.parentPlace.name, stream.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEqualObjects(newStream.verb, stream.verb, @"Wrong verb");
    STAssertEqualObjects(newStream.visibleToExternalContributors, stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newStream.resources count], [stream.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
    STAssertEquals([newStream.tags count], [stream.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newStream.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testContentParsingAlternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *tag = @"concise";
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    author.location = @"Gibson";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    stream.parent = @"William";
    [stream setValue:@"Writing" forKey:@"subject"];
    [stream setValue:@"another non-type" forKey:@"type"];
    [stream setValue:@"8743" forKey:@"jiveId"];
    [stream setValue:author forKey:@"author"];
    [stream setValue:contentBody forKey:@"content"];
    [stream setValue:parentContent forKey:@"parentContent"];
    [stream setValue:parentPlace forKey:@"parentPlace"];
    [stream setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [stream setValue:@"green" forKey:@"highlightBody"];
    [stream setValue:@"white" forKey:@"highlightSubject"];
    [stream setValue:@"blue" forKey:@"highlightTags"];
    [stream setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"published"];
    [stream setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [stream setValue:@"upside down" forKey:@"status"];
    [stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [stream setValue:@"noun" forKey:@"verb"];
    [stream setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    [stream setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    [stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [stream toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveStreamEntry *newStream = [JiveStreamEntry instanceFromJSON:JSON];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.jiveId, stream.jiveId, @"Wrong id");
    STAssertEqualObjects(newStream.type, stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.parent, stream.parent, @"Wrong parent");
    STAssertEqualObjects(newStream.subject, stream.subject, @"Wrong subject");
    STAssertEqualObjects(newStream.followerCount, stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newStream.highlightBody, stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newStream.highlightSubject, stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newStream.highlightTags, stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newStream.likeCount, stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newStream.published, stream.published, @"Wrong published");
    STAssertEqualObjects(newStream.replyCount, stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newStream.status, stream.status, @"Wrong status");
    STAssertEqualObjects(newStream.updated, stream.updated, @"Wrong updated");
    STAssertEqualObjects(newStream.viewCount, stream.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newStream.author.location, stream.author.location, @"Wrong author.location");
    STAssertEqualObjects(newStream.content.type, stream.content.type, @"Wrong content.type");
    STAssertEqualObjects(newStream.parentContent.name, stream.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newStream.parentPlace.name, stream.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEqualObjects(newStream.verb, stream.verb, @"Wrong verb");
    STAssertEqualObjects(newStream.visibleToExternalContributors, stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newStream.resources count], [stream.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newStream.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
    STAssertEquals([newStream.tags count], [stream.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newStream.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
