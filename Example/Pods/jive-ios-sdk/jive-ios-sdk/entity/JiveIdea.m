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
    .authors = @"authors",
    .authorship = @"authorship",
    .authorshipPolicy = @"authorshipPolicy",
    .categories = @"categories",
    .commentCount = @"commentCount",
    .score = @"score",
    .stage = @"stage",
    .users = @"users",
    .visibility = @"visibility",
    .voteCount = @"voteCount",
    .voted = @"voted"
};

struct JiveIdeaAuthorshipPolicy const JiveIdeaAuthorshipPolicy = {
    .open = @"open",
    .single = @"single",
    .multiple = @"multiple"
};


@implementation JiveIdea

@synthesize authors, authorshipPolicy, authorship, categories, commentCount, score, stage, users;
@synthesize visibility, voted, voteCount;

NSString * const JiveIdeaType = @"idea";

+ (void)load {
    if (self == [JiveIdea class])
        [super registerClass:self forType:JiveIdeaType];
}

- (NSString *)type {
    return JiveIdeaType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveIdeaAttributes.authors] ||
        [propertyName isEqualToString:JiveIdeaAttributes.users]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:authorship forKeyPath:JiveIdeaAttributes.authorship];
    [dictionary setValue:visibility forKeyPath:JiveIdeaAttributes.visibility];
    [self addArrayElements:authors toJSONDictionary:dictionary forTag:JiveIdeaAttributes.authors];
    if (categories)
        [dictionary setValue:categories forKeyPath:JiveIdeaAttributes.categories];
    
    if (users.count > 0 && [[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]])
        [dictionary setValue:users forKey:JiveIdeaAttributes.users];
    else
        [self addArrayElements:users toJSONDictionary:dictionary forTag:JiveIdeaAttributes.users];
    
    return dictionary;
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
