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
    [super setUp];
    self.object = [[DummyContent alloc] init];
}

- (void)testContentEntityClass {
    
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

- (void)testContentToJSON {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    author.location = @"location";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.content.parent = @"parent";
    self.content.subject = @"Subject";
    [self.content setValue:@"1234" forKey:JiveContentAttributes.jiveId];
    [self.content setValue:author forKey:JiveContentAttributes.author];
    self.content.content = contentBody;
    [self.content setValue:parentContent forKey:JiveContentAttributes.parentContent];
    [self.content setValue:parentPlace forKey:JiveContentAttributes.parentPlace];
    [self.content setValue:[NSNumber numberWithInt:4] forKey:JiveContentAttributes.followerCount];
    [self.content setValue:@"body" forKey:JiveContentAttributes.highlightBody];
    [self.content setValue:@"subject" forKey:JiveContentAttributes.highlightSubject];
    [self.content setValue:@"tags" forKey:JiveContentAttributes.highlightTags];
    [self.content setValue:[NSNumber numberWithInt:12] forKey:JiveContentAttributes.likeCount];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveContentAttributes.published];
    [self.content setValue:[NSNumber numberWithInt:33] forKey:JiveContentAttributes.replyCount];
    [self.content setValue:@"status" forKey:JiveContentAttributes.status];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveContentAttributes.updated];
    [self.content setValue:[NSNumber numberWithInt:6] forKey:JiveContentAttributes.viewCount];
    
    JSON = [self.content toJSONDictionary];
    
    [self assertContentToJSON:JSON];
    
    NSArray *contentJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.content];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)contentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)contentJSON objectForKey:JiveTypedObjectAttributes.type], contentBody.type, @"Wrong value");
}

- (void)testContentToJSON_nilSubject {
    self.content.subject = nil;
    
    id JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    STAssertNil([(NSDictionary *)JSON objectForKey:JiveContentAttributes.subject], nil);
}

- (void)testContentToJSON_emptySubject {
    self.content.subject = @"";
    
    id JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertNil([(NSDictionary *)JSON objectForKey:JiveContentAttributes.subject], nil);
}

- (void)testContentToJSON_alternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    id JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    author.location = @"Tower";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    self.content.parent = @"William";
    self.content.subject = @"Writing";
    [self.content setValue:@"8743" forKey:JiveContentAttributes.jiveId];
    [self.content setValue:author forKey:JiveContentAttributes.author];
    self.content.content = contentBody;
    [self.content setValue:parentContent forKey:JiveContentAttributes.parentContent];
    [self.content setValue:parentPlace forKey:JiveContentAttributes.parentPlace];
    [self.content setValue:[NSNumber numberWithInt:7] forKey:JiveContentAttributes.followerCount];
    [self.content setValue:@"green" forKey:JiveContentAttributes.highlightBody];
    [self.content setValue:@"white" forKey:JiveContentAttributes.highlightSubject];
    [self.content setValue:@"blue" forKey:JiveContentAttributes.highlightTags];
    [self.content setValue:[NSNumber numberWithInt:4] forKey:JiveContentAttributes.likeCount];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveContentAttributes.published];
    [self.content setValue:[NSNumber numberWithInt:8] forKey:JiveContentAttributes.replyCount];
    [self.content setValue:@"upside down" forKey:JiveContentAttributes.status];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveContentAttributes.updated];
    [self.content setValue:[NSNumber numberWithInt:44] forKey:JiveContentAttributes.viewCount];
    
    JSON = [self.content toJSONDictionary];
    
    [self assertContentToJSON:JSON];
    
    NSArray *contentJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.content];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)contentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)contentJSON objectForKey:JiveTypedObjectAttributes.type], contentBody.type, @"Wrong value");
}

- (void)assertContentToJSON:(id)JSON {
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], self.content.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.parent], self.content.parent, @"Wrong parent");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.subject], self.content.subject, @"Wrong subject");
}


