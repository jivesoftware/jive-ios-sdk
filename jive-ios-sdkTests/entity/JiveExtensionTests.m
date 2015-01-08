//
//  JiveExtensionTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
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
#import "JiveObject_internal.h"

#import "JiveObjectTests.h"


@interface JiveExtensionTests : JiveObjectTests

@property (nonatomic, readonly) JiveExtension *extension;

@end


@implementation JiveExtensionTests

- (void)setUp {
    [super setUp];
    self.object = [JiveExtension new];
}

- (JiveExtension *)extension {
    return (JiveExtension *)self.object;
}

- (void)initializeExtension {
    JiveActivityObject *parent = [JiveActivityObject new];
    JiveActivityObject *parentActor = [JiveActivityObject new];
    JiveActivityObject *mentioned = [JiveActivityObject new];
    JiveGenericPerson *onBehalfOf = [JiveGenericPerson new];
    JiveGenericPerson *parentOnBehalfOf = [JiveGenericPerson new];
    JiveVia *via = [JiveVia new];
    JivePerson *personOnBehalfOf = [JivePerson new];
    
    onBehalfOf.email = @"behalf@email.com";
    [personOnBehalfOf setValue:@"person" forKey:JivePersonAttributes.displayName];
    [parentOnBehalfOf setValue:personOnBehalfOf forKey:JiveGenericPersonAttributes.person];
    
    mentioned.jiveId = @"87654";
    [mentioned setValue:@YES forKey:@"canComment"];
    parent.jiveId = @"3456";
    [parent setValue:@YES forKey:@"canReply"];
    parentActor.jiveId = @"13579";
    [parentActor setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    via.displayName = @"via name";
    
    [self.extension setValue:[NSURL URLWithString:@"http://answer.com"]
                      forKey:JiveExtensionAttributes.answer];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canComment];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canLike];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canReply];
    [self.extension setValue:@"text" forKey:JiveExtensionAttributes.collection];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.collectionRead];
    [self.extension setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                      forKey:JiveExtensionAttributes.collectionUpdated];
    self.extension.display = @"1234";
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.followingInStream];
    [self.extension setValue:@"icon style" forKey:JiveExtensionAttributes.iconCss];
    [self.extension setValue:@5 forKey:JiveExtensionAttributes.likeCount];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.liked];
    [self.extension setValue:mentioned forKey:JiveExtensionAttributes.mentioned];
    [self.extension setValue:@345 forKey:JiveExtensionAttributes.objectID];
    [self.extension setValue:@2 forKey:JiveExtensionAttributes.objectType];
    self.extension.onBehalfOf = onBehalfOf;
    [self.extension setValue:@"comment" forKey:JiveExtensionAttributes.outcomeComment];
    [self.extension setValue:@"outcome" forKey:JiveExtensionAttributes.outcomeTypeName];
    [self.extension setValue:parent forKey:JiveExtensionAttributes.parent];
    [self.extension setValue:parentActor forKey:JiveExtensionAttributes.parentActor];
    [self.extension setValue:@7 forKey:JiveExtensionAttributes.parentLikeCount];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.parentLiked];
    self.extension.parentOnBehalfOf = parentOnBehalfOf;
    [self.extension setValue:@3 forKey:JiveExtensionAttributes.parentReplyCount];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.question];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.read];
    [self.extension setValue:@6 forKey:JiveExtensionAttributes.replyCount];
    [self.extension setValue:@"open" forKey:JiveExtensionAttributes.resolved];
    self.extension.state = @"state";
    [self.extension setValue:[NSURL URLWithString:@"http://dummy.com"]
                      forKey:JiveExtensionAttributes.update];
    [self.extension setValue:[NSURL URLWithString:@"http://collection.com"]
                      forKey:JiveExtensionAttributes.updateCollection];
    self.extension.via = via;
    [self.extension setValue:[NSURL URLWithString:@"http://productIcon.com"]
                      forKey:JiveExtensionAttributes.productIcon];
    [self.extension setValue:@33 forKey:JiveExtensionAttributes.imagesCount];
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.objectViewed];
}

