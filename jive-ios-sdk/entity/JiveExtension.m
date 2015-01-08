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
#import "JiveVia.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"


struct JiveExtensionAttributes const JiveExtensionAttributes = {
	.collection = @"collection",
    .collectionUpdated = @"collectionUpdated",
    .display = @"display",
    .parent = @"parent",
    .read = @"read",
    .followingInStream = @"followingInStream",
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
    .canLike = @"canLike",
    .iconCss = @"iconCss",
    .mentioned = @"mentioned",
    .objectID = @"objectID",
    .objectType = @"objectType",
    .outcomeComment = @"outcomeComment",
    .via = @"via",
    .imagesCount = @"imagesCount",
    .discovery = @"discovery",
    .objectViewed = @"objectViewed",
};

struct JiveExtensionDisplay const JiveExtensionDisplay = {
	.digest = @"digest",
	.grouped = @"grouped",
	.update = @"update",
};

struct JiveExtensionStateValues const JiveExtensionStateValues = {
    .awaitingAction = @"awaiting_action",
    .accepted = @"accepted",
    .rejected = @"rejected",
    .ignored = @"ignored",
    .hidden = @"hidden"
};


@implementation JiveExtension

@synthesize collection, collectionUpdated, display, parent, read, state, update, updateCollection;
@synthesize collectionRead, outcomeTypeName, question, resolved, answer, productIcon, via;
@synthesize parentLikeCount, parentReplyCount, replyCount, likeCount, liked, parentLiked;
@synthesize parentActor, parentOnBehalfOf, onBehalfOf, canReply, canComment, canLike, iconCss;
@synthesize imagesCount, followingInStream, mentioned, objectID, objectType, outcomeComment;
@synthesize objectViewed;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:display forKey:JiveExtensionAttributes.display];
    [dictionary setValue:state forKey:JiveExtensionAttributes.state];
    if (self.onBehalfOf) {
        [dictionary setValue:[self.onBehalfOf toJSONDictionary]
                      forKey:JiveExtensionAttributes.onBehalfOf];
    }
    
    if (self.parentOnBehalfOf) {
        [dictionary setValue:[self.parentOnBehalfOf toJSONDictionary]
                      forKey:JiveExtensionAttributes.parentOnBehalfOf];
    }
    
    if (self.via) {
        [dictionary setValue:[self.via toJSONDictionary] forKey:JiveExtensionAttributes.via];
    }
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:[answer absoluteString] forKey:JiveExtensionAttributes.answer];
    [dictionary setValue:canComment forKey:JiveExtensionAttributes.canComment];
    [dictionary setValue:canLike forKey:JiveExtensionAttributes.canLike];
    [dictionary setValue:canReply forKey:JiveExtensionAttributes.canReply];
    [dictionary setValue:collection forKey:JiveExtensionAttributes.collection];
    [dictionary setValue:collectionRead forKey:JiveExtensionAttributes.collectionRead];
    [dictionary setValue:followingInStream forKey:JiveExtensionAttributes.followingInStream];
    [dictionary setValue:iconCss forKey:JiveExtensionAttributes.iconCss];
    [dictionary setValue:likeCount forKey:JiveExtensionAttributes.likeCount];
    [dictionary setValue:liked forKey:JiveExtensionAttributes.liked];
    [dictionary setValue:mentioned forKey:JiveExtensionAttributes.mentioned];
    [dictionary setValue:objectID forKey:JiveExtensionAttributes.objectID];
    [dictionary setValue:objectType forKey:JiveExtensionAttributes.objectType];
    [dictionary setValue:objectViewed forKey:JiveExtensionAttributes.objectViewed];
    [dictionary setValue:outcomeComment forKey:JiveExtensionAttributes.outcomeComment];
    [dictionary setValue:outcomeTypeName forKey:JiveExtensionAttributes.outcomeTypeName];
    [dictionary setValue:parentLikeCount forKey:JiveExtensionAttributes.parentLikeCount];
    [dictionary setValue:parentLiked forKey:JiveExtensionAttributes.parentLiked];
    [dictionary setValue:parentReplyCount forKey:JiveExtensionAttributes.parentReplyCount];
    [dictionary setValue:question forKey:JiveExtensionAttributes.question];
    [dictionary setValue:read forKey:JiveExtensionAttributes.read];
    [dictionary setValue:replyCount forKey:JiveExtensionAttributes.replyCount];
    [dictionary setValue:resolved forKey:JiveExtensionAttributes.resolved];
    [dictionary setValue:[update absoluteString] forKey:JiveExtensionAttributes.update];
    [dictionary setValue:[updateCollection absoluteString] forKey:JiveExtensionAttributes.updateCollection];
    [dictionary setValue:[productIcon absoluteString] forKey:JiveExtensionAttributes.productIcon];
    [dictionary setValue:imagesCount forKey:JiveExtensionAttributes.imagesCount];
    if (collectionUpdated) {
        [dictionary setValue:[dateFormatter stringFromDate:collectionUpdated]
                      forKey:JiveExtensionAttributes.collectionUpdated];
    }
    
    if (self.mentioned) {
        [dictionary setValue:[self.mentioned persistentJSON]
                      forKey:JiveExtensionAttributes.mentioned];
    }
    
    if (self.onBehalfOf) {
        [dictionary setValue:[self.onBehalfOf persistentJSON]
                      forKey:JiveExtensionAttributes.onBehalfOf];
    }
    
    if (self.parent) {
        [dictionary setValue:[self.parent persistentJSON]
                      forKey:JiveExtensionAttributes.parent];
    }
    
    if (self.parentActor) {
        [dictionary setValue:[self.parentActor persistentJSON]
                      forKey:JiveExtensionAttributes.parentActor];
    }
    
    if (self.parentOnBehalfOf) {
        [dictionary setValue:[self.parentOnBehalfOf persistentJSON]
                      forKey:JiveExtensionAttributes.parentOnBehalfOf];
    }
    
    return dictionary;
}

- (BOOL)commentAllowed {
    return [self.canComment boolValue];
}

- (BOOL)likeAllowed {
    return [self.canLike boolValue];
}

- (BOOL)replyAllowed {
    return [self.canReply boolValue];
}

- (BOOL)isCollectionRead {
    return [self.collectionRead boolValue];
}

- (BOOL)isFollowingInStream {
    return [self.followingInStream boolValue];
}

- (BOOL)isLiked {
    return [self.liked boolValue];
}

- (BOOL)isParentLiked {
    return [self.parentLiked boolValue];
}

- (BOOL)isQuestion {
    return [self.question boolValue];
}

- (BOOL)isRead {
    return [self.read boolValue];
}

- (BOOL)hasBeenViewed {
    return [self.objectViewed boolValue];
}

@end
