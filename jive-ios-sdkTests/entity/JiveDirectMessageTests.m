//
//  JiveDirectMessageTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDirectMessageTests.h"

@implementation JiveDirectMessageTests

- (void)setUp {
    self.content = [[JiveDirectMessage alloc] init];
}

- (JiveDirectMessage *)dm {
    return (JiveDirectMessage *)self.content;
}

- (void)testPostToJSON {
    NSDictionary *JSON = [self.dm toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"dm", @"Wrong type");
    
    self.dm.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.dm toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.dm.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.dm.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
}

@end
