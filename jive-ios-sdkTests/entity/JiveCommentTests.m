//
//  JiveCommentTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
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

#import "JiveCommentTests.h"

@implementation JiveCommentTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveComment alloc] init];
}

- (JiveComment *)comment {
    return (JiveComment *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.comment.type, @"comment", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.comment.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.comment class], @"Comment class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.comment class], @"Comment class not registered with JiveContent.");
}

- (void)testPostToJSON {
    NSDictionary *JSON = [self.comment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"comment", @"Wrong type");
    
    [self.comment setValue:@"rootType" forKey:@"rootType"];
    [self.comment setValue:@"rootURI" forKey:@"rootURI"];
    
    JSON = [self.comment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.comment.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"rootType"], self.comment.rootType, @"Wrong rootType");
    STAssertEqualObjects([JSON objectForKey:@"rootURI"], self.comment.rootURI, @"Wrong rootURI");
}

- (void)testPostToJSON_alternate {
    [self.comment setValue:@"post" forKey:@"rootType"];
    [self.comment setValue:@"http://dummy.com" forKey:@"rootURI"];
    
    NSDictionary *JSON = [self.comment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.comment.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"rootType"], self.comment.rootType, @"Wrong rootType");
    STAssertEqualObjects([JSON objectForKey:@"rootURI"], self.comment.rootURI, @"Wrong rootURI");
}

@end
