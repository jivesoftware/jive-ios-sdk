//
//  JiveUpdate.m
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

#import "JiveUpdate.h"
#import "JiveTypedObject_internal.h"


struct JiveUpdateAttributes const JiveUpdateAttributes = {
	.latitude = @"latitude",
	.longitude = @"longitude",
	.visibility = @"visibility",
    .repost = @"repost",
    
	.tags = @"tags",
	.visibleToExternalContributors = @"visibleToExternalContributors",
};


@implementation JiveUpdate

@synthesize latitude, longitude, visibility, repost;

NSString * const JiveUpdateType = @"update";

+ (void)load {
    if (self == [JiveUpdate class])
        [super registerClass:self forType:JiveUpdateType];
}

- (NSString *)type {
    return JiveUpdateType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:visibility forKey:JiveUpdateAttributes.visibility];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:latitude forKey:JiveUpdateAttributes.latitude];
    [dictionary setValue:longitude forKey:JiveUpdateAttributes.longitude];
    if (repost)
        [dictionary setValue:[repost persistentJSON] forKey:JiveUpdateAttributes.repost];
    
    return dictionary;
}

@end
