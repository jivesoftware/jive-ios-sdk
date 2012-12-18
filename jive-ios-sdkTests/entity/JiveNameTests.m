//
//  JiveNameTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/17/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveNameTests.h"
#import "JiveName.h"

@implementation JiveNameTests

- (void)testToJSON {
    JiveName *name = [[JiveName alloc] init];
    id JSON = [name toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    name.familyName = @"Last";
    name.givenName = @"First";
    [name setValue:@"First Last" forKey:@"formatted"];
    
    JSON = [name toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"familyName"], name.familyName, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"givenName"], name.givenName, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"formatted"], name.formatted, @"Wrong type");
}

- (void)testToJSON_alternate {
    JiveName *name = [[JiveName alloc] init];
    id JSON = [name toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    name.familyName = @"Bushnell";
    name.givenName = @"Orson";
    [name setValue:@"Orson Bushnell" forKey:@"formatted"];

    JSON = [name toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"familyName"], name.familyName, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"givenName"], name.givenName, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"formatted"], name.formatted, @"Wrong type");
}

@end
