//
//  JiveVideo.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/20/13.
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

#import "JiveVideo.h"
#import "JiveTypedObject_internal.h"

struct JiveVideoAttributes const JiveVideoAttributes = {
    .categories = @"categories",
    .tags = @"tags",
    .users = @"users",
    .visibility = @"visibility",
    .visibleToExternalContributors = @"visibleToExternalContributors",
    .authtoken = @"authtoken",
    .externalID = @"externalID",
    .playerBaseURL = @"playerBaseURL",
    .width = @"width",
    .height = @"height",
};

@implementation JiveVideo

@synthesize tags, visibleToExternalContributors, externalID, playerBaseURL, width, height, authtoken;
@synthesize categories, users, visibility;

NSString * const JiveVideoType = @"video";

+ (void)load {
    if (self == [JiveVideo class])
        [super registerClass:self forType:JiveVideoType];
}

- (NSString *)type {
    return JiveVideoType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:visibleToExternalContributors forKey:JiveVideoAttributes.visibleToExternalContributors];
    [dictionary setValue:visibility forKey:JiveVideoAttributes.visibility];
    [dictionary setValue:externalID forKey:JiveVideoAttributes.externalID];
    [dictionary setValue:authtoken forKey:JiveVideoAttributes.authtoken];
    [dictionary setValue:width forKey:JiveVideoAttributes.width];
    [dictionary setValue:height forKey:JiveVideoAttributes.height];
    [dictionary setValue:[playerBaseURL absoluteString] forKey:JiveVideoAttributes.playerBaseURL];
    if (users.count > 0 && [[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]])
        [dictionary setValue:users forKey:JiveVideoAttributes.users];
    else
        [self addArrayElements:users toJSONDictionary:dictionary forTag:JiveVideoAttributes.users];
    
    if (categories)
        [dictionary setValue:categories forKey:JiveVideoAttributes.categories];
    
    if (tags)
        [dictionary setValue:tags forKey:JiveVideoAttributes.tags];
    
    return dictionary;
}

@end
