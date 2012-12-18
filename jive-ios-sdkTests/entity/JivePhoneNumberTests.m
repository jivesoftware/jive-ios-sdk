//
//  JivePhoneNumberTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/17/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePhoneNumberTests.h"
#import "JivePhoneNumber.h"

@implementation JivePhoneNumberTests

- (void)testToJSON {
    JivePhoneNumber *phoneNumber = [[JivePhoneNumber alloc] init];
    id JSON = [phoneNumber toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    phoneNumber.jive_label = @"Phone Number";
    phoneNumber.value = @"12345";
    phoneNumber.type = @"Home";
    
    JSON = [phoneNumber toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"jive_label"], phoneNumber.jive_label, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], phoneNumber.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], phoneNumber.type, @"Wrong type");
}

- (void)testToJSON_alternate {
    JivePhoneNumber *phoneNumber = [[JivePhoneNumber alloc] init];
    id JSON = [phoneNumber toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    phoneNumber.value = @"87654";
    phoneNumber.type = @"Work";
    
    JSON = [phoneNumber toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"value"], phoneNumber.value, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], phoneNumber.type, @"Wrong type");
}

@end
