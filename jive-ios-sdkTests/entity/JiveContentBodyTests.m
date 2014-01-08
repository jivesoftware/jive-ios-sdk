//
//  JiveContentBodyTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/21/12.
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

#import "JiveContentBodyTests.h"
#import "JiveContentBody.h"

@implementation JiveContentBodyTests

- (void)setUp {
    [super setUp];
    self.object = [JiveContentBody new];
}

- (JiveContentBody *)contentBody {
    return (JiveContentBody *)self.object;
}

- (void)testContentBodyToJSON {
    id JSON = [self.contentBody toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.contentBody.text = @"text";
    self.contentBody.type = @"text/text";
    
    JSON = [self.contentBody toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"text"], self.contentBody.text, @"Wrong text.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.contentBody.type, @"Wrong type.");
}

- (void)testContentBodyToJSON_alternate {
    id JSON = [self.contentBody toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.contentBody.text = @"html";
    self.contentBody.type = @"text/html";
    
    JSON = [self.contentBody toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"text"], self.contentBody.text, @"Wrong text.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.contentBody.type, @"Wrong type.");
}

- (void)testContentBodyPersistentJSON {
    id JSON = [self.contentBody toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.contentBody.text = @"text";
    self.contentBody.type = @"text/text";
    
    JSON = [self.contentBody persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"text"], self.contentBody.text, @"Wrong text.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.contentBody.type, @"Wrong type.");
}

- (void)testContentBodyPersistentJSON_alternate {
    id JSON = [self.contentBody toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.contentBody.text = @"html";
    self.contentBody.type = @"text/html";
    
    JSON = [self.contentBody persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"text"], self.contentBody.text, @"Wrong text.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.contentBody.type, @"Wrong type.");
}

@end
