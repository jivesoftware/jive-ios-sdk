//
//  JivePlace.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlace.h"

#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"
#import "JiveSummary.h"

@implementation JivePlace

@synthesize contentTypes, description, displayName, followerCount, highlightBody, highlightSubject;
@synthesize highlightTags, jiveId, likeCount, name, parent, parentContent, parentPlace, published;
@synthesize resources, status, type, updated, viewCount, visibleToExternalContributors;

+ (Class) entityClass:(NSDictionary*) obj {
    
    static NSDictionary *classDictionary = nil;

    if (!classDictionary)
        classDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[JiveBlog class], @"blog",
                           [JiveGroup class], @"group",
                           [JiveProject class], @"project",
                           [JiveSpace class], @"space",
                           nil];

    NSString* type = [obj objectForKey:@"type"];
    Class targetClass = [classDictionary objectForKey:type];
    
    return targetClass ? targetClass : [self class];
}

- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)value {
    if ([property isEqualToString:@"visibleToExternalContributors"])
        visibleToExternalContributors = CFBooleanGetValue((__bridge CFBooleanRef)(value));
}

@end
