//
//  JivePoll.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JivePoll.h"
#import "JiveTypedObject_internal.h"

struct JivePollResourceTags {
    __unsafe_unretained NSString *votes;
} const JivePollResourceTags;

struct JivePollResourceTags const JivePollResourceTags = {
    .votes = @"votes"
};

struct JivePollAttributes const JivePollAttributes = {
	.categories = @"categories",
	.options = @"options",
	.users = @"users",
    .visibility = @"visibility",
	.voteCount = @"voteCount",
	.votes = @"votes",
    .optionsImages = @"optionsImages",
};


@implementation JivePoll

@synthesize categories, options, visibility, voteCount, votes, optionsImages;

NSString * const JivePollType = @"poll";
NSString * const JivePollOptionsImagesOptionKey = @"option";
NSString * const JivePollOptionsImagesImageKey = @"image";


+ (void)load {
    if (self == [JivePoll class])
        [super registerClass:self forType:JivePollType];
}

- (NSString *)type {
    return JivePollType;
}

- (BOOL)deserializeKey:(NSString *)key fromJSON:(id)JSON fromInstance:(Jive *)jiveInstance {
    
    if (![key isEqualToString:JivePollAttributes.optionsImages]) {
        return [super deserializeKey:key fromJSON:JSON fromInstance:jiveInstance];
    }
    
    NSMutableDictionary *mutableOptionsImages = [NSMutableDictionary new];
    
    NSArray *imageList = [JSON objectForKey:JivePollAttributes.optionsImages];
    
    for (NSDictionary *imageOptionItem in imageList) {
        NSString *option = [imageOptionItem objectForKey:JivePollOptionsImagesOptionKey];
        NSDictionary *imageJson = [imageOptionItem objectForKey:JivePollOptionsImagesImageKey];
        
        JiveImage *image = [JiveImage objectFromJSON:imageJson withInstance:jiveInstance];
        
        [mutableOptionsImages setObject:image forKey:option];
    }
    
    [self setValue:[NSDictionary dictionaryWithDictionary:mutableOptionsImages] forKey:JivePollAttributes.optionsImages];
    return YES;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:voteCount forKey:JivePollAttributes.voteCount];
    [dictionary setValue:visibility forKey:JivePollAttributes.visibility];
    if (categories)
        [dictionary setValue:categories forKey:JivePollAttributes.categories];
    
    if (options)
        [dictionary setValue:options forKey:JivePollAttributes.options];
    
    if (votes)
        [dictionary setValue:votes forKey:JivePollAttributes.votes];
    
    if (optionsImages) {
        NSMutableArray *mutableOptionsImageArray = [NSMutableArray new];
        for (NSString *optionKey in [optionsImages keyEnumerator]) {
            NSMutableDictionary *mutableImageRecord = [NSMutableDictionary new];
            [mutableImageRecord setObject:optionKey forKey:JivePollOptionsImagesOptionKey];
            
            JiveImage *image = [optionsImages objectForKey:optionKey];
            
            [mutableImageRecord setObject:[image toJSONDictionary] forKey:JivePollOptionsImagesImageKey];
            [mutableOptionsImageArray addObject:[NSDictionary dictionaryWithDictionary:mutableImageRecord]];
        }
        [dictionary setValue:[NSArray arrayWithArray:mutableOptionsImageArray] forKey:JivePollAttributes.optionsImages];
    }
    
    
    return dictionary;
}

-(BOOL)canVote {
    // A poll cannot be voted on twice.
    return ![self hasVoted] && [self resourceHasPostForTag:JivePollResourceTags.votes];
}

//! Whether the user has voted on this poll
-(BOOL)hasVoted {
    return [self.votes count] > 0;
}



@end
