//
//  JiveInboxOptions.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
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

#import "JiveInboxOptions.h"


NSString * const JiveAcclaimInboxType = @"acclaim";

struct JiveInboxOptionsDirectives const JiveInboxOptionsDirectives = {
    .include_rtc = @"include_rtc"
};


@implementation JiveInboxOptions

- (NSString *)createOrAppend:(NSString *)nextFilter toFilter:(NSString *)filter {
    if (!filter) {
        return nextFilter;
    }
    
    return [filter stringByAppendingString:nextFilter];
}

- (NSString *)toQueryString {
    
    NSString *const elementSeparator = @",";
    NSString *superQuery = [super toQueryString];
    NSMutableArray *queries = [NSMutableArray new];
    
    if ([superQuery length] > 0) {
        [queries addObject:superQuery];
    }
    
    if (self.unread) {
        [queries addObject:@"filter=unread"];
    }
    
    if ([self.authorID length] > 0) {
        [queries addObject:[NSString stringWithFormat:@"filter=author(/people/%@)", self.authorID]];
    } else if (self.authorURL) {
        [queries addObject:[NSString stringWithFormat:@"filter=author(%@)", self.authorURL]];
    }
    
    if ([self.types count] > 0) {
        [queries addObject:[NSString stringWithFormat:@"filter=type(%@)",
                            [self.types componentsJoinedByString:elementSeparator]]];
    }
    
    NSArray *directives = self.directives;
    
    if ([self.collapseSkipCollectionIDs count] > 0) {
        NSString *collections = [self.collapseSkipCollectionIDs componentsJoinedByString:elementSeparator];
        
        directives = [self addElement:[NSString stringWithFormat:@"collapseSkip(%@)", collections]
                              toArray:directives];
    }
    
    if ([directives count] > 0) {
        [queries addObject:[NSString stringWithFormat:@"directive=%@",
                            [directives componentsJoinedByString:elementSeparator]]];
    }
    
    if (self.oldestUnread) {
        [queries addObject:@"oldestUnread=true"];
    }
    
    return [queries count] > 0 ? [queries componentsJoinedByString:@"&"] : nil;
}

- (void)addType:(NSString *)type {
    if ([type length] > 0) {
        self.types = [self addElement:type toArray:self.types];
    }
}

- (NSArray *)addElement:(NSString *)directive toArray:(NSArray *)targetArray {
    if (!targetArray) {
        targetArray = @[directive];
    } else if (![targetArray containsObject:directive]) {
        targetArray = [targetArray arrayByAddingObject:directive];
    }
    
    return targetArray;
}

- (void)addDirective:(NSString *)directive {
    if ([directive length] > 0) {
        self.directives = [self addElement:directive toArray:self.directives];
    }
}

- (void)addCollectionID:(NSString *)collectionID {
    if ([collectionID length] > 0) {
        self.collapseSkipCollectionIDs = [self addElement:collectionID
                                                  toArray:self.collapseSkipCollectionIDs];
    }
}

@end
