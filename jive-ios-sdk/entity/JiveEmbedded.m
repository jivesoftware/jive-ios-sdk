//
//  JiveEmbedded.m
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

#import "JiveEmbedded.h"

@implementation JiveEmbedded

@synthesize context, gadget, preferredExperience, previewImage, url;

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property
                                     fromJSON:(id)JSON
                                 fromInstance:(Jive *)jiveInstance {
    return JSON;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:context forKey:@"context"];
    [dictionary setValue:preferredExperience forKey:@"preferredExperience"];
    [dictionary setValue:[gadget absoluteString] forKey:@"gadget"];
    [dictionary setValue:previewImage forKey:@"previewImage"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    
    return dictionary;
}

@end
