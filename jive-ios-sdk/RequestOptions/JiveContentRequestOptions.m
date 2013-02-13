//
//  JiveContentRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
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

#import "JiveContentRequestOptions.h"

@implementation JiveContentRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    
    if (self.authors) {
        NSString *components = [self.authors componentsJoinedByString:@","];
        
        [filter addObject:[NSString stringWithFormat:@"author(%@)", components]];
    }
    
    if (self.place)
        [filter addObject:[NSString stringWithFormat:@"place(%@)", [self.place absoluteString]]];
    
    return filter;
}

- (void)addAuthor:(NSURL *)url {
    
    if (!self.authors)
        self.authors = [NSArray arrayWithObject:url];
    else
        self.authors = [self.authors arrayByAddingObject:url];
}

@end