- (void)alternateInitializeExtension {
    JiveActivityObject *parent = [JiveActivityObject new];
    JiveActivityObject *parentActor = [JiveActivityObject new];
    JiveActivityObject *mentioned = [JiveActivityObject new];
    JiveGenericPerson *onBehalfOf = [JiveGenericPerson new];
    JiveGenericPerson *parentOnBehalfOf = [JiveGenericPerson new];
    JiveVia *via = [JiveVia new];
    JivePerson *personOnBehalfOf = [JivePerson new];
    
    [personOnBehalfOf setValue:@"person" forKey:JivePersonAttributes.displayName];
    [onBehalfOf setValue:personOnBehalfOf forKey:JiveGenericPersonAttributes.person];
    parentOnBehalfOf.email = @"trombone@email.com";
    
    mentioned.jiveId = @"12345";
    [mentioned setValue:@YES forKey:@"canReply"];
    parent.jiveId = @"3456";
    [parent setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    parentActor.jiveId = @"2468";
    [parentActor setValue:@YES forKey:@"canComment"];
    via.displayName = @"gang busters";
    
    [self.extension setValue:[NSURL URLWithString:@"http://question.com"]
                      forKey:JiveExtensionAttributes.answer];
    [self.extension setValue:@"html" forKey:JiveExtensionAttributes.collection];
    [self.extension setValue:[NSDate dateWithTimeIntervalSince1970:0]
                      forKey:JiveExtensionAttributes.collectionUpdated];
    self.extension.display = @"6541";
    [self.extension setValue:@"wrong style" forKey:JiveExtensionAttributes.iconCss];
    [self.extension setValue:@6 forKey:JiveExtensionAttributes.likeCount];
    [self.extension setValue:mentioned forKey:JiveExtensionAttributes.mentioned];
    [self.extension setValue:@543 forKey:JiveExtensionAttributes.objectID];
    [self.extension setValue:@1 forKey:JiveExtensionAttributes.objectType];
    self.extension.onBehalfOf = onBehalfOf;
    [self.extension setValue:@"outcome" forKey:JiveExtensionAttributes.outcomeComment];
    [self.extension setValue:@"type name" forKey:JiveExtensionAttributes.outcomeTypeName];
    [self.extension setValue:parent forKey:JiveExtensionAttributes.parent];
    [self.extension setValue:parentActor forKey:JiveExtensionAttributes.parentActor];
    [self.extension setValue:@4 forKey:JiveExtensionAttributes.parentLikeCount];
    self.extension.parentOnBehalfOf = parentOnBehalfOf;
    [self.extension setValue:@8 forKey:JiveExtensionAttributes.parentReplyCount];
    [self.extension setValue:@60 forKey:JiveExtensionAttributes.replyCount];
    [self.extension setValue:@"resolved" forKey:JiveExtensionAttributes.resolved];
    self.extension.state = @"loco";
    [self.extension setValue:[NSURL URLWithString:@"http://super.com"]
                      forKey:JiveExtensionAttributes.update];
    [self.extension setValue:[NSURL URLWithString:@"http://update.com"]
                      forKey:JiveExtensionAttributes.updateCollection];
    self.extension.via = via;
    [self.extension setValue:[NSURL URLWithString:@"http://underworld.com"]
                      forKey:JiveExtensionAttributes.productIcon];
    [self.extension setValue:@3 forKey:JiveExtensionAttributes.imagesCount];
}

- (void)testBoolProperties {
    NSDictionary *JSON = [self.extension persistentJSON];
    NSUInteger propertyCount = 0;
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], propertyCount, @"Initial dictionary is not empty");
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canComment];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.canComment] boolValue],
                   [self.extension commentAllowed], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canLike];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.canLike] boolValue],
                   [self.extension likeAllowed], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.canReply];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.canReply] boolValue],
                   [self.extension replyAllowed], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.collectionRead];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.collectionRead] boolValue],
                   [self.extension isCollectionRead], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.followingInStream];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.followingInStream] boolValue],
                   [self.extension isFollowingInStream], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.liked];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.liked] boolValue],
                   [self.extension isLiked], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.parentLiked];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.parentLiked] boolValue],
                   [self.extension isParentLiked], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.question];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.question] boolValue],
                   [self.extension isQuestion], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.read];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.read] boolValue],
                   [self.extension isRead], nil);
    
    [self.extension setValue:@YES forKey:JiveExtensionAttributes.objectViewed];
    JSON = [self.extension persistentJSON];
    STAssertEquals([JSON count], ++propertyCount, nil);
    STAssertEquals([JSON[JiveExtensionAttributes.objectViewed] boolValue],
                   [self.extension hasBeenViewed], nil);
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.extension persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeExtension];
    JSON = [self.extension persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)35, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveExtensionAttributes.answer],
                         [self.extension.answer absoluteString], nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.canComment], self.extension.canComment, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.canLike], self.extension.canLike, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.canReply], self.extension.canReply, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.collection], self.extension.collection, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.collectionRead], self.extension.collectionRead, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.collectionUpdated],
                         @"1970-01-01T00:16:40.123+0000", nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.display], self.extension.display, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.followingInStream],
                         self.extension.followingInStream, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.iconCss], self.extension.iconCss, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.likeCount], self.extension.likeCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.liked], self.extension.liked, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.objectID], self.extension.objectID, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.objectType], self.extension.objectType, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.outcomeComment], self.extension.outcomeComment, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.outcomeTypeName],
                         self.extension.outcomeTypeName, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.parentLikeCount],
                         self.extension.parentLikeCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.parentLiked], self.extension.parentLiked, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.parentReplyCount],
                         self.extension.parentReplyCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.question], self.extension.question, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.read], self.extension.read, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.replyCount], self.extension.replyCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.resolved], self.extension.resolved, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.state], self.extension.state, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.update],
                         [self.extension.update absoluteString], nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.updateCollection],
                         [self.extension.updateCollection absoluteString], nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.productIcon],
                         [self.extension.productIcon absoluteString], nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.imagesCount], self.extension.imagesCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.objectViewed], self.extension.objectViewed, nil);
    
    NSDictionary *mentionedJSON = JSON[JiveExtensionAttributes.mentioned];
    
    STAssertTrue([[mentionedJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([mentionedJSON count], (NSUInteger)2, nil);
    STAssertEqualObjects(mentionedJSON[JiveObjectConstants.id], self.extension.mentioned.jiveId, nil);
    STAssertEqualObjects(mentionedJSON[@"canComment"], @YES, nil);
    
    NSDictionary *onBehalfOfJSON = JSON[JiveExtensionAttributes.onBehalfOf];
    
    STAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.onBehalfOf.email, @"Wrong value");
    
    NSDictionary *parentJSON = JSON[JiveExtensionAttributes.parent];
    
    STAssertTrue([[parentJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([parentJSON count], (NSUInteger)2, nil);
    STAssertEqualObjects(parentJSON[JiveObjectConstants.id], self.extension.parent.jiveId, nil);
    STAssertEqualObjects(parentJSON[@"canReply"], @YES, nil);
    
    NSDictionary *parentActorJSON = JSON[JiveExtensionAttributes.parentActor];
    
    STAssertTrue([[parentActorJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([parentActorJSON count], (NSUInteger)2, nil);
    STAssertEqualObjects(parentActorJSON[JiveObjectConstants.id], self.extension.parentActor.jiveId, nil);
    STAssertEqualObjects(parentActorJSON[@"updated"], @"1970-01-01T00:00:00.000+0000", nil);
    
    NSDictionary *parentOnBehalfOfJSON = JSON[JiveExtensionAttributes.parentOnBehalfOf];
    
    STAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentOnBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(parentOnBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.parentOnBehalfOf.email, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveExtensionAttributes.via];
    
    STAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([viaJSON count], (NSUInteger)1, nil);
    STAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.extension.via.displayName, nil);
}

- (void)testPersistentJSON_alternate {
    [self alternateInitializeExtension];
    
    NSDictionary *JSON = [self.extension persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)25, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveExtensionAttributes.answer],
                         [self.extension.answer absoluteString], nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.canComment], self.extension.canComment, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.canLike], self.extension.canLike, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.canReply], self.extension.canReply, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.collection], self.extension.collection, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.collectionRead], self.extension.collectionRead, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.collectionUpdated],
                         @"1970-01-01T00:00:00.000+0000", nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.display], self.extension.display, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.followingInStream],
                         self.extension.followingInStream, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.iconCss], self.extension.iconCss, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.likeCount], self.extension.likeCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.liked], self.extension.liked, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.objectID], self.extension.objectID, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.objectType], self.extension.objectType, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.outcomeComment], self.extension.outcomeComment, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.outcomeTypeName],
                         self.extension.outcomeTypeName, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.parentLikeCount],
                         self.extension.parentLikeCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.parentLiked], self.extension.parentLiked, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.parentReplyCount],
                         self.extension.parentReplyCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.question], self.extension.question, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.read], self.extension.read, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.replyCount], self.extension.replyCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.resolved], self.extension.resolved, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.state], self.extension.state, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.update],
                         [self.extension.update absoluteString], nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.updateCollection],
                         [self.extension.updateCollection absoluteString], nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.productIcon],
                         [self.extension.productIcon absoluteString], nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.imagesCount], self.extension.imagesCount, nil);
    STAssertEqualObjects(JSON[JiveExtensionAttributes.objectViewed], self.extension.objectViewed, nil);
    
    NSDictionary *mentionedJSON = JSON[JiveExtensionAttributes.mentioned];
    
    STAssertTrue([[mentionedJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([mentionedJSON count], (NSUInteger)2, nil);
    STAssertEqualObjects(mentionedJSON[JiveObjectConstants.id], self.extension.mentioned.jiveId, nil);
    STAssertEqualObjects(mentionedJSON[@"canReply"], @YES, nil);
    
    NSDictionary *onBehalfOfJSON = JSON[JiveExtensionAttributes.onBehalfOf];
    
    STAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.onBehalfOf.email, @"Wrong value");
    
    NSDictionary *parentJSON = JSON[JiveExtensionAttributes.parent];
    
    STAssertTrue([[parentJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([parentJSON count], (NSUInteger)2, nil);
    STAssertEqualObjects(parentJSON[JiveObjectConstants.id], self.extension.parent.jiveId, nil);
    STAssertEqualObjects(parentJSON[@"updated"], @"1970-01-01T00:00:00.000+0000", nil);
    
    NSDictionary *parentActorJSON = JSON[JiveExtensionAttributes.parentActor];
    
    STAssertTrue([[parentActorJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([parentActorJSON count], (NSUInteger)2, nil);
    STAssertEqualObjects(parentActorJSON[JiveObjectConstants.id], self.extension.parentActor.jiveId, nil);
    STAssertEqualObjects(parentActorJSON[@"canComment"], @YES, nil);
    
    NSDictionary *parentOnBehalfOfJSON = JSON[JiveExtensionAttributes.parentOnBehalfOf];
    
    STAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentOnBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(parentOnBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.parentOnBehalfOf.email, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveExtensionAttributes.via];
    
    STAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([viaJSON count], (NSUInteger)1, nil);
    STAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.extension.via.displayName, nil);
}

- (void)testToJSON {
    NSDictionary *JSON = [self.extension toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeExtension];
    JSON = [self.extension toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveExtensionAttributes.display], self.extension.display, @"Wrong display.");
    STAssertEqualObjects(JSON[JiveExtensionAttributes.state], self.extension.state, @"Wrong state.");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveExtensionAttributes.onBehalfOf];
    
    STAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(onBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.onBehalfOf.email, @"Wrong value");
    
    NSDictionary *parentOnBehalfOfJSON = JSON[JiveExtensionAttributes.parentOnBehalfOf];
    
    STAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentOnBehalfOfJSON count], (NSUInteger)0, @"Jive dictionary had the wrong number of entries");
    
    NSDictionary *viaJSON = JSON[JiveExtensionAttributes.via];
    
    STAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([viaJSON count], (NSUInteger)1, nil);
    STAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.extension.via.displayName, nil);
}

- (void)testToJSON_alternate {
    [self alternateInitializeExtension];
    
    NSDictionary *JSON = [self.extension toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveExtensionAttributes.display], self.extension.display, @"Wrong display.");
    STAssertEqualObjects(JSON[JiveExtensionAttributes.state], self.extension.state, @"Wrong state.");
    
    NSDictionary *onBehalfOfJSON = JSON[JiveExtensionAttributes.onBehalfOf];
    
    STAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([onBehalfOfJSON count], (NSUInteger)0, @"Jive dictionary had the wrong number of entries");
    
    NSDictionary *parentOnBehalfOfJSON = JSON[JiveExtensionAttributes.parentOnBehalfOf];
    
    STAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentOnBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(parentOnBehalfOfJSON[JiveGenericPersonAttributes.email], self.extension.parentOnBehalfOf.email, @"Wrong value");
    
    NSDictionary *viaJSON = JSON[JiveExtensionAttributes.via];
    
    STAssertTrue([[viaJSON class] isSubclassOfClass:[NSDictionary class]], nil);
    STAssertEquals([viaJSON count], (NSUInteger)1, nil);
    STAssertEqualObjects(viaJSON[JiveViaAttributes.displayName], self.extension.via.displayName, nil);
}

