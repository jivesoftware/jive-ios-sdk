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
    
    static NSDictionary *classDictionary = nil;
    
    if (!classDictionary)
        classDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[JiveAnnouncement class], @"announcement",
                           [JiveMessage class], @"message",
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

@end
