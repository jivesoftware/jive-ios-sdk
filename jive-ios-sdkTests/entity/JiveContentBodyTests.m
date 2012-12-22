//
//  JiveContentBodyTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/21/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContentBodyTests.h"
#import "JiveContentBody.h"

@implementation JiveContentBodyTests

- (void)testToJSON {
    JiveContentBody *body = [[JiveContentBody alloc] init];
    id JSON = [body toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    body.text = @"text";
    body.type = @"text/text";
    
    JSON = [body toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"text"], body.text, @"Wrong text.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], body.type, @"Wrong type.");
}

- (void)testToJSON_alternate {
    JiveContentBody *body = [[JiveContentBody alloc] init];
    id JSON = [body toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    body.text = @"html";
    body.type = @"text/html";
    
    JSON = [body toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"text"], body.text, @"Wrong text.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], body.type, @"Wrong type.");
}

@end
