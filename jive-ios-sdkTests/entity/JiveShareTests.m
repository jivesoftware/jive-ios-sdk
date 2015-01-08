//
//  JiveShareTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/26/13.
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

#import "JiveShareTests.h"

@implementation JiveShareTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveShare alloc] init];
}

- (JiveShare *)share {
    return (JiveShare *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.share.type, @"share", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.share.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.share class], @"Share class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.share class], @"Share class not registered with JiveContent.");
}

- (void)testShareToJSON {
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    NSDictionary *JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"share", @"Wrong type");
    
    sharedPlace.jiveDescription = @"Going places";
    sharedContent.subject = @"What to do when you get there.";
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    
    JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.share.type, @"Wrong type");
    
    NSDictionary *itemJSON = [JSON objectForKey:JiveShareAttributes.sharedContent];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveContentAttributes.subject], sharedContent.subject, @"Wrong description");
    
    itemJSON = [JSON objectForKey:JiveShareAttributes.sharedPlace];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"description"], sharedPlace.jiveDescription, @"Wrong description");
}

- (void)testShareToJSON_alternate {
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    
    sharedPlace.jiveDescription = @"Rock solid";
    sharedContent.subject = @"What to do in Denver when you're dead.";
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    
    NSDictionary *JSON = [self.share toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.share.type, @"Wrong type");
    
    NSDictionary *itemJSON = [JSON objectForKey:JiveShareAttributes.sharedContent];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:JiveContentAttributes.subject], sharedContent.subject, @"Wrong description");
    
    itemJSON = [JSON objectForKey:JiveShareAttributes.sharedPlace];
    STAssertEquals([itemJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([itemJSON objectForKey:@"description"], sharedPlace.jiveDescription, @"Wrong description");
}

- (void)testShareParsing {
    JivePerson *participant = [JivePerson new];
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    
    participant.status = @"Doing fine";
    sharedPlace.jiveDescription = @"Going places";
    sharedContent.subject = @"What to do when you get there.";
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    
    id JSON = [self.share toJSONDictionary];
    JiveShare *newContent = [JiveShare objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.share class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.share.type, @"Wrong type");
    if ([newContent.sharedContent isKindOfClass:[JiveContent class]]) {
        STAssertEqualObjects(((JiveContent *)newContent.sharedContent).subject, ((JiveContent *)self.share.sharedContent).subject, @"Wrong shared content");
    }
    STAssertEqualObjects(newContent.sharedPlace.jiveDescription, self.share.sharedPlace.jiveDescription, @"Wrong shared place");
}

- (void)testShareParsingAlternate {
    JivePerson *participant = [JivePerson new];
    JivePlace *sharedPlace = [JivePlace new];
    JiveContent *sharedContent = [JiveContent new];
    
    participant.status = @"Twisting and Turning";
    sharedPlace.jiveDescription = @"Rock solid";
    sharedContent.subject = @"What to do in Denver when you're dead.";
    [self.share setValue:sharedContent forKey:JiveShareAttributes.sharedContent];
    [self.share setValue:sharedPlace forKey:JiveShareAttributes.sharedPlace];
    
    id JSON = [self.share toJSONDictionary];
    JiveShare *newContent = [JiveShare objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.share class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.share.type, @"Wrong type");
    if ([newContent.sharedContent isKindOfClass:[JiveContent class]]) {
        STAssertEqualObjects(((JiveContent *)newContent.sharedContent).subject, ((JiveContent *)self.share.sharedContent).subject, @"Wrong shared content");
    }
    STAssertEqualObjects(newContent.sharedPlace.jiveDescription, self.share.sharedPlace.jiveDescription, @"Wrong shared place");
}

@end
