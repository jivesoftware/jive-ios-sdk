//
//  JivePlacePlacesRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlacePlacesRequestOptionsTests.h"

@implementation JivePlacePlacesRequestOptionsTests

- (JivePlacePlacesRequestOptions *)placePlacesOptions {
    
    return (JivePlacePlacesRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JivePlacePlacesRequestOptions alloc] init];
}

- (void)testTypes {
    
    [self.placePlacesOptions addType:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addType:@"mention"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
}

- (void)testTypeWithFields {
    
    [self.placePlacesOptions addType:@"dm"];
    [self.placePlacesOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=type(dm)", asString, @"Wrong string contents");

    [self.placePlacesOptions addTag:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(share)&filter=type(dm)", asString, @"Wrong string contents");
}

- (void)testSearch {
    
    [self.placePlacesOptions addSearchTerm:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=search(dm)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=search(dm,mention)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addSearchTerm:@"(sh,a\\re)"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=search(dm,mention,\\(sh\\,a\\\\re\\))", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addSearchTerm:@"h)e(j,m"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=search(dm,mention,\\(sh\\,a\\\\re\\),h\\)e\\(j\\,m)", asString, @"Wrong string contents");
}

- (void)testSearchWithFields {
    
    [self.placePlacesOptions addSearchTerm:@"dm"];
    [self.placePlacesOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=search(dm)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addTag:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(share)&filter=search(dm)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(share)&filter=type(share)&filter=search(dm)", asString, @"Wrong string contents");
}

@end
