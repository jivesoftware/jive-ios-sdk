//
//  JiveLevelTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/21/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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
    [level setValue:@"1234" forKey:@"description"];
    [level setValue:[NSNumber numberWithInt:5] forKey:@"points"];
    
    JSON = [level toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], level.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"description"], level.description, @"Wrong description.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"points"], level.points, @"Wrong points");
}

- (void)testToJSON_alternate {
    JiveLevel *level = [[JiveLevel alloc] init];
    id JSON = [level toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [level setValue:@"Alternate" forKey:@"name"];
    [level setValue:@"8743" forKey:@"description"];
    [level setValue:[NSNumber numberWithInt:10] forKey:@"points"];
    
    JSON = [level toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"name"], level.name, @"Wrong name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"description"], level.description, @"Wrong description.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"points"], level.points, @"Wrong points");
}

@end
