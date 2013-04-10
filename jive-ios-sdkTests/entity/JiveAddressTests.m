//
//  JiveAddressTests.m
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

#import "JiveAddressTests.h"
#import "JiveAddress.h"
#import "JiveObject_internal.h"

@implementation JiveAddressTests

- (void)testToJSON {
    JiveAddress *address = [[JiveAddress alloc] init];
    id JSON = [address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    address.jive_label = @"Address";
    address.value = @"12345";
    address.type = @"Home";
    [address performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                 withObject:@"primary"
                 withObject:(__bridge id)kCFBooleanTrue];
    
    JSON = [address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"jive_label"], address.jive_label, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], address.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], address.type, @"Wrong type");
    
    NSNumber *primary = [(NSDictionary *)JSON objectForKey:@"primary"];
    
    STAssertNotNil(primary, @"Missing primary");
    if (primary)
        STAssertTrue([primary boolValue], @"Wrong primary");
}

- (void)testToJSON_alternate {
    JiveAddress *address = [[JiveAddress alloc] init];
    id JSON = [address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    address.jive_label = @"email";
    address.value = @"87654";
    address.type = @"Work";
    
    JSON = [address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"jive_label"], address.jive_label, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], address.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], address.type, @"Wrong type");
    STAssertNil([(NSDictionary *)JSON objectForKey:@"primary"], @"JSON contains primary object when it shouldn't");
}

- (void)testJSONParsing {
    JiveAddress *baseAddress = [[JiveAddress alloc] init];
    
    baseAddress.jive_label = @"Address";
    baseAddress.value = @"12345";
    baseAddress.type = @"Home";
    [baseAddress performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                  withObject:@"primary"
                  withObject:(__bridge id)kCFBooleanTrue];
    
    id JSON = [baseAddress toJSONDictionary];
    JiveAddress *address = [JiveAddress instanceFromJSON:JSON];
    
    STAssertEquals([address class], [JiveAddress class], @"Wrong item class");
    STAssertEqualObjects(address.jive_label, baseAddress.jive_label, @"Wrong jive_label");
    STAssertEqualObjects(address.value, baseAddress.value, @"Wrong value");
    STAssertEqualObjects(address.type, baseAddress.type, @"Wrong type");
    STAssertTrue(address.primary, @"Wrong primary");
}

- (void)testJSONParsingAlternate {
    JiveAddress *baseAddress = [[JiveAddress alloc] init];
    
    baseAddress.jive_label = @"email";
    baseAddress.value = @"87654";
    baseAddress.type = @"Work";
    
    id JSON = [baseAddress toJSONDictionary];
    JiveAddress *address = [JiveAddress instanceFromJSON:JSON];
    
    STAssertEquals([address class], [JiveAddress class], @"Wrong item class");
    STAssertEqualObjects(address.jive_label, baseAddress.jive_label, @"Wrong jive_label");
    STAssertEqualObjects(address.value, baseAddress.value, @"Wrong value");
    STAssertEqualObjects(address.type, baseAddress.type, @"Wrong type");
    STAssertFalse(address.primary, @"Wrong primary");
}

@end