- (void)testContentPersistentJSON {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    id JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    author.location = @"location";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    [self.content setValue:author forKey:JiveContentAttributes.author];
    self.content.content = contentBody;
    [self.content setValue:@"internal id" forKey:JiveContentAttributes.contentID];
    [self.content setValue:@4 forKey:JiveContentAttributes.followerCount];
    [self.content setValue:@"body" forKey:JiveContentAttributes.highlightBody];
    [self.content setValue:@"subject" forKey:JiveContentAttributes.highlightSubject];
    [self.content setValue:@"tags" forKey:JiveContentAttributes.highlightTags];
    [self.content setValue:@"css stuff" forKey:JiveContentAttributes.iconCss];
    [self.content setValue:@"1234" forKey:JiveContentAttributes.jiveId];
    [self.content setValue:@12 forKey:JiveContentAttributes.likeCount];
    self.content.parent = @"parent";
    [self.content setValue:parentContent forKey:JiveContentAttributes.parentContent];
    [self.content setValue:parentPlace forKey:JiveContentAttributes.parentPlace];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0]
                    forKey:JiveContentAttributes.published];
    [self.content setValue:@33 forKey:JiveContentAttributes.replyCount];
    [self.content setValue:@"status" forKey:JiveContentAttributes.status];
    self.content.subject = @"Subject";
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                    forKey:JiveContentAttributes.updated];
    [self.content setValue:@6 forKey:JiveContentAttributes.viewCount];
    [self.content setValue:@"note" forKey:JiveContentAttributes.note];
    [self.content setValue:[NSURL URLWithString:@"http://dummy.com/root"]
                    forKey:JiveContentAttributes.root];
    
    JSON = [self.content persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)22, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.content.type, @"Wrong type");
    
    NSArray *authorJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.author];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)authorJSON objectForKey:JivePersonAttributes.location],
                         author.location, @"Wrong value");
    
    NSArray *contentJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.content];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)contentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)contentJSON objectForKey:JiveTypedObjectAttributes.type],
                         contentBody.type, @"Wrong value");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.contentID],
                         self.content.contentID, @"Wrong contentID");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.followerCount],
                         self.content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.highlightBody],
                         self.content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.highlightSubject],
                         self.content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.highlightTags],
                         self.content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.iconCss],
                         self.content.iconCss, @"Wrong iconCss");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], self.content.jiveId, @"Wrong id");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.likeCount],
                         self.content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.parent],
                         self.content.parent, @"Wrong parent");
    
    NSArray *parentContentJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.parentContent];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentContentJSON objectForKey:@"name"],
                         parentContent.name, @"Wrong value");
    
    NSArray *parentPlaceJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.parentPlace];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentPlaceJSON objectForKey:@"name"], parentPlace.name,
                         @"Wrong value");
    
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.published],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.replyCount],
                         self.content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.status],
                         self.content.status, @"Wrong status");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.subject],
                         self.content.subject, @"Wrong subject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.updated],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.viewCount],
                         self.content.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.note],
                         self.content.note, @"Wrong note");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.root],
                         self.content.root.absoluteString, @"Wrong root");
}

