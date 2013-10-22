//
//  JiveAssociationsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
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

#import "JiveAssociationsRequestOptions.h"

@implementation JiveAssociationsRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filterArray = [NSMutableArray array];
    
    if (self.types) {
        NSString *tagString = [self.types componentsJoinedByString:@","];
        
        [filterArray addObject:[NSString stringWithFormat:@"type(%@)", tagString]];
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

- (void)addType:(NSString *)newType {
    if (!self.types)
        self.types = [NSArray arrayWithObject:newType];
    else
        self.types = [self.types arrayByAddingObject:newType];
}

@end
