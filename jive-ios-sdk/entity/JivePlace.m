//
//  JivePlace.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
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

#import "JivePlace.h"

#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"
#import "JiveSummary.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

struct JivePlaceAttributes const JivePlaceAttributes = {
        .contentTypes = @"contentTypes",
        .description = @"description",
        .displayName = @"displayName",
        .followerCount = @"followerCount",
        .highlightBody = @"highlightBody",
        .highlightSubject = @"highlightSubject",
        .highlightTags = @"highlightTags",
        .jiveId = @"jiveId",
        .likeCount = @"likeCount",
        .name = @"name",
        .parent = @"parent",
        .parentContent = @"parentContent",
        .parentPlace = @"parentPlace",
        .published = @"published",
        .status = @"status",
        .updated = @"updated",
        .viewCount = @"viewCount",
        .visibleToExternalContributors = @"visibleToExternalContributors"
};

struct JivePlaceResourceAttributes const JivePlaceResourceAttributes = {
        .activity = @"activity",
        .announcements = @"announcements",
        .avatar = @"avatar",
        .blog = @"blog",
        .categories = @"categories",
        .contents = @"contents",
        .extprops = @"extprops",
        .featuredContent = @"featuredContent",
        .followingIn = @"followingIn",
        .html = @"html",
        .invites = @"invites",
        .members = @"members",
        .places = @"places",
        .self = @"self",
        .statics = @"statics",
};


@implementation JivePlace

@synthesize contentTypes, description, displayName, followerCount, highlightBody, highlightSubject;
@synthesize highlightTags, jiveId, likeCount, name, parent, parentContent, parentPlace, published;
@synthesize status, updated, viewCount, visibleToExternalContributors;

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

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
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
