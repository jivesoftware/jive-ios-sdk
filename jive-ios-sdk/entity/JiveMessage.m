//
//  JiveMessage.m
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

#import "JiveMessage.h"
#import "JiveAttachment.h"

@implementation JiveMessage

@synthesize answer, attachments, discussion, helpful, tags, visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"message";
    }
    
    return self;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:@"attachments"]) {
        return [JiveAttachment class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:answer forKey:@"answer"];
    [dictionary setValue:helpful forKey:@"helpful"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    [dictionary setValue:discussion forKey:@"discussion"];
    [self addArrayElements:attachments toJSONDictionary:dictionary forTag:@"attachments"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    return dictionary;
}

@end
