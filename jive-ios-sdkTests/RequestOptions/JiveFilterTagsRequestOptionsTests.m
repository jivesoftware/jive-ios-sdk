//
//  JiveFilterTagsRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveFilterTagsRequestOptionsTests.h"

@implementation JiveFilterTagsRequestOptionsTests

- (JiveFilterTagsRequestOptions *)tagOptions {
    
    return (JiveFilterTagsRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveFilterTagsRequestOptions alloc] init];
}

- (void)testTags {
    
    [self.tagOptions addTag:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=tag(dm)", asString, @"Wrong string contents");
    
    [self.tagOptions addTag:@"mention$"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=tag(dm,mention%24)", asString, @"Wrong string contents");
    
    [self.tagOptions addTag:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=tag(dm,mention%24,share)", asString, @"Wrong string contents");
}

- (void)testTagWithFields {
    
    [self.tagOptions addTag:@"dm"];
    [self.tagOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)", asString, @"Wrong string contents");
}

@end
