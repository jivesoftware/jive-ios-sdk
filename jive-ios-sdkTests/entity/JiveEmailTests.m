//
//  JiveEmailTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/17/12.
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

#import "JiveEmailTests.h"
#import "JiveEmail.h"
#import "JiveObject_internal.h"

@implementation JiveEmailTests

- (void)testToJSON {
    JiveEmail *email = [[JiveEmail alloc] init];
    id JSON = [email toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    email.jive_label = @"Email";
    email.value = @"12345";
    email.type = @"Home";
    [email performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"primary"
                withObject:(__bridge id)kCFBooleanTrue];
   
    JSON = [email toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"jive_label"], email.jive_label, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], email.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], email.type, @"Wrong type");
    
    NSNumber *primary = [(NSDictionary *)JSON objectForKey:@"primary"];
    
    STAssertNotNil(primary, @"Missing primary");
    if (primary)
        STAssertTrue([primary boolValue], @"Wrong primary");
}

- (void)testToJSON_alternate {
    JiveEmail *email = [[JiveEmail alloc] init];
    id JSON = [email toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    email.jive_label = @"Address";
    email.value = @"87654";
    email.type = @"Work";
    
    JSON = [email toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"jive_label"], email.jive_label, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], email.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], email.type, @"Wrong type");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"primary"], @"primary included?");
}

@end
