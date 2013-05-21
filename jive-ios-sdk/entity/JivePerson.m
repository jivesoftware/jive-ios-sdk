//
//  JivePerson.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
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

#import "JivePerson.h"
#import "JivePersonJive.h"
#import "JiveName.h"
#import "JiveAddress.h"
#import "JiveEmail.h"
#import "JivePhoneNumber.h"
#import "JiveTypedObject_internal.h"

struct JivePersonAttributes const JivePersonAttributes = {
	.addresses = @"addresses",
	.displayName = @"displayName",
	.emails = @"emails",
	.followerCount = @"followerCount",
	.followingCount = @"followingCount",
	.jiveId = @"jiveId",
	.jive = @"jive",
	.location = @"location",
	.name = @"name",
	.phoneNumbers = @"phoneNumbers",
	.photos = @"photos",
	.published = @"published",
	.status = @"status",
	.tags = @"tags",
	.thumbnailUrl = @"thumbnailUrl",
	.updated = @"updated"
};

struct JivePersonResourceAttributes {
    __unsafe_unretained NSString *activity;
    __unsafe_unretained NSString *avatar;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *colleagues;
    __unsafe_unretained NSString *extprops;
    __unsafe_unretained NSString *followers;
    __unsafe_unretained NSString *following;
    __unsafe_unretained NSString *followingIn;
    __unsafe_unretained NSString *html;
    __unsafe_unretained NSString *images;
    __unsafe_unretained NSString *manager;
    __unsafe_unretained NSString *members;
    __unsafe_unretained NSString *reports;
    __unsafe_unretained NSString *streams;
    __unsafe_unretained NSString *tasks;
} const JivePersonResourceAttributes;

struct JivePersonResourceAttributes const JivePersonResourceAttributes = {
    .activity = @"activity",
    .avatar = @"avatar",
    .blog = @"blog",
    .colleagues = @"colleagues",
    .extprops = @"extprops",
    .followers = @"followers",
    .following = @"following",
    .followingIn = @"followingIn",
    .html = @"html",
    .images = @"images",
    .manager = @"manager",
    .members = @"members",
    .reports = @"reports",
    .streams = @"streams",
    .tasks = @"tasks"
};

@implementation JivePerson
@synthesize addresses, displayName, emails, followerCount, followingCount, jiveId, jive, location, name, phoneNumbers, photos, published, status, tags, thumbnailUrl, updated;

static NSString * const JivePersonType = @"person";

+ (void)load {
    if (self == [JivePerson class])
        [super registerClass:self forType:JivePersonType];
}

- (NSString *)type {
    return JivePersonType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    static NSDictionary *propertyClasses = nil;
    
    if (!propertyClasses)
        propertyClasses = [NSDictionary dictionaryWithObjectsAndKeys:
                           [JiveAddress class], JivePersonAttributes.addresses,
                           [JiveEmail class], JivePersonAttributes.emails,
                           [JivePhoneNumber class], JivePersonAttributes.phoneNumbers,
                           nil];
    
    return [propertyClasses objectForKey:propertyName];
}

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    [dictionary setValue:self.location forKey:JivePersonAttributes.location];
    [dictionary setValue:self.status forKey:JivePersonAttributes.status];
    [self addArrayElements:addresses toJSONDictionary:dictionary forTag:JivePersonAttributes.addresses];
    [self addArrayElements:emails toJSONDictionary:dictionary forTag:JivePersonAttributes.emails];
    [self addArrayElements:phoneNumbers toJSONDictionary:dictionary
                    forTag:JivePersonAttributes.phoneNumbers];
    if (jive)
        [dictionary setValue:[jive toJSONDictionary] forKey:JivePersonAttributes.jive];
    
    if (name)
        [dictionary setValue:[name toJSONDictionary] forKey:JivePersonAttributes.name];
    
    if (tags)
        [dictionary setValue:[tags copy] forKey:JivePersonAttributes.tags];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    [dictionary setValue:displayName forKey:JivePersonAttributes.displayName];
    
    return dictionary;
}

- (NSURL *)avatarRef {
    return [self resourceForTag:JivePersonResourceAttributes.avatar].ref;
}

- (NSURL *)activityRef {
    return [self resourceForTag:JivePersonResourceAttributes.activity].ref;
}

- (NSURL *)blogRef {
    return [self resourceForTag:JivePersonResourceAttributes.blog].ref;
}

- (NSURL *)colleaguesRef {
    return [self resourceForTag:JivePersonResourceAttributes.colleagues].ref;
}

- (NSURL *)extPropsRef {
    return [self resourceForTag:JivePersonResourceAttributes.extprops].ref;
}

- (BOOL)canDeleteExtProps {
    return [self resourceHasDeleteForTag:JivePersonResourceAttributes.extprops];
}

- (BOOL)canAddExtProps {
    return [self resourceHasPostForTag:JivePersonResourceAttributes.extprops];
}

- (NSURL *)followersRef {
    return [self resourceForTag:JivePersonResourceAttributes.followers].ref;
}

- (NSURL *)followingRef {
    return [self resourceForTag:JivePersonResourceAttributes.following].ref;
}

- (NSURL *)followingInRef {
    return [self resourceForTag:JivePersonResourceAttributes.followingIn].ref;
}

- (NSURL *)htmlRef {
    return [self resourceForTag:JivePersonResourceAttributes.html].ref;
}

- (NSURL *)imagesRef {
    return [self resourceForTag:JivePersonResourceAttributes.images].ref;
}

- (NSURL *)managerRef {
    return [self resourceForTag:JivePersonResourceAttributes.manager].ref;
}

- (NSURL *)membersRef {
    return [self resourceForTag:JivePersonResourceAttributes.members].ref;
}

- (NSURL *)reportsRef {
    return [self resourceForTag:JivePersonResourceAttributes.reports].ref;
}

- (NSURL *)streamsRef {
    return [self resourceForTag:JivePersonResourceAttributes.streams].ref;
}

- (BOOL)canCreateNewStream {
    return [self resourceHasPostForTag:JivePersonResourceAttributes.streams];
}

- (NSURL *)tasksRef {
    return [self resourceForTag:JivePersonResourceAttributes.tasks].ref;
}

- (BOOL)canCreateNewTask {
    return [self resourceHasPostForTag:JivePersonResourceAttributes.tasks];
}

@end