- (void)testContentPersistentJSON_alternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    id JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    author.location = @"Tower";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    [self.content setValue:author forKey:JiveContentAttributes.author];
    self.content.content = contentBody;
    [self.content setValue:@"bad juju" forKey:JiveContentAttributes.contentID];
    [self.content setValue:@7 forKey:JiveContentAttributes.followerCount];
    [self.content setValue:@"green" forKey:JiveContentAttributes.highlightBody];
    [self.content setValue:@"white" forKey:JiveContentAttributes.highlightSubject];
    [self.content setValue:@"blue" forKey:JiveContentAttributes.highlightTags];
    [self.content setValue:@"top : 5px" forKey:JiveContentAttributes.iconCss];
    [self.content setValue:@"8743" forKey:JiveContentAttributes.jiveId];
    [self.content setValue:@4 forKey:JiveContentAttributes.likeCount];
    self.content.parent = @"William";
    [self.content setValue:parentContent forKey:JiveContentAttributes.parentContent];
    [self.content setValue:parentPlace forKey:JiveContentAttributes.parentPlace];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                    forKey:JiveContentAttributes.published];
    [self.content setValue:@8 forKey:JiveContentAttributes.replyCount];
    [self.content setValue:@"upside down" forKey:JiveContentAttributes.status];
    self.content.subject = @"Writing";
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0]
                    forKey:JiveContentAttributes.updated];
    [self.content setValue:@44 forKey:JiveContentAttributes.viewCount];
    [self.content setValue:@"call home" forKey:JiveContentAttributes.note];
    [self.content setValue:[NSURL URLWithString:@"http://dummy.com/tree"]
                    forKey:JiveContentAttributes.root];
    
    JSON = [self.content persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)22, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.content.type, @"Wrong type");
    
    NSArray *authorJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.author];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)authorJSON objectForKey:JivePersonAttributes.location],
                         author.location, @"Wrong value");
    
    NSArray *contentJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.content];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)contentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)contentJSON objectForKey:JiveTypedObjectAttributes.type],
                         contentBody.type, @"Wrong value");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.contentID],
                         self.content.contentID, @"Wrong contentID");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.followerCount],
                         self.content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.highlightBody],
                         self.content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.highlightSubject],
                         self.content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.highlightTags],
                         self.content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.iconCss],
                         self.content.iconCss, @"Wrong iconCss");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], self.content.jiveId, @"Wrong id");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.likeCount],
                         self.content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.parent],
                         self.content.parent, @"Wrong parent");
    
    NSArray *parentContentJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.parentContent];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentContentJSON objectForKey:@"name"],
                         parentContent.name, @"Wrong value");
    
    NSArray *parentPlaceJSON = [(NSDictionary *)JSON objectForKey:JiveContentAttributes.parentPlace];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)parentPlaceJSON objectForKey:@"name"], parentPlace.name,
                         @"Wrong value");
    
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.published],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.replyCount],
                         self.content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.status],
                         self.content.status, @"Wrong status");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.subject],
                         self.content.subject, @"Wrong subject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.updated],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.viewCount],
                         self.content.viewCount, @"Wrong viewCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.note],
                         self.content.note, @"Wrong note");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:JiveContentAttributes.root],
                         self.content.root.absoluteString, @"Wrong root");
}

