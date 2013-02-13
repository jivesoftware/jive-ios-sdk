//
//  JiveFilterTagsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
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

#import "JiveFilterTagsRequestOptions.h"
#import "JiveNSString+URLArguments.h"

@implementation JiveFilterTagsRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filterArray = [NSMutableArray array];
    
    if (self.tags) {
        NSMutableArray *encodedTags = [NSMutableArray arrayWithCapacity:self.tags.count];
        
        for (NSString *tag in self.tags) {
            [encodedTags addObject:[tag jive_stringByEscapingForURLArgument]];
        }
        
        NSString *tagString = [encodedTags componentsJoinedByString:@","];
        
        [filterArray addObject:[NSString stringWithFormat:@"tag(%@)", tagString]];
    }

    return filterArray;
}

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    NSMutableArray *filter = [self buildFilter];
    
    if ([filter count] == 0)
        return query;
    
    NSString *filterString = [filter componentsJoinedByString:@"&filter="];
    
    if (!query)
        return [NSString stringWithFormat:@"filter=%@", filterString];
    
    return [query stringByAppendingFormat:@"&filter=%@", filterString];
}

- (void)addTag:(NSString *)tag {
    
    if (!self.tags)
        self.tags = [NSArray arrayWithObject:tag];
    else
        self.tags = [self.tags arrayByAddingObject:tag];
}

@end