- (void)testExtensionParsing {
    [self initializeExtension];
    
    NSDictionary *JSON = [self.extension persistentJSON];
    JiveExtension *newExtension = [JiveExtension objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEqualObjects([newExtension.answer absoluteString],
                         [self.extension.answer absoluteString], nil);
    STAssertEqualObjects(newExtension.canComment, self.extension.canComment, nil);
    STAssertEqualObjects(newExtension.canLike, self.extension.canLike, nil);
    STAssertEqualObjects(newExtension.canReply, self.extension.canReply, nil);
    STAssertEqualObjects(newExtension.collection, self.extension.collection, nil);
    STAssertEqualObjects(newExtension.collectionRead, self.extension.collectionRead, nil);
    STAssertEqualObjects(newExtension.collectionUpdated, self.extension.collectionUpdated, nil);
    STAssertEqualObjects(newExtension.display, self.extension.display, nil);
    STAssertEqualObjects(newExtension.followingInStream, self.extension.followingInStream, nil);
    STAssertEqualObjects(newExtension.iconCss, self.extension.iconCss, nil);
    STAssertEqualObjects(newExtension.likeCount, self.extension.likeCount, nil);
    STAssertEqualObjects(newExtension.liked, self.extension.liked, nil);
    STAssertEqualObjects(newExtension.mentioned.jiveId, self.extension.mentioned.jiveId, nil);
    STAssertEqualObjects(newExtension.mentioned.canComment, self.extension.mentioned.canComment, nil);
    STAssertEqualObjects(newExtension.mentioned.canReply, self.extension.mentioned.canReply, nil);
    STAssertEqualObjects(newExtension.objectID, self.extension.objectID, nil);
    STAssertEqualObjects(newExtension.objectType, self.extension.objectType, nil);
    STAssertEqualObjects(newExtension.onBehalfOf.email, self.extension.onBehalfOf.email, nil);
    STAssertEqualObjects(newExtension.onBehalfOf.person.displayName,
                         self.extension.onBehalfOf.person.displayName, nil);
    STAssertEqualObjects(newExtension.outcomeComment, self.extension.outcomeComment, nil);
    STAssertEqualObjects(newExtension.outcomeTypeName, self.extension.outcomeTypeName, nil);
    STAssertEqualObjects(newExtension.parent.jiveId, self.extension.parent.jiveId, nil);
    STAssertEqualObjects(newExtension.parent.canReply, self.extension.parent.canReply, nil);
    STAssertEqualObjects(newExtension.parent.updated, self.extension.parent.updated, nil);
    STAssertEqualObjects(newExtension.parentActor.jiveId, self.extension.parentActor.jiveId, nil);
    STAssertEqualObjects(newExtension.parentActor.canComment, self.extension.parentActor.canComment, nil);
    STAssertEqualObjects(newExtension.parentActor.updated, self.extension.parentActor.updated, nil);
    STAssertEqualObjects(newExtension.parentLikeCount, self.extension.parentLikeCount, nil);
    STAssertEqualObjects(newExtension.parentLiked, self.extension.parentLiked, nil);
    STAssertEqualObjects(newExtension.parentOnBehalfOf.email, self.extension.parentOnBehalfOf.email, nil);
    STAssertEqualObjects(newExtension.parentOnBehalfOf.person.displayName,
                         self.extension.parentOnBehalfOf.person.displayName, nil);
    STAssertEqualObjects(newExtension.parentReplyCount, self.extension.parentReplyCount, nil);
    STAssertEqualObjects(newExtension.question, self.extension.question, nil);
    STAssertEqualObjects(newExtension.read, self.extension.read, nil);
    STAssertEqualObjects(newExtension.replyCount, self.extension.replyCount, nil);
    STAssertEqualObjects(newExtension.resolved, self.extension.resolved, nil);
    STAssertEqualObjects(newExtension.state, self.extension.state, nil);
    STAssertEqualObjects([newExtension.update absoluteString],
                         [self.extension.update absoluteString], nil);
    STAssertEqualObjects([newExtension.updateCollection absoluteString],
                         [self.extension.updateCollection absoluteString], nil);
    STAssertEqualObjects(newExtension.via.displayName, self.extension.via.displayName, nil);
    STAssertEqualObjects([newExtension.productIcon absoluteString],
                         [self.extension.productIcon absoluteString], nil);
    STAssertEqualObjects(newExtension.imagesCount, self.extension.imagesCount, nil);
    STAssertEqualObjects(newExtension.objectViewed, self.extension.objectViewed, nil);
}

- (void)testExtensionParsing_alternate {
    [self alternateInitializeExtension];
    
    NSDictionary *JSON = [self.extension persistentJSON];
    JiveExtension *newExtension = [JiveExtension objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEqualObjects([newExtension.answer absoluteString],
                         [self.extension.answer absoluteString], nil);
    STAssertEqualObjects(newExtension.canComment, self.extension.canComment, nil);
    STAssertEqualObjects(newExtension.canLike, self.extension.canLike, nil);
    STAssertEqualObjects(newExtension.canReply, self.extension.canReply, nil);
    STAssertEqualObjects(newExtension.collection, self.extension.collection, nil);
    STAssertEqualObjects(newExtension.collectionRead, self.extension.collectionRead, nil);
    STAssertEqualObjects(newExtension.collectionUpdated, self.extension.collectionUpdated, nil);
    STAssertEqualObjects(newExtension.display, self.extension.display, nil);
    STAssertEqualObjects(newExtension.followingInStream, self.extension.followingInStream, nil);
    STAssertEqualObjects(newExtension.iconCss, self.extension.iconCss, nil);
    STAssertEqualObjects(newExtension.likeCount, self.extension.likeCount, nil);
    STAssertEqualObjects(newExtension.liked, self.extension.liked, nil);
    STAssertEqualObjects(newExtension.mentioned.jiveId, self.extension.mentioned.jiveId, nil);
    STAssertEqualObjects(newExtension.mentioned.canComment, self.extension.mentioned.canComment, nil);
    STAssertEqualObjects(newExtension.mentioned.canReply, self.extension.mentioned.canReply, nil);
    STAssertEqualObjects(newExtension.objectID, self.extension.objectID, nil);
    STAssertEqualObjects(newExtension.objectType, self.extension.objectType, nil);
    STAssertEqualObjects(newExtension.onBehalfOf.email, self.extension.onBehalfOf.email, nil);
    STAssertEqualObjects(newExtension.onBehalfOf.person.displayName,
                         self.extension.onBehalfOf.person.displayName, nil);
    STAssertEqualObjects(newExtension.outcomeComment, self.extension.outcomeComment, nil);
    STAssertEqualObjects(newExtension.outcomeTypeName, self.extension.outcomeTypeName, nil);
    STAssertEqualObjects(newExtension.parent.jiveId, self.extension.parent.jiveId, nil);
    STAssertEqualObjects(newExtension.parent.canReply, self.extension.parent.canReply, nil);
    STAssertEqualObjects(newExtension.parent.updated, self.extension.parent.updated, nil);
    STAssertEqualObjects(newExtension.parentActor.jiveId, self.extension.parentActor.jiveId, nil);
    STAssertEqualObjects(newExtension.parentActor.canComment, self.extension.parentActor.canComment, nil);
    STAssertEqualObjects(newExtension.parentActor.updated, self.extension.parentActor.updated, nil);
    STAssertEqualObjects(newExtension.parentLikeCount, self.extension.parentLikeCount, nil);
    STAssertEqualObjects(newExtension.parentLiked, self.extension.parentLiked, nil);
    STAssertEqualObjects(newExtension.parentOnBehalfOf.email, self.extension.parentOnBehalfOf.email, nil);
    STAssertEqualObjects(newExtension.parentOnBehalfOf.person.displayName,
                         self.extension.parentOnBehalfOf.person.displayName, nil);
    STAssertEqualObjects(newExtension.parentReplyCount, self.extension.parentReplyCount, nil);
    STAssertEqualObjects(newExtension.question, self.extension.question, nil);
    STAssertEqualObjects(newExtension.read, self.extension.read, nil);
    STAssertEqualObjects(newExtension.replyCount, self.extension.replyCount, nil);
    STAssertEqualObjects(newExtension.resolved, self.extension.resolved, nil);
    STAssertEqualObjects(newExtension.state, self.extension.state, nil);
    STAssertEqualObjects([newExtension.update absoluteString],
                         [self.extension.update absoluteString], nil);
    STAssertEqualObjects([newExtension.updateCollection absoluteString],
                         [self.extension.updateCollection absoluteString], nil);
    STAssertEqualObjects(newExtension.via.displayName, self.extension.via.displayName, nil);
    STAssertEqualObjects([newExtension.productIcon absoluteString],
                         [self.extension.productIcon absoluteString], nil);
    STAssertEqualObjects(newExtension.imagesCount, self.extension.imagesCount, nil);
    STAssertEqualObjects(newExtension.objectViewed, self.extension.objectViewed, nil);
}

@end
