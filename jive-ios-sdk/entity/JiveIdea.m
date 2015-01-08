//
//  JiveIdea.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/25/13.
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

#import "JiveIdea.h"
#import "JiveTypedObject_internal.h"


struct JiveIdeaAttributes const JiveIdeaAttributes = {
    .authorshipPolicy = @"authorshipPolicy",
    .commentCount = @"commentCount",
    .score = @"score",
    .stage = @"stage",
    .voteCount = @"voteCount",
    .voted = @"voted",
    
    .authors = @"authors",
    .authorship = @"authorship",
    .categories = @"categories",
    .users = @"users",
    .visibility = @"visibility"
};

struct JiveIdeaAuthorshipPolicy const JiveIdeaAuthorshipPolicy = {
    .open = @"open",
    .single = @"single",
    .multiple = @"multiple"
};


@implementation JiveIdea

@synthesize authorshipPolicy, commentCount, score, stage, voted, voteCount;

NSString * const JiveIdeaType = @"idea";

+ (void)load {
    if (self == [JiveIdea class])
        [super registerClass:self forType:JiveIdeaType];
}

- (NSString *)type {
    return JiveIdeaType;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:authorshipPolicy forKeyPath:JiveIdeaAttributes.authorshipPolicy];
    [dictionary setValue:commentCount forKeyPath:JiveIdeaAttributes.commentCount];
    [dictionary setValue:score forKeyPath:JiveIdeaAttributes.score];
    [dictionary setValue:stage forKeyPath:JiveIdeaAttributes.stage];
    [dictionary setValue:voteCount forKeyPath:JiveIdeaAttributes.voteCount];
    [dictionary setValue:voted forKeyPath:JiveIdeaAttributes.voted];
    
    return dictionary;
}

- (BOOL)didVote {
    return NO;
}

@end
