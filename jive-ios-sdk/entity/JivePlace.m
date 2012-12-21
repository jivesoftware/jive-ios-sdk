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
#import "NSThread+JiveISO8601DateFormatter.h"
#import "JiveResourceEntry.h"

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

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
    
    for (NSString *key in JSON) {
        JiveResourceEntry *entry = [JiveResourceEntry instanceFromJSON:[JSON objectForKey:key]];
        
        [dictionary setValue:entry forKey:key];
    }
    
    return dictionary.count > 0 ? [NSDictionary dictionaryWithDictionary:dictionary] : nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    
    [dictionary setValue:self.displayName forKey:@"displayName"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    [dictionary setValue:self.status forKey:@"status"];
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.followerCount forKey:@"followerCount"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.description forKey:@"description"];
    [dictionary setValue:self.highlightBody forKey:@"highlightBody"];
    [dictionary setValue:self.highlightSubject forKey:@"highlightSubject"];
    [dictionary setValue:self.highlightTags forKey:@"highlightTags"];
    [dictionary setValue:self.likeCount forKey:@"likeCount"];
    [dictionary setValue:self.viewCount forKey:@"viewCount"];
    [dictionary setValue:self.parent forKey:@"parent"];
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    if (parentContent)
        [dictionary setValue:[parentContent toJSONDictionary] forKey:@"parentContent"];
    
    if (parentPlace)
        [dictionary setValue:[parentPlace toJSONDictionary] forKey:@"parentPlace"];
    
    if (contentTypes)
        [dictionary setValue:[contentTypes copy] forKey:@"contentTypes"];
    
    if (visibleToExternalContributors)
        [dictionary setValue:(__bridge id)kCFBooleanTrue forKey:@"visibleToExternalContributors"];
    
    return dictionary;
}

@end
