//
//  JivePersonJiveTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/17/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePersonJiveTests.h"
#import "JivePersonJive.h"

@implementation JivePersonJiveTests

- (void)testToJSON {
    JivePersonJive *person = [[JivePersonJive alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    person.password = @"Phone Number";
    person.locale = @"12345";
    person.timeZone = @"CST";
    person.username = @"Home";
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"password"], person.password, @"Wrong password.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"locale"], person.locale, @"Wrong locale.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"timeZone"], person.timeZone, @"Wrong time zone");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"username"], person.username, @"Wrong username");
}

- (void)testToJSON_alternate {
    JivePersonJive *person = [[JivePersonJive alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    person.password = @"Phone Number";
    person.locale = @"87654";
    person.timeZone = @"MDT";
    person.username = @"Work";
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"password"], person.password, @"Wrong password.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"locale"], person.locale, @"Wrong locale.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"timeZone"], person.timeZone, @"Wrong time zone");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"username"], person.username, @"Wrong username");
}

@end
