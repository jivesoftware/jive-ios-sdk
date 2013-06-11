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
#import "JiveTypedObject_internal.h"

#import "NSDateFormatter+JiveISO8601DateFormatter.h"

struct JiveContentResourceTags {
    __unsafe_unretained NSString *attachments;
    __unsafe_unretained NSString *childOutcomeTypes;
    __unsafe_unretained NSString *comments;
    __unsafe_unretained NSString *extProps;
    __unsafe_unretained NSString *followingIn;
    __unsafe_unretained NSString *html;
    __unsafe_unretained NSString *images;
    __unsafe_unretained NSString *likes;
    __unsafe_unretained NSString *messages;
    __unsafe_unretained NSString *outcomes;
    __unsafe_unretained NSString *outcomeTypes;
    __unsafe_unretained NSString *read;
    __unsafe_unretained NSString *versions;
    __unsafe_unretained NSString *votes;
} const JiveContentResourceTags;

struct JiveContentResourceTags const JiveContentResourceTags = {
    .childOutcomeTypes = @"childOutcomeTypes",
    .extProps = @"extprops",
    .html = @"html",
    .likes = @"likes",
    .outcomes = @"outcomes",
    .outcomeTypes = @"outcomeTypes",
    .read = @"read",
    .attachments = @"attachments",
    .comments = @"comments",
    .followingIn = @"followingIn",
    .versions = @"versions",
    .images = @"images",
    .messages = @"messages",
    .votes = @"votes"
};

struct JiveContentAttributes const JiveContentAttributes = {
        .author = @"author",
        .content = @"content",
        .followerCount = @"followerCount",
        .highlightBody = @"highlightBody",
        .highlightSubject = @"highlightSubject",
        .highlightTags = @"highlightTags",
        .likeCount = @"likeCount",
        .parent = @"parent",
        .parentContent = @"parentContent",
        .parentPlace = @"parentPlace",
        .published = @"published",
        .replyCount = @"replyCount",
        .status = @"status",
        .subject = @"subject",
        .updated = @"updated",
        .viewCount = @"viewCount"
};

@implementation JiveContent

@synthesize author, content, followerCount, highlightBody, highlightSubject, highlightTags, jiveId, likeCount, parent, parentContent, parentPlace, published, replyCount, status, subject, updated, viewCount;

static NSMutableDictionary *contentClasses;

+ (void)registerClass:(Class)clazz forType:(NSString *)type {
    [super registerClass:clazz forType:type];
    if (!contentClasses)
        contentClasses = [NSMutableDictionary dictionary];
    
    [contentClasses setValue:clazz forKey:type];
}

+ (Class) entityClass:(NSDictionary*) obj {
    NSString* type = [obj objectForKey:@"type"];
    
    if (!type)
        return [self class];
    
    return [[contentClasses objectsForKeys:[NSArray arrayWithObject:type]
                            notFoundMarker:[self class]] objectAtIndex:0];
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

- (NSURL *)likesRef {
    return [self resourceForTag:JiveContentResourceTags.likes].ref;
}

- (BOOL)canLike {
    return [self resourceHasPostForTag:JiveContentResourceTags.likes];
}

- (BOOL)canUnlike {
    return [self resourceHasDeleteForTag:JiveContentResourceTags.likes];
}

- (NSURL *)htmlRef {
    return [self resourceForTag:JiveContentResourceTags.html].ref;
}

- (NSURL *)extPropsRef {
    return [self resourceForTag:JiveContentResourceTags.extProps].ref;
}

- (BOOL)canAddExtProps {
    return [self resourceHasPostForTag:JiveContentResourceTags.extProps];
}

- (BOOL)canDeleteExtProps {
    return [self resourceHasDeleteForTag:JiveContentResourceTags.extProps];
}

- (NSURL *)readRef {
    return [self resourceForTag:JiveContentResourceTags.read].ref;
}

- (BOOL)canMarkAsRead {
    return [self resourceHasPostForTag:JiveContentResourceTags.read];
}

- (BOOL)canMarkAsUnread {
    return [self resourceHasDeleteForTag:JiveContentResourceTags.read];
}

- (NSURL *)outcomesRef {
    return [self resourceForTag:JiveContentResourceTags.outcomes].ref;
}

- (BOOL)canAddOutcomes {
    return [self resourceHasPostForTag:JiveContentResourceTags.outcomes];
}

- (NSURL *)outcomeTypesRef {
    return [self resourceForTag:JiveContentResourceTags.outcomeTypes].ref;
}

- (NSURL *)childOutcomeTypesRef {
    return [self resourceForTag:JiveContentResourceTags.childOutcomeTypes].ref;
}

- (NSURL *)attachmentsRef {
    return [self resourceForTag:JiveContentResourceTags.attachments].ref;
}

- (NSURL *)commentsRef {
    return [self resourceForTag:JiveContentResourceTags.comments].ref;
}

- (BOOL)canAddComments {
    return [self resourceHasPostForTag:JiveContentResourceTags.comments];
}

- (NSURL *)followingInRef {
    return [self resourceForTag:JiveContentResourceTags.followingIn].ref;
}

- (NSURL *)versionsRef {
    return [self resourceForTag:JiveContentResourceTags.versions].ref;
}

- (NSURL *)messagesRef {
    return [self resourceForTag:JiveContentResourceTags.messages].ref;
}

- (BOOL)canAddMessage {
    return [self resourceHasPostForTag:JiveContentResourceTags.messages];
}

- (NSURL *)imagesRef {
    return [self resourceForTag:JiveContentResourceTags.images].ref;
}

- (NSURL *)votesRef {
    return [self resourceForTag:JiveContentResourceTags.votes].ref;
}

- (BOOL)canVote {
    return [self resourceHasPostForTag:JiveContentResourceTags.votes];
}

@end
