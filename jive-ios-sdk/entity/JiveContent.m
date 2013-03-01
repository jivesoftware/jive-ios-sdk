//
//  JiveContent.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
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

struct JiveContentAttributes const JiveContentAttributes = {
	.author = @"author"
};

@implementation JiveContent

@synthesize author, content, followerCount, highlightBody, highlightSubject, highlightTags, jiveId, likeCount, parent, parentContent, parentPlace, published, replyCount, status, subject, updated, viewCount;

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
    [dictionary setValue:self.type forKey:@"type"];
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
