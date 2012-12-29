//
//  JiveActionLinkTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveActionLinkTests.h"
#import "JiveActionLink.h"

@implementation JiveActionLinkTests

- (void)testToJSON {
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSDictionary *JSON = [actionLink toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink.caption = @"text";
    actionLink.httpVerb = @"1234";
    [actionLink setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"target"];
    
    JSON = [actionLink toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"caption"], actionLink.caption, @"Wrong caption.");
    STAssertEqualObjects([JSON objectForKey:@"httpVerb"], actionLink.httpVerb, @"Wrong httpVerb.");
    STAssertEqualObjects([JSON objectForKey:@"target"], [actionLink.target absoluteString], @"Wrong target.");
}

- (void)testToJSON_alternate {
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSDictionary *JSON = [actionLink toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink.caption = @"html";
    actionLink.httpVerb = @"6541";
    [actionLink setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"target"];
    
    JSON = [actionLink toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"caption"], actionLink.caption, @"Wrong caption.");
    STAssertEqualObjects([JSON objectForKey:@"httpVerb"], actionLink.httpVerb, @"Wrong httpVerb.");
    STAssertEqualObjects([JSON objectForKey:@"target"], [actionLink.target absoluteString], @"Wrong target.");
}

@end
