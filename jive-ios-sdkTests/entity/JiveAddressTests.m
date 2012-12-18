//
//  JiveAddressTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/17/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAddressTests.h"
#import "JiveAddress.h"

@implementation JiveAddressTests

- (void)testToJSON {
    JiveAddress *address = [[JiveAddress alloc] init];
    id JSON = [address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    address.jive_label = @"Address";
    address.value = @"12345";
    address.type = @"Home";
    
    JSON = [address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"jive_label"], address.jive_label, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], address.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], address.type, @"Wrong type");
}

- (void)testToJSON_alternate {
    JiveAddress *address = [[JiveAddress alloc] init];
    id JSON = [address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    address.value = @"87654";
    address.type = @"Work";
    
    JSON = [address toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], address.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], address.type, @"Wrong type");
}

@end
