//
//  JiveSpace.m
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

#import "JiveSpace.h"
#import "JiveTypedObject_internal.h"

struct JiveSpaceAttributes const JiveSpaceAttributes = {
    .childCount = @"childCount",
    .locale = @"locale",
    .tags = @"tags",
};

struct JiveSpaceResourceAttributes {
    __unsafe_unretained NSString *announcements;
    __unsafe_unretained NSString *avatar;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *childPlaces;
} const JiveSpaceResourceAttributes;

struct JiveSpaceResourceAttributes const JiveSpaceResourceAttributes = {
    .announcements = @"announcements",
    .avatar = @"avatar",
    .blog = @"blog",
    .categories = @"categories",
    .childPlaces = @"places",
};

@implementation JiveSpace

@synthesize childCount, locale, tags;

static NSString * const JiveSpaceType = @"space";

+ (void)load {
    if (self == [JiveSpace class])
        [super registerClass:self forType:JiveSpaceType];
}

- (NSString *)type {
    return JiveSpaceType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:childCount forKey:@"childCount"];
    [dictionary setValue:locale forKey:JiveSpaceAttributes.locale];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    return dictionary;
}

- (NSURL *)announcementsRef {
    return [self resourceForTag:JiveSpaceResourceAttributes.announcements].ref;
}

- (BOOL)canCreateAnnouncement {
    return [self resourceHasPostForTag:JiveSpaceResourceAttributes.announcements];
}

- (NSURL *)avatarRef {
    return [self resourceForTag:JiveSpaceResourceAttributes.avatar].ref;
}

- (BOOL)canDeleteAvatar {
    return [self resourceHasPostForTag:JiveSpaceResourceAttributes.avatar];
}

- (BOOL)canUpdateAvatar {
    return [self resourceHasPostForTag:JiveSpaceResourceAttributes.avatar];
}

- (NSURL *)blogRef {
    return [self resourceForTag:JiveSpaceResourceAttributes.blog].ref;
}

- (NSURL *)categoriesRef {
    return [self resourceForTag:JiveSpaceResourceAttributes.categories].ref;
}

- (BOOL)canAddCategory {
    return [self resourceHasPostForTag:JiveSpaceResourceAttributes.categories];
}

- (NSURL *)childPlacesRef {
    return [self resourceForTag:JiveSpaceResourceAttributes.childPlaces].ref;
}

@end
