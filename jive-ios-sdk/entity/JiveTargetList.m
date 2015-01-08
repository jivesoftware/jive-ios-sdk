//
//  JiveTargetList.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/15/13.
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

#import "JiveTargetList_internal.h"
#import "JiveResourceEntry.h"
#import "JiveNSString+URLArguments.h"

@implementation JiveTargetList

- (NSArray *)toJSONArray:(BOOL)restricted {
    if (restricted)
        return personURIs ? [NSArray arrayWithArray:personURIs] : nil;

    if (personURIs)
        return [personURIs arrayByAddingObjectsFromArray:alternateIdentifiers];
    
    return alternateIdentifiers ? [NSArray arrayWithArray:alternateIdentifiers] : nil;
}

- (void)addPerson:(JivePerson *)person {
    [self addPersonURI:[person.selfRef absoluteString]];
}

- (void)addEmailAddress:(NSString *)emailAddress {
    if (!alternateIdentifiers)
        alternateIdentifiers = [NSMutableArray arrayWithCapacity:1];
    
    [alternateIdentifiers addObject:[emailAddress jive_stringByEscapingForURLArgument]];
}

- (void)addUserName:(NSString *)userName {
    if (!alternateIdentifiers)
        alternateIdentifiers = [NSMutableArray arrayWithCapacity:1];
    
    [alternateIdentifiers addObject:[userName jive_stringByEscapingForURLArgument]];
}

- (void)addPersonURI:(NSString *)uri {
    if (!personURIs)
        personURIs = [NSMutableArray arrayWithCapacity:1];
    
    [personURIs addObject:uri];
}

@end