- (void)testContentParsing {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    author.location = @"location";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    [self.content setValue:author forKey:JiveContentAttributes.author];
    self.content.content = contentBody;
    [self.content setValue:@"internal id" forKey:JiveContentAttributes.contentID];
    [self.content setValue:@4 forKey:JiveContentAttributes.followerCount];
    [self.content setValue:@"body" forKey:JiveContentAttributes.highlightBody];
    [self.content setValue:@"subject" forKey:JiveContentAttributes.highlightSubject];
    [self.content setValue:@"tags" forKey:JiveContentAttributes.highlightTags];
    [self.content setValue:@"css stuff" forKey:JiveContentAttributes.iconCss];
    [self.content setValue:@"1234" forKey:JiveContentAttributes.jiveId];
    [self.content setValue:@12 forKey:JiveContentAttributes.likeCount];
    self.content.parent = @"parent";
    [self.content setValue:parentContent forKey:JiveContentAttributes.parentContent];
    [self.content setValue:parentPlace forKey:JiveContentAttributes.parentPlace];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0]
                    forKey:JiveContentAttributes.published];
    [self.content setValue:@33 forKey:JiveContentAttributes.replyCount];
    [self.content setValue:@"status" forKey:JiveContentAttributes.status];
    self.content.subject = @"Subject";
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                    forKey:JiveContentAttributes.updated];
    [self.content setValue:@6 forKey:JiveContentAttributes.viewCount];
    [self.content setValue:@"note" forKey:JiveContentAttributes.note];
    [self.content setValue:[NSURL URLWithString:@"http://dummy.com/root"]
                    forKey:JiveContentAttributes.root];
    
    id JSON = [self.content persistentJSON];
    JiveContent *newContent = [JiveContent objectFromJSON:JSON withInstance:self.instance];
    
    STAssertNotNil(newContent, @"Content object not created");
    STAssertTrue([[newContent class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
    STAssertEqualObjects(newContent.author.location, self.content.author.location, @"Wrong author.location");
    STAssertEqualObjects(newContent.content.type, self.content.content.type, @"Wrong content.type");
    STAssertEqualObjects(newContent.contentID, self.content.contentID, @"Wrong contentID");
    STAssertEqualObjects(newContent.followerCount, self.content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newContent.highlightBody, self.content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newContent.highlightSubject, self.content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newContent.highlightTags, self.content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newContent.iconCss, self.content.iconCss, @"Wrong iconCss");
    STAssertEqualObjects(newContent.jiveId, self.content.jiveId, @"Wrong id");
    STAssertEqualObjects(newContent.likeCount, self.content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newContent.parent, self.content.parent, @"Wrong parent");
    STAssertEqualObjects(newContent.parentContent.name, self.content.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newContent.parentPlace.name, self.content.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEqualObjects(newContent.published, self.content.published, @"Wrong published");
    STAssertEqualObjects(newContent.replyCount, self.content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newContent.status, self.content.status, @"Wrong status");
    STAssertEqualObjects(newContent.subject, self.content.subject, @"Wrong subject");
    STAssertEqualObjects(newContent.updated, self.content.updated, @"Wrong updated");
    STAssertEqualObjects(newContent.viewCount, self.content.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newContent.note, self.content.note, @"Wrong note");
    STAssertEqualObjects(newContent.root, self.content.root, @"Wrong root");
}

- (void)testContentParsingAlternate {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    author.location = @"Tower";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    [self.content setValue:author forKey:JiveContentAttributes.author];
    self.content.content = contentBody;
    [self.content setValue:@"bad juju" forKey:JiveContentAttributes.contentID];
    [self.content setValue:@7 forKey:JiveContentAttributes.followerCount];
    [self.content setValue:@"green" forKey:JiveContentAttributes.highlightBody];
    [self.content setValue:@"white" forKey:JiveContentAttributes.highlightSubject];
    [self.content setValue:@"blue" forKey:JiveContentAttributes.highlightTags];
    [self.content setValue:@"top : 5px" forKey:JiveContentAttributes.iconCss];
    [self.content setValue:@"8743" forKey:JiveContentAttributes.jiveId];
    [self.content setValue:@4 forKey:JiveContentAttributes.likeCount];
    self.content.parent = @"William";
    [self.content setValue:parentContent forKey:JiveContentAttributes.parentContent];
    [self.content setValue:parentPlace forKey:JiveContentAttributes.parentPlace];
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                    forKey:JiveContentAttributes.published];
    [self.content setValue:@8 forKey:JiveContentAttributes.replyCount];
    [self.content setValue:@"upside down" forKey:JiveContentAttributes.status];
    self.content.subject = @"Writing";
    [self.content setValue:[NSDate dateWithTimeIntervalSince1970:0]
                    forKey:JiveContentAttributes.updated];
    [self.content setValue:@44 forKey:JiveContentAttributes.viewCount];
    [self.content setValue:@"call home" forKey:JiveContentAttributes.note];
    [self.content setValue:[NSURL URLWithString:@"http://dummy.com/tree"]
                    forKey:JiveContentAttributes.root];
    
    id JSON = [self.content persistentJSON];
    JiveContent *newContent = [JiveContent objectFromJSON:JSON withInstance:self.instance];
    
    STAssertNotNil(newContent, @"Content object not created");
    STAssertTrue([[newContent class] isSubclassOfClass:[JiveContent class]], @"Wrong item class");
    STAssertEqualObjects(newContent.author.location, self.content.author.location, @"Wrong author.location");
    STAssertEqualObjects(newContent.content.type, self.content.content.type, @"Wrong content.type");
    STAssertEqualObjects(newContent.contentID, self.content.contentID, @"Wrong contentID");
    STAssertEqualObjects(newContent.followerCount, self.content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newContent.highlightBody, self.content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newContent.highlightSubject, self.content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newContent.highlightTags, self.content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newContent.iconCss, self.content.iconCss, @"Wrong iconCss");
    STAssertEqualObjects(newContent.jiveId, self.content.jiveId, @"Wrong id");
    STAssertEqualObjects(newContent.likeCount, self.content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newContent.parent, self.content.parent, @"Wrong parent");
    STAssertEqualObjects(newContent.parentContent.name, self.content.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newContent.parentPlace.name, self.content.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEqualObjects(newContent.published, self.content.published, @"Wrong published");
    STAssertEqualObjects(newContent.replyCount, self.content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newContent.status, self.content.status, @"Wrong status");
    STAssertEqualObjects(newContent.subject, self.content.subject, @"Wrong subject");
    STAssertEqualObjects(newContent.updated, self.content.updated, @"Wrong updated");
    STAssertEqualObjects(newContent.viewCount, self.content.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newContent.note, self.content.note, @"Wrong note");
    STAssertEqualObjects(newContent.root, self.content.root, @"Wrong root");
}

@end
