//
//  JiveContentTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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

@implementation JiveContentTests

@synthesize content;

- (void)setUp {
    content = [[JiveContent alloc] init];
}

- (void)tearDown {
    content = nil;
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
    
    content.type = nil; // Clear derived class type
    
    id JSON = [content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    author.displayName = @"author";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    content.parent = @"parent";
    content.subject = @"Subject";
    content.type = @"not a real type";
    [content setValue:@"1234" forKey:@"jiveId"];
    [content setValue:author forKey:@"author"];
    [content setValue:contentBody forKey:@"content"];
    [content setValue:parentContent forKey:@"parentContent"];
    [content setValue:parentPlace forKey:@"parentPlace"];
    [content setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [content setValue:@"body" forKey:@"highlightBody"];
    [content setValue:@"subject" forKey:@"highlightSubject"];
    [content setValue:@"tags" forKey:@"highlightTags"];
    [content setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [content setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [content setValue:@"status" forKey:@"status"];
    [content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [content setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    
    JSON = [content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)18, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], content.jiveId, @"Wrong id");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], content.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"parent"], content.parent, @"Wrong parent");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"subject"], content.subject, @"Wrong subject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followerCount"], content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightBody"], content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightSubject"], content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightTags"], content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"likeCount"], content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"replyCount"], content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"status"], content.status, @"Wrong status");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"viewCount"], content.viewCount, @"Wrong viewCount");
    
    NSArray *authorJSON = [(NSDictionary *)JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)authorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)authorJSON objectForKey:@"displayName"], author.displayName, @"Wrong value");
    
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
    
    content.type = nil; // Clear derived class type
    
    id JSON = [content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    author.displayName = @"Gibson";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    content.parent = @"William";
    content.subject = @"Writing";
    content.type = @"another non-type";
    [content setValue:@"8743" forKey:@"jiveId"];
    [content setValue:author forKey:@"author"];
    [content setValue:contentBody forKey:@"content"];
    [content setValue:parentContent forKey:@"parentContent"];
    [content setValue:parentPlace forKey:@"parentPlace"];
    [content setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [content setValue:@"green" forKey:@"highlightBody"];
    [content setValue:@"white" forKey:@"highlightSubject"];
    [content setValue:@"blue" forKey:@"highlightTags"];
    [content setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [content setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [content setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [content setValue:@"upside down" forKey:@"status"];
    [content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [content setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    
    JSON = [content toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)18, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], content.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], content.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"parent"], content.parent, @"Wrong parent");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"subject"], content.subject, @"Wrong subject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followerCount"], content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightBody"], content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightSubject"], content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"highlightTags"], content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"likeCount"], content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"replyCount"], content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"status"], content.status, @"Wrong status");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"viewCount"], content.viewCount, @"Wrong viewCount");
    
    NSArray *authorJSON = [(NSDictionary *)JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)authorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)authorJSON objectForKey:@"displayName"], author.displayName, @"Wrong value");
    
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
    author.displayName = @"author";
    contentBody.type = @"content";
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    content.parent = @"parent";
    content.subject = @"Subject";
    [content setValue:@"1234" forKey:@"jiveId"];
    [content setValue:author forKey:@"author"];
    [content setValue:contentBody forKey:@"content"];
    [content setValue:parentContent forKey:@"parentContent"];
    [content setValue:parentPlace forKey:@"parentPlace"];
    [content setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [content setValue:@"body" forKey:@"highlightBody"];
    [content setValue:@"subject" forKey:@"highlightSubject"];
    [content setValue:@"tags" forKey:@"highlightTags"];
    [content setValue:[NSNumber numberWithInt:12] forKey:@"likeCount"];
    [content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [content setValue:[NSNumber numberWithInt:33] forKey:@"replyCount"];
    [content setValue:@"status" forKey:@"status"];
    [content setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"updated"];
    [content setValue:[NSNumber numberWithInt:6] forKey:@"viewCount"];
    [content setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [content toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveContent *newContent = [JiveContent instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[content class]], @"Wrong item class");
    STAssertEqualObjects(newContent.jiveId, content.jiveId, @"Wrong id");
    STAssertEqualObjects(newContent.type, content.type, @"Wrong type");
    STAssertEqualObjects(newContent.parent, content.parent, @"Wrong parent");
    STAssertEqualObjects(newContent.subject, content.subject, @"Wrong subject");
    STAssertEqualObjects(newContent.followerCount, content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newContent.highlightBody, content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newContent.highlightSubject, content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newContent.highlightTags, content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newContent.likeCount, content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newContent.published, content.published, @"Wrong published");
    STAssertEqualObjects(newContent.replyCount, content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newContent.status, content.status, @"Wrong status");
    STAssertEqualObjects(newContent.updated, content.updated, @"Wrong updated");
    STAssertEqualObjects(newContent.viewCount, content.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newContent.author.displayName, content.author.displayName, @"Wrong author.displayName");
    STAssertEqualObjects(newContent.content.type, content.content.type, @"Wrong content.type");
    STAssertEqualObjects(newContent.parentContent.name, content.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newContent.parentPlace.name, content.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEquals([newContent.resources count], [content.resources count], @"Wrong number of resource objects");
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
    author.displayName = @"Gibson";
    contentBody.type = @"hair";
    [parentContent setValue:@"swimming" forKey:@"name"];
    [parentPlace setValue:@"school" forKey:@"name"];
    content.parent = @"William";
    content.subject = @"Writing";
    [content setValue:@"8743" forKey:@"jiveId"];
    [content setValue:author forKey:@"author"];
    [content setValue:contentBody forKey:@"content"];
    [content setValue:parentContent forKey:@"parentContent"];
    [content setValue:parentPlace forKey:@"parentPlace"];
    [content setValue:[NSNumber numberWithInt:7] forKey:@"followerCount"];
    [content setValue:@"green" forKey:@"highlightBody"];
    [content setValue:@"white" forKey:@"highlightSubject"];
    [content setValue:@"blue" forKey:@"highlightTags"];
    [content setValue:[NSNumber numberWithInt:4] forKey:@"likeCount"];
    [content setValue:[NSDate dateWithTimeIntervalSince1970:1.234] forKey:@"published"];
    [content setValue:[NSNumber numberWithInt:8] forKey:@"replyCount"];
    [content setValue:@"upside down" forKey:@"status"];
    [content setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [content setValue:[NSNumber numberWithInt:44] forKey:@"viewCount"];
    [content setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [content toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveContent *newContent = [JiveContent instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[content class]], @"Wrong item class");
    STAssertEqualObjects(newContent.jiveId, content.jiveId, @"Wrong id");
    STAssertEqualObjects(newContent.type, content.type, @"Wrong type");
    STAssertEqualObjects(newContent.parent, content.parent, @"Wrong parent");
    STAssertEqualObjects(newContent.subject, content.subject, @"Wrong subject");
    STAssertEqualObjects(newContent.followerCount, content.followerCount, @"Wrong followerCount");
    STAssertEqualObjects(newContent.highlightBody, content.highlightBody, @"Wrong highlightBody");
    STAssertEqualObjects(newContent.highlightSubject, content.highlightSubject, @"Wrong highlightSubject");
    STAssertEqualObjects(newContent.highlightTags, content.highlightTags, @"Wrong highlightTags");
    STAssertEqualObjects(newContent.likeCount, content.likeCount, @"Wrong likeCount");
    STAssertEqualObjects(newContent.published, content.published, @"Wrong published");
    STAssertEqualObjects(newContent.replyCount, content.replyCount, @"Wrong replyCount");
    STAssertEqualObjects(newContent.status, content.status, @"Wrong status");
    STAssertEqualObjects(newContent.updated, content.updated, @"Wrong updated");
    STAssertEqualObjects(newContent.viewCount, content.viewCount, @"Wrong viewCount");
    STAssertEqualObjects(newContent.author.displayName, content.author.displayName, @"Wrong author.displayName");
    STAssertEqualObjects(newContent.content.type, content.content.type, @"Wrong content.type");
    STAssertEqualObjects(newContent.parentContent.name, content.parentContent.name, @"Wrong parentContent.name");
    STAssertEqualObjects(newContent.parentPlace.name, content.parentPlace.name, @"Wrong parentPlace.name");
    STAssertEquals([newContent.resources count], [content.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newContent.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
