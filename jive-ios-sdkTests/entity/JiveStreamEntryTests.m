//
//  JiveStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveStreamEntryTests.h"
#import "JiveResourceEntry.h"

@implementation JiveStreamEntryTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveStreamEntry alloc] init];
}

- (JiveStreamEntry *)stream {
    return (JiveStreamEntry *)self.object;
}

- (void)testToJSON {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.stream.type, @"Wrong type");
    
    author.location = @"location";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.stream.parent = @"parent";
    [self.stream setValue:@"Subject" forKey:@"subject"];
    [self.stream setValue:@"1234" forKey:@"jiveId"];
    [self.stream setValue:author forKey:@"author"];
    [self.stream setValue:contentBody forKey:@"content"];
    [self.stream setValue:parentContent forKey:@"parentContent"];
    [self.stream setValue:parentPlace forKey:@"parentPlace"];
    [self.stream setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [self.stream setValue:@"body" forKey:@"highlightBody"];
    [self.stream setValue:@"subject" forKey:@"highlightSubject"];
    [self.stream setValue:@"tags" forKey:@"highlightTags"];
    [self.stream setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.stream setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [self.stream setValue:@"status" forKey:@"status"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.stream setValue:@"verb" forKey:@"verb"];
    [self.stream setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    [self.stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.stream setValue:[NSNumber numberWithBool:YES] forKey:@"visibleToExternalContributors"];
    
    JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)19, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.stream.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.stream.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"parent"], self.stream.parent, @"Wrong parent");
    STAssertEqualObjects([JSON objectForKey:@"subject"], self.stream.subject, @"Wrong subject");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], self.stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], self.stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], self.stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], self.stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], self.stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"replyCount"], self.stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([JSON objectForKey:@"status"], self.stream.status, @"Wrong status");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], self.stream.viewCount, @"Wrong viewCount");
    
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
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.stream.type, @"Wrong type");
    
    author.location = @"Tower";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    self.stream.parent = @"William";
    [self.stream setValue:@"Writing" forKey:@"subject"];
    [self.stream setValue:@"8743" forKey:@"jiveId"];
    [self.stream setValue:author forKey:@"author"];
    [self.stream setValue:contentBody forKey:@"content"];
    [self.stream setValue:parentContent forKey:@"parentContent"];
    [self.stream setValue:parentPlace forKey:@"parentPlace"];
    [self.stream setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [self.stream setValue:@"green" forKey:@"highlightBody"];
    [self.stream setValue:@"white" forKey:@"highlightSubject"];
    [self.stream setValue:@"blue" forKey:@"highlightTags"];
    [self.stream setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.stream setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [self.stream setValue:@"upside down" forKey:@"status"];
    [self.stream setValue:@"noun" forKey:@"verb"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.stream setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    [self.stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)19, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.stream.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.stream.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"parent"], self.stream.parent, @"Wrong parent");
    STAssertEqualObjects([JSON objectForKey:@"subject"], self.stream.subject, @"Wrong subject");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], self.stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], self.stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], self.stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], self.stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], self.stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"replyCount"], self.stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([JSON objectForKey:@"status"], self.stream.status, @"Wrong status");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], self.stream.viewCount, @"Wrong viewCount");
    
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

- (void)testPersistentJSON {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.stream.type, @"Wrong type");
    
    author.location = @"location";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.stream.parent = @"parent";
    [self.stream setValue:@"Subject" forKey:@"subject"];
    [self.stream setValue:@"1234" forKey:@"jiveId"];
    [self.stream setValue:author forKey:@"author"];
    [self.stream setValue:contentBody forKey:@"content"];
    [self.stream setValue:parentContent forKey:@"parentContent"];
    [self.stream setValue:parentPlace forKey:@"parentPlace"];
    [self.stream setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [self.stream setValue:@"body" forKey:@"highlightBody"];
    [self.stream setValue:@"subject" forKey:@"highlightSubject"];
    [self.stream setValue:@"tags" forKey:@"highlightTags"];
    [self.stream setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.stream setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [self.stream setValue:@"status" forKey:@"status"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.stream setValue:@"verb" forKey:@"verb"];
    [self.stream setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    [self.stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.stream setValue:[NSNumber numberWithBool:YES] forKey:@"visibleToExternalContributors"];
    
    JSON = [self.stream persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)21, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.stream.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.stream.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"parent"], self.stream.parent, @"Wrong parent");
    STAssertEqualObjects([JSON objectForKey:@"subject"], self.stream.subject, @"Wrong subject");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], self.stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], self.stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], self.stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], self.stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], self.stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"replyCount"], self.stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([JSON objectForKey:@"status"], self.stream.status, @"Wrong status");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"verb"], self.stream.verb, @"Wrong verb");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], self.stream.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
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

