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
#import "JiveImage.h"
#import "JiveContentVideo.h"

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

- (void)initializeContentForTest {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    JiveImage *contentImage = [JiveImage new];
    JiveContentVideo *contentVideo = [JiveContentVideo new];
    
    [contentImage setValue:@"image id" forKey:JiveObjectAttributes.jiveId];
    author.location = @"location";
    [author setValue:@"display name" forKeyPath:JivePersonAttributes.displayName];
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    [contentVideo setValue:[NSURL URLWithString:@"http://dummy.com/test.png"]
                 forKey:JiveContentVideoAttributes.stillImageURL];
    self.content.parent = @"parent";
    self.content.subject = @"Subject";
    [self.content setValue:@"1234" forKey:JiveContentAttributes.jiveId];
    [self.content setValue:author forKey:JiveContentAttributes.author];
    self.content.content = contentBody;
    [self.content setValue:@"test id" forKey:JiveContentAttributes.contentID];
    [self.content setValue:@[contentImage] forKey:JiveContentAttributes.contentImages];
    [self.content setValue:@[contentVideo] forKey:JiveContentAttributes.contentVideos];
    [self.content setValue:parentContent forKey:JiveContentAttributes.parentContent];
    [self.content setValue:@YES forKeyPath:JiveContentAttributes.parentContentVisible];
    [self.content setValue:parentPlace forKey:JiveContentAttributes.parentPlace];
    [self.content setValue:@YES forKeyPath:JiveContentAttributes.parentVisible];
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
    self.content.tags = @[@"tag, you're it."];
    self.content.visibleToExternalContributors = @YES;
}

- (void)initializeAlternateContentForTest {
    JivePerson *author = [[JivePerson alloc] init];
    JiveContentBody *contentBody = [[JiveContentBody alloc] init];
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    JiveImage *contentImage = [JiveImage new];
    JiveContentVideo *contentVideo = [JiveContentVideo new];
    
    [contentImage setValue:@"12345" forKey:JiveObjectAttributes.jiveId];
    author.location = @"Tower";
    [author setValue:@"Rapunzel" forKeyPath:JivePersonAttributes.displayName];
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    [contentVideo setValue:[NSURL URLWithString:@"http://super.com/test.png"]
                 forKey:JiveContentVideoAttributes.stillImageURL];
    self.content.parent = @"William";
    self.content.subject = @"Writing";
    [self.content setValue:@"8743" forKey:JiveContentAttributes.jiveId];
    [self.content setValue:author forKey:JiveContentAttributes.author];
    self.content.content = contentBody;
    [self.content setValue:@"54321" forKey:JiveContentAttributes.contentID];
    [self.content setValue:@[contentImage] forKey:JiveContentAttributes.contentImages];
    [self.content setValue:@[contentVideo] forKey:JiveContentAttributes.contentVideos];
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
    self.content.tags = @[@"unlisted"];
}

- (void)testContentToJSON {
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    [self initializeContentForTest];
    
    JSON = [self.content toJSONDictionary];
    
    [self assertContentToJSON:JSON withItemCount:7 messageHeader:@"initial content"];
}

- (void)testContentToJSON_nilSubject {
    self.content.subject = nil;
    
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    STAssertNil(JSON[JiveContentAttributes.subject], nil);
}

- (void)testContentToJSON_emptySubject {
    self.content.subject = @"";
    
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertNil(JSON[JiveContentAttributes.subject], nil);
}

- (void)testContentToJSON_tags {
    NSString *tag1 = @"big";
    NSString *tag2 = @"stuff";
    
    self.content.tags = @[tag1];
    
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    NSArray *categoriesJSON = JSON[JiveContentAttributes.tags];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], tag1, @"Wrong value");
    
    self.content.tags = @[tag2, tag1];
    
    JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    categoriesJSON = JSON[JiveContentAttributes.tags];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], tag2, @"Wrong value");
    STAssertEqualObjects([categoriesJSON objectAtIndex:1], tag1, @"Wrong value");
}

- (void)testContentToJSON_incomplete_status {
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    [self initializeAlternateContentForTest];
    [self.content setValue:@"incomplete" forKey:JiveContentAttributes.status];
    
    JSON = [self.content toJSONDictionary];
    
    STAssertEquals(JSON[JiveContentAttributes.status], JiveContentStatusValues.incomplete, @"Status should be incomplete");
}

- (void)testContentToJSON_alternate {
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    [self initializeAlternateContentForTest];
    
    JSON = [self.content toJSONDictionary];
    
    [self assertContentToJSON:JSON withItemCount:6 messageHeader:@"alternate content"];
}

