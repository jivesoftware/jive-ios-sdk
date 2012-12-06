//
//  JiveContentTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContentTests.h"
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

@implementation JiveContentTests

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

@end
