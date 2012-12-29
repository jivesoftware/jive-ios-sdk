//
//  JiveCommentTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveCommentTests.h"

@implementation JiveCommentTests

- (void)setUp {
    self.content = [[JiveComment alloc] init];
}

- (JiveComment *)comment {
    return (JiveComment *)self.content;
}

- (void)testPostToJSON {
    NSDictionary *JSON = [self.comment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"comment", @"Wrong type");
    
    [self.comment setValue:@"rootType" forKey:@"rootType"];
    [self.comment setValue:@"rootURI" forKey:@"rootURI"];
    
    JSON = [self.comment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.comment.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"rootType"], self.comment.rootType, @"Wrong rootType");
    STAssertEqualObjects([JSON objectForKey:@"rootURI"], self.comment.rootURI, @"Wrong rootURI");
}

- (void)testPostToJSON_alternate {
    [self.comment setValue:@"post" forKey:@"rootType"];
    [self.comment setValue:@"http://dummy.com" forKey:@"rootURI"];
    
    NSDictionary *JSON = [self.comment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.comment.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"rootType"], self.comment.rootType, @"Wrong rootType");
    STAssertEqualObjects([JSON objectForKey:@"rootURI"], self.comment.rootURI, @"Wrong rootURI");
}

@end