- (void)assertCommonContentToJSON:(NSDictionary *)JSON
                    withItemCount:(NSUInteger)expectedCount
                    messageHeader:(NSString *)message {
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]],
                 @"%@: Generated JSON has the wrong class", message);
    STAssertEquals([JSON count], expectedCount,
                   @"%@: Initial dictionary had the wrong number of entries", message);
    STAssertEqualObjects(JSON[JiveObjectConstants.id], self.content.jiveId,
                         @"%@: Wrong id.", message);
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.content.type,
                         @"%@: Wrong type", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.parent], self.content.parent,
                         @"%@: Wrong parent", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.subject], self.content.subject,
                         @"%@: Wrong subject", message);
    if ([self.content isVisibleToExternalContributors]) {
        STAssertTrue([JSON[JiveContentAttributes.visibleToExternalContributors] boolValue],
                     @"%@: Wrong visibleToExternalContributors", message);
    } else {
        STAssertFalse([JSON[JiveContentAttributes.visibleToExternalContributors] boolValue],
                      @"%@: Wrong visibleToExternalContributors", message);
    }
    
    NSArray *tags = JSON[JiveContentAttributes.tags];
    
    STAssertTrue([[tags class] isSubclassOfClass:[NSArray class]], @"%@: Tags not converted", message);
    STAssertEquals([tags count], (NSUInteger)1,
                   @"%@: Tags array had the wrong number of entries", message);
    STAssertEqualObjects(tags[0],  self.content.tags[0], @"%@: Wrong tag", message);
}

- (void)assertContentToJSON:(NSDictionary *)JSON
              withItemCount:(NSUInteger)expectedCount
              messageHeader:(NSString *)message {
    [self assertCommonContentToJSON:JSON withItemCount:expectedCount messageHeader:message];
    
    NSDictionary *contentJSON = JSON[JiveContentAttributes.content];
    
    STAssertTrue([[contentJSON class] isSubclassOfClass:[NSDictionary class]],
                 @"%@: Content not converted", message);
    STAssertEquals([contentJSON count], (NSUInteger)1,
                   @"%@: Content dictionary had the wrong number of entries", message);
    STAssertEqualObjects(contentJSON[JiveTypedObjectAttributes.type],
                         self.content.content.type, @"%@: Wrong content type", message);
}


