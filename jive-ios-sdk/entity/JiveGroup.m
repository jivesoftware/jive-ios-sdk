//
//  JiveGroup.m
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

#import "JiveGroup.h"
#import "JiveTypedObject_internal.h"

struct JiveGroupResourceAttributes {
    __unsafe_unretained NSString *announcements;
    __unsafe_unretained NSString *avatar;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *invites;
    __unsafe_unretained NSString *members;
    __unsafe_unretained NSString *childPlaces;
} const JiveGroupResourceAttributes;

struct JiveGroupResourceAttributes const JiveGroupResourceAttributes = {
    .announcements = @"announcements",
    .avatar = @"avatar",
    .blog = @"blog",
    .categories = @"categories",
    .invites = @"invites",
    .members = @"members",
    .childPlaces = @"places"
};

@implementation JiveGroup

@synthesize creator, groupType, memberCount, tags;

static NSString * const JiveGroupType = @"group";

+ (void)load {
    if (self == [JiveGroup class])
        [super registerClass:self forType:JiveGroupType];
}

- (NSString *)type {
    return JiveGroupType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:groupType forKey:@"groupType"];
    [dictionary setValue:memberCount forKey:@"memberCount"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (creator)
        [dictionary setValue:[creator toJSONDictionary] forKey:@"creator"];
    
    return dictionary;
}

- (NSURL *)announcementsRef {
    return [self resourceForTag:JiveGroupResourceAttributes.announcements].ref;
}

- (BOOL)canCreateAnnouncement {
    return [self resourceHasPostForTag:JiveGroupResourceAttributes.announcements];
}

- (NSURL *)avatarRef {
    return [self resourceForTag:JiveGroupResourceAttributes.avatar].ref;
}

- (BOOL)canDeleteAvatar {
    return [self resourceHasPostForTag:JiveGroupResourceAttributes.avatar];
}

- (BOOL)canUpdateAvatar {
    return [self resourceHasPostForTag:JiveGroupResourceAttributes.avatar];
}

- (NSURL *)blogRef {
    return [self resourceForTag:JiveGroupResourceAttributes.blog].ref;
}

- (NSURL *)categoriesRef {
    return [self resourceForTag:JiveGroupResourceAttributes.categories].ref;
}

- (BOOL)canAddCategory {
    return [self resourceHasPostForTag:JiveGroupResourceAttributes.categories];
}

- (NSURL *)invitesRef {
    return [self resourceForTag:JiveGroupResourceAttributes.invites].ref;
}

- (BOOL)canCreateInvite {
    return [self resourceHasPostForTag:JiveGroupResourceAttributes.invites];
}

- (NSURL *)membersRef {
    return [self resourceForTag:JiveGroupResourceAttributes.members].ref;
}

- (BOOL)canCreateMember {
    return [self resourceHasPostForTag:JiveGroupResourceAttributes.members];
}

- (NSURL *)childPlacesRef {
    return [self resourceForTag:JiveGroupResourceAttributes.childPlaces].ref;
}

@end
