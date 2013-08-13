//
//  JiveExtension.m
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

#import "JiveExtension.h"
#import "JiveActivityObject.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JiveExtension

@synthesize collection, collectionUpdated, display, parent, read, state, update, updateCollection, collectionRead, outcomeTypeName, question, resolved, answer, parentLikeCount, parentReplyCount, replyCount, likeCount, liked, parentLiked;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:collection forKey:@"collection"];
    [dictionary setValue:display forKey:@"display"];
    [dictionary setValue:read forKey:@"read"];
    [dictionary setValue:[update absoluteString] forKey:@"update"];
    [dictionary setValue:[updateCollection absoluteString] forKey:@"updateCollection"];
    [dictionary setValue:state forKey:@"state"];
    if (collectionUpdated)
        [dictionary setValue:[dateFormatter stringFromDate:collectionUpdated] forKey:@"collectionUpdated"];
    
    if (parent)
        [dictionary setValue:[parent toJSONDictionary] forKey:@"parent"];
    
    if (outcomeTypeName) {
        [dictionary setValue:outcomeTypeName forKey:@"outcomeTypeName"];
    }
    [dictionary setValue:question forKey:@"question"];
    [dictionary setValue:resolved forKey:@"resolved"];
    if (answer) {
        [dictionary setValue:[answer absoluteString] forKey:@"answer"];
    }
    
    if(parentReplyCount) {
        [dictionary setValue:parentReplyCount forKey:@"parentReplyCount"];
    }
    
    if(parentLikeCount) {
        [dictionary setValue:parentLikeCount forKey:@"parentLikeCount"];
    }
    
    if(replyCount) {
        [dictionary setValue:replyCount forKey:@"replyCount"];
    }
    
    if(likeCount) {
        [dictionary setValue:likeCount forKey:@"likeCount"];
    }
    
    [dictionary setValue:[NSNumber numberWithBool:liked] forKey:@"liked"];
    [dictionary setValue:[NSNumber numberWithBool:parentLiked] forKey:@"parentLiked"];
    
    return dictionary;
}

@end
