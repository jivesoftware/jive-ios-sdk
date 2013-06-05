//
//  JiveLevelTests.m
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

#import "JiveLevelTests.h"
#import "JiveLevel.h"

@implementation JiveLevelTests

- (void)testToJSON {
    JiveLevel *level = [[JiveLevel alloc] init];
    id JSON = [level toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [level setValue:@"testName" forKey:@"name"];
    [level setValue:@"1234" forKey:@"jiveDescription"];
    [level setValue:[NSNumber numberWithInt:5] forKey:@"points"];
    
    JSON = [level toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], level.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"description"], level.jiveDescription, @"Wrong description.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"points"], level.points, @"Wrong points");
}

- (void)testToJSON_alternate {
    JiveLevel *level = [[JiveLevel alloc] init];
    id JSON = [level toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [level setValue:@"Alternate" forKey:@"name"];
    [level setValue:@"8743" forKey:@"jiveDescription"];
    [level setValue:[NSNumber numberWithInt:10] forKey:@"points"];
    
    JSON = [level toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], level.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"description"], level.jiveDescription, @"Wrong description.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"points"], level.points, @"Wrong points");
}

@end
