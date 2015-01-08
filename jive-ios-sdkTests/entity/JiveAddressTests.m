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

- (void)setUp {
    [super setUp];
    self.object = [JiveAddress new];
}

- (JiveAddress *)address {
    return (JiveAddress *)self.object;
}

- (void)testToJSON {
    id JSON = [self.address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.address.jive_label = @"Address";
    self.address.value = @{@"Country": @"USA"};
    self.address.type = @"Home";
    [self.address setValue:@YES forKey:@"primary"];
    
    JSON = [self.address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"jive_label"], self.address.jive_label, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], self.address.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], self.address.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"primary"], @YES, @"Wrong primary");
}

- (void)testToJSON_alternate {
    NSDictionary *JSON = [self.address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.address.jive_label = @"email";
    self.address.value = @{@"postalCode": @"80215"};
    self.address.type = @"Work";
    
    JSON = [self.address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"jive_label"], self.address.jive_label, @"Wrong display name.");
    STAssertEqualObjects([JSON objectForKey:@"value"], self.address.value, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.address.type, @"Wrong type");
    STAssertNil([JSON objectForKey:@"primary"], @"JSON contains primary object when it shouldn't");
}

- (void)testJSONParsing {
    self.address.jive_label = @"Address";
    self.address.value = @{@"Country": @"USA"};
    self.address.type = @"Home";
    [self.address setValue:@YES forKey:@"primary"];
    
    id JSON = [self.address toJSONDictionary];
    JiveAddress *newAddress = [JiveAddress objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newAddress class], [JiveAddress class], @"Wrong item class");
    STAssertEqualObjects(newAddress.jive_label, self.address.jive_label, @"Wrong jive_label");
    STAssertEqualObjects(newAddress.value, self.address.value, @"Wrong value");
    STAssertEqualObjects(newAddress.type, self.address.type, @"Wrong type");
    STAssertEqualObjects(newAddress.primary, @YES, @"Wrong primary");
}

- (void)testJSONParsingAlternate {
    self.address.jive_label = @"email";
    self.address.value = @{@"postalCode": @"80215"};
    self.address.type = @"Work";
    [self.address setValue:@NO forKey:@"primary"];
    
    id JSON = [self.address toJSONDictionary];
    JiveAddress *newAddress = [JiveAddress objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newAddress class], [JiveAddress class], @"Wrong item class");
    STAssertEqualObjects(newAddress.jive_label, self.address.jive_label, @"Wrong jive_label");
    STAssertEqualObjects(newAddress.value, self.address.value, @"Wrong value");
    STAssertEqualObjects(newAddress.type, self.address.type, @"Wrong type");
    STAssertEqualObjects(newAddress.primary, @NO, @"Wrong primary");
}

@end
