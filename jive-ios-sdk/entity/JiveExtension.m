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

struct JiveExtensionAttributes const JiveExtensionAttributes = {
	.collection = @"collection",
    .collectionUpdated = @"collectionUpdated",
    .display = @"display",
    .parent = @"parent",
    .read = @"read",
    .state = @"state",
    .update = @"update",
    .updateCollection = @"updateCollection",
    .collectionRead = @"collectionRead",
    .outcomeTypeName = @"outcomeTypeName",
    .question = @"question",
    .resolved = @"resolved",
    .answer = @"answer",
    .productIcon = @"productIcon",
    .parentLikeCount = @"parentLikeCount",
    .parentReplyCount = @"parentReplyCount",
    .replyCount = @"replyCount",
    .likeCount = @"likeCount",
    .liked = @"liked",
    .parentLiked = @"parentLiked",
    .parentActor = @"parentActor",
    .parentOnBehalfOf = @"parentOnBehalfOf",
    .onBehalfOf = @"onBehalfOf",
    .canReply = @"canReply",
    .canComment = @"canComment",
};

@implementation JiveExtension

@synthesize collection, collectionUpdated, display, parent, read, state, update, updateCollection, collectionRead, outcomeTypeName, question, resolved, answer, productIcon, parentLikeCount, parentReplyCount, replyCount, likeCount, liked, parentLiked, parentActor, parentOnBehalfOf, onBehalfOf, canReply, canComment;
@synthesize imagesCount;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:collection forKey:JiveExtensionAttributes.collection];
    [dictionary setValue:display forKey:JiveExtensionAttributes.display];
    [dictionary setValue:[updateCollection absoluteString] forKey:JiveExtensionAttributes.updateCollection];
    [dictionary setValue:state forKey:JiveExtensionAttributes.state];
    
    if (outcomeTypeName) {
        [dictionary setValue:outcomeTypeName forKey:JiveExtensionAttributes.outcomeTypeName];
    }
    [dictionary setValue:question forKey:JiveExtensionAttributes.question];
    [dictionary setValue:resolved forKey:JiveExtensionAttributes.resolved];
    if (answer) {
        [dictionary setValue:[answer absoluteString] forKey:JiveExtensionAttributes.answer];
    }
    
    if (productIcon) {
        [dictionary setValue:[productIcon absoluteString] forKey:JiveExtensionAttributes.productIcon];
    }
    
    if(parentReplyCount) {
        [dictionary setValue:parentReplyCount forKey:JiveExtensionAttributes.parentReplyCount];
    }
    
    if(parentLikeCount) {
        [dictionary setValue:parentLikeCount forKey:JiveExtensionAttributes.parentLikeCount];
    }
    
    if(replyCount) {
        [dictionary setValue:replyCount forKey:JiveExtensionAttributes.replyCount];
    }
    
    if(likeCount) {
        [dictionary setValue:likeCount forKey:JiveExtensionAttributes.likeCount];
    }
    
    [dictionary setValue:[NSNumber numberWithBool:liked] forKey:JiveExtensionAttributes.liked];
    [dictionary setValue:[NSNumber numberWithBool:parentLiked] forKey:JiveExtensionAttributes.parentLiked];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    if (collectionUpdated)
        [dictionary setValue:[dateFormatter stringFromDate:collectionUpdated] forKey:JiveExtensionAttributes.collectionUpdated];
    if (parent)
        [dictionary setValue:[parent persistentJSON] forKey:JiveExtensionAttributes.parent];
    [dictionary setValue:read forKey:JiveExtensionAttributes.read];
    [dictionary setValue:[update absoluteString] forKey:JiveExtensionAttributes.update];
    
    if (parentActor)
        [dictionary setValue:[parentActor persistentJSON] forKey:JiveExtensionAttributes.parentActor];
    
    if (parentOnBehalfOf)
        [dictionary setValue:[parentOnBehalfOf persistentJSON] forKey:JiveExtensionAttributes.parentOnBehalfOf];
    
    if (onBehalfOf)
        [dictionary setValue:[onBehalfOf persistentJSON] forKey:JiveExtensionAttributes.onBehalfOf];
    
    return dictionary;
}

@end
