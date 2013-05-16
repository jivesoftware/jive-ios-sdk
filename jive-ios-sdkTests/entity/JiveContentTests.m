//
//  JiveContentTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
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

#import "JiveContentTests.h"
#import "JiveAnnouncement.h"
#import "JiveMessage.h"
#import "JiveDocument.h"
#import "JiveFile.h"
#import "JivePoll.h"
#import "JivePost.h"
#import "JiveComment.h"
#import "JiveDirectMessage.h"
#import "JiveFavorite.h"
#import "JiveTask.h"
#import "JiveUpdate.h"
#import "JiveResourceEntry.h"

@interface DummyContent : JiveContent

@end

@implementation DummyContent

- (NSString *)type {
    return @"dummy";
}

@end

@implementation JiveContentTests

- (JiveContent *)content {
    return (JiveContent *)self.typedObject;
}

- (void)setUp {
    self.typedObject = [[DummyContent alloc] init];
}

- (void)testEntityClass {
    
    NSString *key = @"type";
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:@"random" forKey:key];
    SEL selector = @selector(entityClass:);
    
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveContent class], @"Out of bounds");
    
    [typeSpecifier setValue:@"announcement" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveAnnouncement class], @"Announcement");
    
    [typeSpecifier setValue:@"message" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveMessage class], @"Message");
    
    [typeSpecifier setValue:@"document" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveDocument class], @"Document");
    
    [typeSpecifier setValue:@"file" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveFile class], @"File");
    
    [typeSpecifier setValue:@"poll" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JivePoll class], @"Poll");
    
    [typeSpecifier setValue:@"post" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JivePost class], @"Post");
    
    [typeSpecifier setValue:@"comment" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveComment class], @"Comment");
    
    [typeSpecifier setValue:@"dm" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveDirectMessage class], @"Direct Message");
    
    [typeSpecifier setValue:@"favorite" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveFavorite class], @"Favorite");
    
    [typeSpecifier setValue:@"task" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveTask class], @"Task");
    
    [typeSpecifier setValue:@"update" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveUpdate class], @"Update");
    
    [typeSpecifier setValue:@"Not random" forKey:key];
    STAssertEqualObjects([JiveContent performSelector:selector withObject:typeSpecifier],
                         [JiveContent class], @"Different out of bounds");
}

- (void)testToJSON {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    id JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.content.type, @"Wrong type");

    author.location = @"location";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.content.parent = @"parent";
    self.content.subject = @"Subject";
    [self.content setValue:@"1234" forKey:@"jiveId"];
    [self.content setValue:author forKey:@"author"];
    self.content.content = contentBody;
    [self.content setValue:parentContent forKey:@"parentContent"];
    [self.content setValue:parentPlace forKey:@"parentPlace"];
    [self.content setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [self.content setValue:@"body" forKey:@"highlightBody"];
    [self.content setValue:@"subject" forKey:@"highlightSubject"];
    [self.content setValue:@"tags" forKey:@"highlightTags"];
    [self.content setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.content setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [self.content setValue:@"status" forKey:@"status"];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.content setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    
    JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)18, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], self.content.jiveId, @"Wrong id");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.content.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"parent"], self.content.parent, @"Wrong parent");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"subject"], self.content.subject, @"Wrong subject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followerCount"], self.content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightBody"], self.content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightSubject"], self.content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightTags"], self.content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"likeCount"], self.content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"replyCount"], self.content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"status"], self.content.status, @"Wrong status");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"viewCount"], self.content.viewCount, @"Wrong viewCount");
    
    NSArray *authorJSON = [(NSDictionary *)JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)authorJSON objectForKey:@"location"], author.location, @"Wrong value");
    
    NSArray *contentJSON = [(NSDictionary *)JSON objectForKey:@"content"];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)contentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)contentJSON objectForKey:@"type"], contentBody.type, @"Wrong value");
    
    NSArray *parentContentJSON = [(NSDictionary *)JSON objectForKey:@"parentContent"];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong value");
    
    NSArray *parentPlaceJSON = [(NSDictionary *)JSON objectForKey:@"parentPlace"];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong value");
}