- (void)testContentPersistentJSON {
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    [self initializeContentForTest];
    
    JSON = [self.content persistentJSON];
    [self assertPersistentJSON:JSON withItemCount:25 messageHeader:@"initial content"];
    STAssertEqualObjects(JSON[JiveContentAttributes.published],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects(JSON[JiveContentAttributes.updated],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
}

- (void)testContentPersistentJSON_alternate {
    NSDictionary *JSON = [self.content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.content.type, @"Wrong type");
    
    [self initializeAlternateContentForTest];
    
    JSON = [self.content persistentJSON];
    [self assertPersistentJSON:JSON withItemCount:22 messageHeader:@"alternate content"];
    STAssertEqualObjects(JSON[JiveContentAttributes.published],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects(JSON[JiveContentAttributes.updated],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
}

- (void)assertPersistentJSON:(NSDictionary *)JSON
               withItemCount:(NSUInteger)expectedCount
               messageHeader:(NSString *)message {
    [self assertCommonContentToJSON:JSON
                      withItemCount:expectedCount
                      messageHeader:[@"persistent " stringByAppendingString:message]];
    
    STAssertEqualObjects(JSON[JiveContentAttributes.contentID],
                         self.content.contentID, @"%@: Wrong contentID", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.followerCount],
                         self.content.followerCount, @"%@: Wrong followerCount", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.highlightBody],
                         self.content.highlightBody, @"%@: Wrong highlightBody", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.highlightSubject],
                         self.content.highlightSubject, @"%@: Wrong highlightSubject", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.highlightTags],
                         self.content.highlightTags, @"%@: Wrong highlightTags", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.iconCss],
                         self.content.iconCss, @"%@: Wrong iconCss", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.likeCount],
                         self.content.likeCount, @"%@: Wrong likeCount", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.replyCount],
                         self.content.replyCount, @"%@: Wrong replyCount", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.status],
                         self.content.status, @"%@: Wrong status", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.viewCount],
                         self.content.viewCount, @"%@: Wrong viewCount", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.note],
                         self.content.note, @"%@: Wrong note", message);
    STAssertEqualObjects(JSON[JiveContentAttributes.root],
                         self.content.root.absoluteString, @"%@: Wrong root", message);
    
    if ([self.content isParentContentVisible]) {
        STAssertTrue([JSON[JiveContentAttributes.parentContentVisible] boolValue],
                     @"%@: Wrong parentContentVisible", message);
    } else {
        STAssertFalse([JSON[JiveContentAttributes.parentContentVisible] boolValue],
                      @"%@: Wrong parentContentVisible", message);
    }
    
    if ([self.content isParentVisible]) {
        STAssertTrue([JSON[JiveContentAttributes.parentVisible] boolValue],
                     @"%@: Wrong parentVisible", message);
    } else {
        STAssertFalse([JSON[JiveContentAttributes.parentVisible] boolValue],
                      @"%@: Wrong parentVisible", message);
    }

    NSDictionary *authorJSON = JSON[JiveContentAttributes.author];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]],
                 @"%@: Jive not converted", message);
    STAssertEquals([authorJSON count], (NSUInteger)3,
                   @"%@: Jive dictionary had the wrong number of entries", message);
    STAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         self.content.author.location, @"%@: Wrong value", message);
    STAssertEqualObjects(authorJSON[JivePersonAttributes.displayName],
                         self.content.author.displayName, @"%@: Wrong display name", message);
    
    NSDictionary *contentJSON = JSON[JiveContentAttributes.content];
    
    STAssertEqualObjects(contentJSON[JiveContentBodyAttributes.editable],
                         self.content.content.editable, @"%@: Wrong editable state", message);
    
    NSDictionary *parentContentJSON = JSON[JiveContentAttributes.parentContent];
    
    STAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]],
                 @"%@: Jive not converted", message);
    STAssertEquals([parentContentJSON count], (NSUInteger)1,
                   @"%@: Parent content dictionary had the wrong number of entries", message);
    STAssertEqualObjects(parentContentJSON[@"name"],
                         self.content.parentContent.name, @"%@: Wrong value", message);
    
    NSDictionary *parentPlaceJSON = JSON[JiveContentAttributes.parentPlace];
    
    STAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]],
                 @"%@: Jive not converted", message);
    STAssertEquals([parentPlaceJSON count], (NSUInteger)1,
                   @"%@: Parent place dictionary had the wrong number of entries", message);
    STAssertEqualObjects(parentPlaceJSON[@"name"],
                         self.content.parentPlace.name, @"%@: Wrong value", message);
    
    NSArray *contentImagesJSON = JSON[JiveContentAttributes.contentImages];
    NSDictionary *imageJSON = [contentImagesJSON lastObject];
    
    STAssertTrue([[contentImagesJSON class] isSubclassOfClass:[NSArray class]],
                 @"%@: Jive not converted", message);
    STAssertEquals([contentImagesJSON count], (NSUInteger)1,
                   @"%@: Images array had the wrong number of entries", message);
    STAssertEqualObjects(imageJSON[JiveObjectConstants.id],
                         ((JiveImage *)[self.content.contentImages lastObject]).jiveId,
                         @"%@: Wrong value", message);
    
    NSArray *contentVideosJSON = JSON[JiveContentAttributes.contentVideos];
    NSDictionary *contentVideoJSON = [contentVideosJSON lastObject];
    
    STAssertTrue([[contentVideosJSON class] isSubclassOfClass:[NSArray class]],
                 @"%@: Video beans array not converted", message);
    STAssertEquals([contentVideosJSON count], (NSUInteger)1,
                   @"%@: Video beans array had the wrong number of entries", message);
    STAssertTrue([[contentVideoJSON class] isSubclassOfClass:[NSDictionary class]],
                 @"%@: Vdieo bean not converted", message);
    STAssertEqualObjects(contentVideoJSON[JiveContentVideoAttributes.stillImageURL],
                         [((JiveContentVideo *)[self.content.contentVideos lastObject]).stillImageURL absoluteString],
                         @"%@: Wrong still image", message);
}

- (void)testContentParsing {
    [self initializeContentForTest];
    
    id JSON = [self.content persistentJSON];
    JiveContent *newContent = [JiveContent objectFromJSON:JSON withInstance:self.instance];
    
    STAssertNotNil(newContent, @"Content object not created");
    [self assertSameAsOriginal:newContent message:@"initial content"];
}

