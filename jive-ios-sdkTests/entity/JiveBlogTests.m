//
//  JiveBlogTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
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

#import "JiveBlogTests.h"
#import "JiveBlog.h"

@implementation JiveBlogTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveBlog alloc] init];
}

- (void)testType {
    STAssertEqualObjects(self.place.type, @"blog", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.place.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.place class], @"Blog class not registered with JiveTypedObject.");
    STAssertEqualObjects([JivePlace entityClass:typeSpecifier], [self.place class], @"Blog class not registered with JivePlace.");
}

- (void)testTaskToJSON {
    NSDictionary *JSON = [self.place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"blog", @"Wrong type");
}

@end