- (void)testToJSON_alternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    id JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.content.type, @"Wrong type");

    author.location = @"Tower";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    self.content.parent = @"William";
    self.content.subject = @"Writing";
    [self.content setValue:@"8743" forKey:@"jiveId"];
    [self.content setValue:author forKey:@"author"];
    self.content.content = contentBody;
    [self.content setValue:parentContent forKey:@"parentContent"];
    [self.content setValue:parentPlace forKey:@"parentPlace"];
    [self.content setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [self.content setValue:@"green" forKey:@"highlightBody"];
    [self.content setValue:@"white" forKey:@"highlightSubject"];
    [self.content setValue:@"blue" forKey:@"highlightTags"];
    [self.content setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.content setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [self.content setValue:@"upside down" forKey:@"status"];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.content setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    
    JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)18, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], self.content.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.content.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"parent"], self.content.parent, @"Wrong parent");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"subject"], self.content.subject, @"Wrong subject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followerCount"], self.content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightBody"], self.content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightSubject"], self.content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightTags"], self.content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"likeCount"], self.content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"replyCount"], self.content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"status"], self.content.status, @"Wrong status");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"viewCount"], self.content.viewCount, @"Wrong viewCount");
    
    NSArray *authorJSON = [(NSDictionary *)JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)authorJSON objectForKey:@"location"], author.location, @"Wrong value");
    
    NSArray *contentJSON = [(NSDictionary *)JSON objectForKey:@"content"];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)contentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)contentJSON objectForKey:@"type"], contentBody.type, @"Wrong value");
    
    NSArray *parentContentJSON = [(NSDictionary *)JSON objectForKey:@"parentContent"];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong value");
    
    NSArray *parentPlaceJSON = [(NSDictionary *)JSON objectForKey:@"parentPlace"];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong value");
}

- (void)testContentParsing {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    author.location = @"location";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.content.parent = @"parent";
    self.content.subject = @"Subject";
    [self.content setValue:@"1234" forKey:@"jiveId"];
    [self.content setValue:author forKey:@"author"];
    self.content.content = contentBody;
    [self.content setValue:parentContent forKey:@"parentContent"];
    [self.content setValue:parentPlace forKey:@"parentPlace"];
    [self.content setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [self.content setValue:@"body" forKey:@"highlightBody"];
    [self.content setValue:@"subject" forKey:@"highlightSubject"];
    [self.content setValue:@"tags" forKey:@"highlightTags"];
    [self.content setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.content setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [self.content setValue:@"status" forKey:@"status"];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"updated"];
    [self.content setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    [self.content setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.content toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveContent *newContent = [JiveContent instanceFromJSON:JSON];
    
    STAssertNotNil(newContent, @"Content object not created");
    STAssertTrue([[newContent class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
    STAssertEqualObjects(newContent.jiveId, self.content.jiveId, @"Wrong id");
    STAssertEqualObjects(newContent.parent, self.content.parent, @"Wrong parent");
    STAssertEqualObjects(newContent.subject, self.content.subject, @"Wrong subject");
    STAssertEqualObjects(newContent.followerCount, self.content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newContent.highlightBody, self.content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newContent.highlightSubject, self.content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newContent.highlightTags, self.content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newContent.likeCount, self.content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newContent.published, self.content.published, @"Wrong published");
    STAssertEqualObjects(newContent.replyCount, self.content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newContent.status, self.content.status, @"Wrong status");
    STAssertEqualObjects(newContent.updated, self.content.updated, @"Wrong updated");
    STAssertEqualObjects(newContent.viewCount, self.content.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newContent.author.location, self.content.author.location, @"Wrong author.location");
    STAssertEqualObjects(newContent.content.type, self.content.content.type, @"Wrong content.type");
    STAssertEqualObjects(newContent.parentContent.name, self.content.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newContent.parentPlace.name, self.content.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEquals([newContent.resources count], [self.content.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newContent.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingAlternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    author.location = @"Tower";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    self.content.parent = @"William";
    self.content.subject = @"Writing";
    [self.content setValue:@"8743" forKey:@"jiveId"];
    [self.content setValue:author forKey:@"author"];
    self.content.content = contentBody;
    [self.content setValue:parentContent forKey:@"parentContent"];
    [self.content setValue:parentPlace forKey:@"parentPlace"];
    [self.content setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [self.content setValue:@"green" forKey:@"highlightBody"];
    [self.content setValue:@"white" forKey:@"highlightSubject"];
    [self.content setValue:@"blue" forKey:@"highlightTags"];
    [self.content setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"published"];
    [self.content setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [self.content setValue:@"upside down" forKey:@"status"];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.content setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    [self.content setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.content toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveContent *newContent = [JiveContent instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
    STAssertEqualObjects(newContent.jiveId, self.content.jiveId, @"Wrong id");
    STAssertEqualObjects(newContent.parent, self.content.parent, @"Wrong parent");
    STAssertEqualObjects(newContent.subject, self.content.subject, @"Wrong subject");
    STAssertEqualObjects(newContent.followerCount, self.content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newContent.highlightBody, self.content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newContent.highlightSubject, self.content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newContent.highlightTags, self.content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newContent.likeCount, self.content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newContent.published, self.content.published, @"Wrong published");
    STAssertEqualObjects(newContent.replyCount, self.content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newContent.status, self.content.status, @"Wrong status");
    STAssertEqualObjects(newContent.updated, self.content.updated, @"Wrong updated");
    STAssertEqualObjects(newContent.viewCount, self.content.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newContent.author.location, self.content.author.location, @"Wrong author.location");
    STAssertEqualObjects(newContent.content.type, self.content.content.type, @"Wrong content.type");
    STAssertEqualObjects(newContent.parentContent.name, self.content.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newContent.parentPlace.name, self.content.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEquals([newContent.resources count], [self.content.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newContent.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
