//
//  JiveMediaLinkTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveMediaLinkTests.h"
#import "JiveMediaLink.h"

@implementation JiveMediaLinkTests

- (void)testToJSON {
    JiveMediaLink *media = [[JiveMediaLink alloc] init];
    NSDictionary *JSON = [media toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [media setValue:[NSNumber numberWithInt:4] forKey:@"duration"];
    [media setValue:[NSNumber numberWithInt:10] forKey:@"height"];
    [media setValue:[NSNumber numberWithInt:15] forKey:@"width"];
    [media setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    
    JSON = [media toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"duration"], media.duration, @"Wrong duration.");
    STAssertEqualObjects([JSON objectForKey:@"height"], media.height, @"Wrong height.");
    STAssertEqualObjects([JSON objectForKey:@"width"], media.width, @"Wrong width.");
    STAssertEqualObjects([JSON objectForKey:@"url"], [media.url absoluteString], @"Wrong url.");
}

- (void)testToJSON_alternate {
    JiveMediaLink *media = [[JiveMediaLink alloc] init];
    NSDictionary *JSON = [media toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [media setValue:[NSNumber numberWithInt:22] forKey:@"duration"];
    [media setValue:[NSNumber numberWithInt:2] forKey:@"height"];
    [media setValue:[NSNumber numberWithInt:6] forKey:@"width"];
    [media setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    
    JSON = [media toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"duration"], media.duration, @"Wrong duration.");
    STAssertEqualObjects([JSON objectForKey:@"height"], media.height, @"Wrong height.");
    STAssertEqualObjects([JSON objectForKey:@"width"], media.width, @"Wrong width.");
    STAssertEqualObjects([JSON objectForKey:@"url"], [media.url absoluteString], @"Wrong url.");
}

@end
