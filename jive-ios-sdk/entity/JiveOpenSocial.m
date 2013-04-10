//
//  JiveOpenSocial.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

#import "JiveOpenSocial.h"
#import "JiveEmbedded.h"
#import "JiveActionLink.h"
#import "JiveObject_internal.h"

@implementation JiveOpenSocial

@synthesize actionLinks, deliverTo, embed;

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:@"actionLinks"]) {
        return [JiveActionLink class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [self addArrayElements:actionLinks toJSONDictionary:dictionary forTag:@"actionLinks"];
    if (embed)
        [dictionary setValue:[embed toJSONDictionary] forKey:@"embed"];
    
    if (deliverTo)
        [dictionary setValue:[deliverTo copy] forKey:@"deliverTo"];
    
    return dictionary;
}

@end
