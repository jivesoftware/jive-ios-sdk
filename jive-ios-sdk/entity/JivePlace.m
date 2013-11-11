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
#import "JiveTypedObject_internal.h"

#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"
#import "JiveSummary.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

struct JivePlaceResourceAttributes {
    __unsafe_unretained NSString *activity;
    __unsafe_unretained NSString *announcements;
    __unsafe_unretained NSString *avatar;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *checkPoints;
    __unsafe_unretained NSString *childPlaces;
    __unsafe_unretained NSString *contents;
    __unsafe_unretained NSString *extprops;
    __unsafe_unretained NSString *featuredContent;
    __unsafe_unretained NSString *followingIn;
    __unsafe_unretained NSString *html;
    __unsafe_unretained NSString *invites;
    __unsafe_unretained NSString *members;
    __unsafe_unretained NSString *statics;
    __unsafe_unretained NSString *tasks;
};

struct JivePlaceAttributes const JivePlaceAttributes = {
    .contentTypes = @"contentTypes",
    .jiveDescription = @"jiveDescription",
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
    .contents = @"contents",
    .extprops = @"extprops",
    .featuredContent = @"featuredContent",
    .followingIn = @"followingIn",
    .html = @"html",
    .statics = @"statics",
    .announcements = @"announcements",
    .avatar = @"avatar",
    .blog = @"blog",
    .categories = @"categories",
    .invites = @"invites",
    .members = @"members",
    .childPlaces = @"places",
    .checkPoints = @"checkpoints",
    .tasks = @"tasks"
};

struct JivePlaceContentTypeValues const JivePlaceContentTypeValues = {
    .documents = @"documents",
    .discussions = @"discussions",
    .files = @"files",
    .polls = @"polls",
    .projects = @"projects",
    .tasks = @"tasks",
    .blog = @"blog",
    .updates = @"updates",
    .events = @"events",
    .videos = @"videos",
    .ideas = @"ideas"
};

@implementation JivePlace

@synthesize contentTypes, jiveDescription, displayName, followerCount, highlightBody, highlightSubject;
@synthesize highlightTags, jiveId, likeCount, name, parent, parentContent, parentPlace, published;
@synthesize status, updated, viewCount, visibleToExternalContributors;

static NSMutableDictionary *typedClasses;

+ (void)registerClass:(Class)clazz forType:(NSString *)type {
    [super registerClass:clazz forType:type];
    if (!typedClasses)
        typedClasses = [NSMutableDictionary dictionary];
    
    [typedClasses setValue:clazz forKey:type];
}

- (NSString *)type {
    return nil;
}

+ (Class) entityClass:(NSDictionary*) obj {
    Class foundClass = [self class];
    NSString* type = [obj objectForKey:@"type"];
    
    if (type)
        foundClass = [typedClasses objectsForKeys:@[type] notFoundMarker:foundClass][0];
    
    return foundClass;
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
    [dictionary setValue:self.jiveDescription forKey:@"description"];
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

- (NSURL *)activityRef {
    return [self resourceForTag:JivePlaceResourceAttributes.activity].ref;
}

- (NSURL *)contentsRef {
    return [self resourceForTag:JivePlaceResourceAttributes.contents].ref;
}

- (NSURL *)extpropsRef {
    return [self resourceForTag:JivePlaceResourceAttributes.extprops].ref;
}

- (BOOL)canDeleteExtProps {
    return [self resourceHasDeleteForTag:JivePlaceResourceAttributes.extprops];
}

- (BOOL)canAddExtProps {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.extprops];
}

- (NSURL *)featuredContentRef {
    return [self resourceForTag:JivePlaceResourceAttributes.featuredContent].ref;
}

- (NSURL *)followingInRef {
    return [self resourceForTag:JivePlaceResourceAttributes.followingIn].ref;
}

- (NSURL *)htmlRef {
    return [self resourceForTag:JivePlaceResourceAttributes.html].ref;
}

- (NSURL *)staticsRef {
    return [self resourceForTag:JivePlaceResourceAttributes.statics].ref;
}

- (BOOL)canAddStatic {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.statics];
}

- (NSURL *)announcementsRef {
    return [self resourceForTag:JivePlaceResourceAttributes.announcements].ref;
}

- (BOOL)canCreateAnnouncement {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.announcements];
}

- (NSURL *)avatarRef {
    return [self resourceForTag:JivePlaceResourceAttributes.avatar].ref;
}

- (BOOL)canDeleteAvatar {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.avatar];
}

- (BOOL)canUpdateAvatar {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.avatar];
}

- (NSURL *)blogRef {
    return [self resourceForTag:JivePlaceResourceAttributes.blog].ref;
}

- (NSURL *)categoriesRef {
    return [self resourceForTag:JivePlaceResourceAttributes.categories].ref;
}

- (BOOL)canAddCategory {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.categories];
}

- (NSURL *)invitesRef {
    return [self resourceForTag:JivePlaceResourceAttributes.invites].ref;
}

- (BOOL)canCreateInvite {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.invites];
}

- (NSURL *)membersRef {
    return [self resourceForTag:JivePlaceResourceAttributes.members].ref;
}

- (BOOL)canCreateMember {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.members];
}

- (NSURL *)childPlacesRef {
    return [self resourceForTag:JivePlaceResourceAttributes.childPlaces].ref;
}

- (NSURL *)checkPointsRef {
    return [self resourceForTag:JivePlaceResourceAttributes.checkPoints].ref;
}

- (BOOL)canUpdateCheckPoints {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.checkPoints];
}

- (NSURL *)tasksRef {
    return [self resourceForTag:JivePlaceResourceAttributes.tasks].ref;
}

- (BOOL)canCreateTask {
    return [self resourceHasPostForTag:JivePlaceResourceAttributes.tasks];
}

@end