- (void)testPersistentJSON_alternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *tag = @"concise";
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.stream.type, @"Wrong type");

    author.location = @"Tower";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    self.stream.parent = @"William";
    [self.stream setValue:@"Writing" forKey:@"subject"];
    [self.stream setValue:@"8743" forKey:@"jiveId"];
    [self.stream setValue:author forKey:@"author"];
    [self.stream setValue:contentBody forKey:@"content"];
    [self.stream setValue:parentContent forKey:@"parentContent"];
    [self.stream setValue:parentPlace forKey:@"parentPlace"];
    [self.stream setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [self.stream setValue:@"green" forKey:@"highlightBody"];
    [self.stream setValue:@"white" forKey:@"highlightSubject"];
    [self.stream setValue:@"blue" forKey:@"highlightTags"];
    [self.stream setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.stream setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [self.stream setValue:@"upside down" forKey:@"status"];
    [self.stream setValue:@"noun" forKey:@"verb"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.stream setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    [self.stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    JSON = [self.stream persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)20, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.stream.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.stream.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"parent"], self.stream.parent, @"Wrong parent");
    STAssertEqualObjects([JSON objectForKey:@"subject"], self.stream.subject, @"Wrong subject");
    STAssertEqualObjects([JSON objectForKey:@"followerCount"], self.stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([JSON objectForKey:@"highlightBody"], self.stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([JSON objectForKey:@"highlightSubject"], self.stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([JSON objectForKey:@"highlightTags"], self.stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([JSON objectForKey:@"likeCount"], self.stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"replyCount"], self.stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([JSON objectForKey:@"status"], self.stream.status, @"Wrong status");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"verb"], self.stream.verb, @"Wrong verb");
    STAssertEqualObjects([JSON objectForKey:@"viewCount"], self.stream.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
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
    
    author.location = @"location";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.stream.parent = @"parent";
    [self.stream setValue:@"Subject" forKey:@"subject"];
    [self.stream setValue:@"not a real type" forKey:@"type"];
    [self.stream setValue:@"1234" forKey:@"jiveId"];
    [self.stream setValue:author forKey:@"author"];
    [self.stream setValue:contentBody forKey:@"content"];
    [self.stream setValue:parentContent forKey:@"parentContent"];
    [self.stream setValue:parentPlace forKey:@"parentPlace"];
    [self.stream setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [self.stream setValue:@"body" forKey:@"highlightBody"];
    [self.stream setValue:@"subject" forKey:@"highlightSubject"];
    [self.stream setValue:@"tags" forKey:@"highlightTags"];
    [self.stream setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.stream setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [self.stream setValue:@"status" forKey:@"status"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"updated"];
    [self.stream setValue:@"verb" forKey:@"verb"];
    [self.stream setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    [self.stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.stream setValue:[NSNumber numberWithBool:YES] forKey:@"visibleToExternalContributors"];
    
    id JSON = [self.stream persistentJSON];
    JiveStreamEntry *newStream = [JiveStreamEntry objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.jiveId, self.stream.jiveId, @"Wrong id");
    STAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.parent, self.stream.parent, @"Wrong parent");
    STAssertEqualObjects(newStream.subject, self.stream.subject, @"Wrong subject");
    STAssertEqualObjects(newStream.followerCount, self.stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newStream.highlightBody, self.stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newStream.highlightSubject, self.stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newStream.highlightTags, self.stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newStream.likeCount, self.stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newStream.published, self.stream.published, @"Wrong published");
    STAssertEqualObjects(newStream.replyCount, self.stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newStream.status, self.stream.status, @"Wrong status");
    STAssertEqualObjects(newStream.updated, self.stream.updated, @"Wrong updated");
    STAssertEqualObjects(newStream.viewCount, self.stream.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newStream.author.location, self.stream.author.location, @"Wrong author.location");
    STAssertEqualObjects(newStream.content.type, self.stream.content.type, @"Wrong content.type");
    STAssertEqualObjects(newStream.parentContent.name, self.stream.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newStream.parentPlace.name, self.stream.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEqualObjects(newStream.verb, self.stream.verb, @"Wrong verb");
    STAssertEqualObjects(newStream.visibleToExternalContributors, self.stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newStream.tags count], [self.stream.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newStream.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testContentParsingAlternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *tag = @"concise";
    
    author.location = @"Tower";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    self.stream.parent = @"William";
    [self.stream setValue:@"Writing" forKey:@"subject"];
    [self.stream setValue:@"another non-type" forKey:@"type"];
    [self.stream setValue:@"8743" forKey:@"jiveId"];
    [self.stream setValue:author forKey:@"author"];
    [self.stream setValue:contentBody forKey:@"content"];
    [self.stream setValue:parentContent forKey:@"parentContent"];
    [self.stream setValue:parentPlace forKey:@"parentPlace"];
    [self.stream setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [self.stream setValue:@"green" forKey:@"highlightBody"];
    [self.stream setValue:@"white" forKey:@"highlightSubject"];
    [self.stream setValue:@"blue" forKey:@"highlightTags"];
    [self.stream setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"published"];
    [self.stream setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [self.stream setValue:@"upside down" forKey:@"status"];
    [self.stream setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.stream setValue:@"noun" forKey:@"verb"];
    [self.stream setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    [self.stream setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.stream persistentJSON];
    JiveStreamEntry *newStream = [JiveStreamEntry objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.jiveId, self.stream.jiveId, @"Wrong id");
    STAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.parent, self.stream.parent, @"Wrong parent");
    STAssertEqualObjects(newStream.subject, self.stream.subject, @"Wrong subject");
    STAssertEqualObjects(newStream.followerCount, self.stream.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newStream.highlightBody, self.stream.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newStream.highlightSubject, self.stream.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newStream.highlightTags, self.stream.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newStream.likeCount, self.stream.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newStream.published, self.stream.published, @"Wrong published");
    STAssertEqualObjects(newStream.replyCount, self.stream.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newStream.status, self.stream.status, @"Wrong status");
    STAssertEqualObjects(newStream.updated, self.stream.updated, @"Wrong updated");
    STAssertEqualObjects(newStream.viewCount, self.stream.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newStream.author.location, self.stream.author.location, @"Wrong author.location");
    STAssertEqualObjects(newStream.content.type, self.stream.content.type, @"Wrong content.type");
    STAssertEqualObjects(newStream.parentContent.name, self.stream.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newStream.parentPlace.name, self.stream.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEqualObjects(newStream.verb, self.stream.verb, @"Wrong verb");
    STAssertEqualObjects(newStream.visibleToExternalContributors, self.stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newStream.tags count], [self.stream.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newStream.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