- (void)testContentParsingAlternate {
    [self initializeAlternateContentForTest];
    
    id JSON = [self.content persistentJSON];
    JiveContent *newContent = [JiveContent objectFromJSON:JSON withInstance:self.instance];
    
    STAssertNotNil(newContent, @"Content object not created");
    [self assertSameAsOriginal:newContent message:@"alternate content"];
}

- (void)assertSameAsOriginal:(JiveContent *)newContent message:(NSString *)message {
    STAssertTrue([[newContent class] isSubclassOfClass:[JiveContent class]],
                 @"%@: Wrong item class", message);
    STAssertEqualObjects(newContent.author.location, self.content.author.location,
                         @"%@: Wrong author.location", message);
    STAssertEqualObjects(newContent.content.type, self.content.content.type,
                         @"%@: Wrong content.type", message);
    STAssertEqualObjects(newContent.contentID, self.content.contentID,
                         @"%@: Wrong contentID", message);
    STAssertEquals(newContent.contentImages.count, self.content.contentImages.count,
                   @"%@: Wrong number of images", message);
    STAssertEqualObjects(((JiveImage *)[newContent.contentImages lastObject]).jiveId,
                         ((JiveImage *)[self.content.contentImages lastObject]).jiveId,
                         @"%@: Wrong image id", message);
    STAssertEquals(newContent.contentVideos.count, self.content.contentVideos.count,
                   @"%@: Wrong number of videos", message);
    STAssertEqualObjects([((JiveContentVideo *)[newContent.contentVideos lastObject]).stillImageURL absoluteString],
                         [((JiveContentVideo *)[self.content.contentVideos lastObject]).stillImageURL absoluteString],
                         @"%@: Wrong still image url", message);
    STAssertEqualObjects(newContent.followerCount, self.content.followerCount,
                         @"%@: Wrong followerCount", message);
    STAssertEqualObjects(newContent.highlightBody, self.content.highlightBody,
                         @"%@: Wrong highlightBody", message);
    STAssertEqualObjects(newContent.highlightSubject, self.content.highlightSubject,
                         @"%@: Wrong highlightSubject", message);
    STAssertEqualObjects(newContent.highlightTags, self.content.highlightTags,
                         @"%@: Wrong highlightTags", message);
    STAssertEqualObjects(newContent.iconCss, self.content.iconCss,
                         @"%@: Wrong iconCss", message);
    STAssertEqualObjects(newContent.jiveId, self.content.jiveId,
                         @"%@: Wrong id", message);
    STAssertEqualObjects(newContent.likeCount, self.content.likeCount,
                         @"%@: Wrong likeCount", message);
    STAssertEqualObjects(newContent.parent, self.content.parent,
                         @"%@: Wrong parent", message);
    STAssertEqualObjects(newContent.parentContent.name, self.content.parentContent.name,
                         @"%@: Wrong parentContent.name", message);
    STAssertEqualObjects(newContent.parentContentVisible, self.content.parentContentVisible,
                         @"%@: Wrong parentContentVisible", message);
    STAssertEqualObjects(newContent.parentPlace.name, self.content.parentPlace.name,
                         @"%@: Wrong parentPlace.name", message);
    STAssertEqualObjects(newContent.parentVisible, self.content.parentVisible,
                         @"%@: Wrong parentVisible", message);
    STAssertEqualObjects(newContent.published, self.content.published,
                         @"%@: Wrong published", message);
    STAssertEqualObjects(newContent.replyCount, self.content.replyCount,
                         @"%@: Wrong replyCount", message);
    STAssertEqualObjects(newContent.status, self.content.status,
                         @"%@: Wrong status", message);
    STAssertEqualObjects(newContent.subject, self.content.subject,
                         @"%@: Wrong subject", message);
    STAssertEquals(newContent.tags.count, self.content.tags.count,
                   @"%@: Wrong number of tags", message);
    STAssertEqualObjects([newContent.tags lastObject], [self.content.tags lastObject],
                         @"%@: Wrong tag", message);
    STAssertEqualObjects(newContent.updated, self.content.updated,
                         @"%@: Wrong updated", message);
    STAssertEqualObjects(newContent.viewCount, self.content.viewCount,
                         @"%@: Wrong viewCount", message);
    STAssertEqualObjects(newContent.visibleToExternalContributors,
                         self.content.visibleToExternalContributors,
                         @"%@: Wrong visibileToExternalContributors", message);
    STAssertEqualObjects(newContent.note, self.content.note,
                         @"%@: Wrong note", message);
    STAssertEqualObjects(newContent.root, self.content.root,
                         @"%@: Wrong root", message);
}

@end
