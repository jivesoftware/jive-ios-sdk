//
//  JiveEmailTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/17/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveEmailTests.h"
#import "JiveEmail.h"

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
