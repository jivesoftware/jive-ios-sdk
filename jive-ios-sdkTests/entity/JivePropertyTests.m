//
//  JivePropertyTests.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JivePropertyTests.h"
#import "JiveProperty.h"

@implementation JivePropertyTests

- (void)testToJSON {
    JiveProperty *property = [[JiveProperty alloc] init];
    
    NSString *availability = @"availability1";
    NSString *defaultValue = @"defaultValue1";
    NSString *description = @"description1";
    NSString *name = @"name1";
    NSString *since = @"since1";
    NSString *type = @"string";
    NSString *value = @"value1";
    
    [property setValue:availability forKey:@"availability"];
    [property setValue:defaultValue forKey:@"defaultValue"];
    [property setValue:description forKey:@"jiveDescription"];
    [property setValue:name forKey:@"name"];
    [property setValue:since forKey:@"since"];
    [property setValue:type forKey:@"type"];
    [property setValue:value forKey:@"value"];
    
    NSDictionary *JSON = [property toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"availability"], availability, @"availability wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"defaultValue"], defaultValue, @"defaultValue wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"description"], description, @"description wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"name"], name, @"name wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"since"], since, @"since wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"type"], type, @"type wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"value"], value, @"value wrong in JSON");
}

- (void)testToJSON_alternate {
    JiveProperty *property = [[JiveProperty alloc] init];
    
    NSString *availability = @"availability2";
    NSString *defaultValue = @"defaultValue2";
    NSString *description = @"description2";
    NSString *name = @"name2";
    NSString *since = @"since2";
    NSString *type = @"bool";
    NSNumber *value = [NSNumber numberWithBool:YES];
    
    [property setValue:availability forKey:@"availability"];
    [property setValue:defaultValue forKey:@"defaultValue"];
    [property setValue:description forKey:@"jiveDescription"];
    [property setValue:name forKey:@"name"];
    [property setValue:since forKey:@"since"];
    [property setValue:type forKey:@"type"];
    [property setValue:value forKey:@"value"];
    
    NSDictionary *JSON = [property toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"availability"], availability, @"availability wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"defaultValue"], defaultValue, @"defaultValue wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:@"description"], description, @"description wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"name"], name, @"name wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"since"], since, @"since wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"type"], type, @"type wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:@"value"], value, @"value wrong in JSON");
}

@end
