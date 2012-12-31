//
//  JiveBlogTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveBlogTests.h"
#import "JiveBlog.h"

@implementation JiveBlogTests

- (void)setUp {
    self.place = [[JiveBlog alloc] init];
}

- (void)testTaskToJSON {
    NSDictionary *JSON = [self.place toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"blog", @"Wrong type");
}

@end
