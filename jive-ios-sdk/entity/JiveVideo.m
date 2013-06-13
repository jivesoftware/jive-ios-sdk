//
//  JiveVideo.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/20/13.
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

#import "JiveVideo.h"
#import "JiveTypedObject_internal.h"

struct JiveVideoAttributes const JiveVideoAttributes = {
    .authtoken = @"authtoken",
    .externalID = @"externalID",
    .playerBaseURL = @"playerBaseURL",
    .width = @"width",
    .height = @"height",
};

@implementation JiveVideo

@synthesize tags, visibleToExternalContributors, externalID, playerBaseURL, width, height, authtoken;

NSString * const JiveVideoType = @"video";

+ (void)load {
    if (self == [JiveVideo class])
        [super registerClass:self forType:JiveVideoType];
}

- (NSString *)type {
    return JiveVideoType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if(authtoken)
        [dictionary setValue:authtoken forKey:JiveVideoAttributes.authtoken];
    
    if(width)
        [dictionary setValue:width forKey:JiveVideoAttributes.width];
    
    if(height)
        [dictionary setValue:height forKey:JiveVideoAttributes.height];
    
    if(externalID)
        [dictionary setValue:externalID forKey:JiveVideoAttributes.externalID];
    
    if(playerBaseURL)
        [dictionary setValue:playerBaseURL forKey:JiveVideoAttributes.playerBaseURL];
    
    return dictionary;
}

@end
