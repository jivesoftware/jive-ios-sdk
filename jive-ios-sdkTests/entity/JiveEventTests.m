//
//  JiveEventTests.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/25/13.
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

#import "JiveEventTests.h"


@implementation JiveEventTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveEvent alloc] init];
}

- (JiveEvent *)event {
    return (JiveEvent *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.event.type, @"event", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.event.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.event class], @"event class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.event class], @"event class not registered with JiveContent.");
}

- (void)testEventToJSON {
    NSDictionary *JSON = [self.event toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"event", @"Wrong type");

    [self.event setValue:@YES forKey:@"visibleToExternalContributors"];
    
    JSON = [self.event toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.event.type, @"Wrong type");    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.event.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

- (void)testEventParsing {
    [self.event setValue:@YES forKey:@"visibleToExternalContributors"];

    id JSON = [self.event toJSONDictionary];
    JiveEvent *newContent = [JiveEvent objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.event class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.event.type, @"Wrong type");
}

@end
