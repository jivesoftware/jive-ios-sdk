//
//  JiveContent.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

#import "JiveAnnouncement.h"
#import "JiveMessage.h"
#import "JiveDiscussion.h"
#import "JiveDocument.h"
#import "JiveFile.h"
#import "JivePoll.h"
#import "JivePost.h"
#import "JiveComment.h"
#import "JiveDirectMessage.h"
#import "JiveFavorite.h"
#import "JiveTask.h"
#import "JiveUpdate.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveResourceEntry.h"


@implementation JiveContent
@synthesize author, content, followerCount, highlightBody, highlightSubject, highlightTags, jiveId, likeCount, parent, parentContent, parentPlace, published, replyCount, resources, status, subject, type, updated, viewCount;

+ (Class) entityClass:(NSDictionary*) obj {
    
    static NSDictionary *classDictionary = nil;
    
    if (!classDictionary)
        classDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[JiveAnnouncement class], @"announcement",
                           [JiveMessage class], @"message",
                           [JiveDiscussion class], @"discussion",
                           [JiveDocument class], @"document",
                           [JiveFile class], @"file",
                           [JivePoll class], @"poll",
                           [JivePost class], @"post",
                           [JiveComment class], @"comment",
                           [JiveDirectMessage class], @"dm",
                           [JiveFavorite class], @"favorite",
                           [JiveTask class], @"task",
                           [JiveUpdate class], @"update",
                           nil];
    
    NSString* type = [obj objectForKey:@"type"];
    Class targetClass = [classDictionary objectForKey:type];
    
    return targetClass ? targetClass : [self class];
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON {
    if ([@"resources" isEqualToString:property]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
        
        for (NSString *key in JSON) {
            JiveResourceEntry *entry = [JiveResourceEntry instanceFromJSON:[JSON objectForKey:key]];
            
            [dictionary setValue:entry forKey:key];
        }
        
        return dictionary.count > 0 ? [NSDictionary dictionaryWithDictionary:dictionary] : nil;
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:followerCount forKey:@"followerCount"];
    [dictionary setValue:highlightBody forKey:@"highlightBody"];
    [dictionary setValue:highlightSubject forKey:@"highlightSubject"];
    [dictionary setValue:highlightTags forKey:@"highlightTags"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:likeCount forKey:@"likeCount"];
    [dictionary setValue:parent forKey:@"parent"];
    [dictionary setValue:replyCount forKey:@"replyCount"];
    [dictionary setValue:status forKey:@"status"];
    [dictionary setValue:subject forKey:@"subject"];
    [dictionary setValue:type forKey:@"type"];
    [dictionary setValue:viewCount forKey:@"viewCount"];
    
    if (author)
        [dictionary setValue:[author toJSONDictionary] forKey:@"author"];
    
    if (content)
        [dictionary setValue:[content toJSONDictionary] forKey:@"content"];
    
    if (parentContent)
        [dictionary setValue:[parentContent toJSONDictionary] forKey:@"parentContent"];
    
    if (parentPlace)
        [dictionary setValue:[parentPlace toJSONDictionary] forKey:@"parentPlace"];
    
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    return dictionary;
}

@end
