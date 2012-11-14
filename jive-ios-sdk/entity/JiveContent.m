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
#import "JiveDocument.h"
#import "JiveFile.h"
#import "JivePoll.h"
#import "JivePost.h"
#import "JiveComment.h"
#import "JiveDirectMessage.h"
#import "JiveFavorite.h"
#import "JiveTask.h"
#import "JiveUpdate.h"


@implementation JiveContent
@synthesize author, content, followerCount, highlightBody, highlightSubject, highlightTags, jiveId, likeCount, parent, parentContent, parentPlace, published, replyCount, resources, status, subject, type, updated, viewCount;

+ (Class) entityClass:(NSDictionary*) obj {
    NSString* type = [obj objectForKey:@"type"];
    if (type == @"announcement") {
        return [JiveAnnouncement class];
    } else if (type == @"message") {
        return [JiveMessage class];
    } else if (type == @"document") {
        return [JiveDocument class];
    } else if (type == @"file") {
        return [JiveFile class];
    } else if (type == @"poll") {
        return [JivePoll class];
    } else if (type == @"post") {
        return [JivePost class];
    } else if (type == @"comment") {
        return [JiveComment class];
    } else if (type == @"dm") {
        return [JiveDirectMessage class];
    } else if (type == @"favorite") {
        return [JiveFavorite class];
    } else if (type == @"task") {
        return [JiveTask class];
    } else if (type == @"update") {
        return [JiveUpdate class];
    } else {
        return [self class];
    }
}

@end
