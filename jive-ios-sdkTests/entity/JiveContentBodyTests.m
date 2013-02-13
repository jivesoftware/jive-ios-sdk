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

- (void)testToJSON {
    JiveContentBody *body = [[JiveContentBody alloc] init];
    id JSON = [body toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    body.text = @"text";
    body.type = @"text/text";
    
    JSON = [body toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"text"], body.text, @"Wrong text.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], body.type, @"Wrong type.");
}

- (void)testToJSON_alternate {
    JiveContentBody *body = [[JiveContentBody alloc] init];
    id JSON = [body toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    body.text = @"html";
    body.type = @"text/html";
    
    JSON = [body toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"text"], body.text, @"Wrong text.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], body.type, @"Wrong type.");
}

@end
