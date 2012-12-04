//
//  JiveSearchPlacesRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchPlacesRequestOptionsTests.h"

@implementation JiveSearchPlacesRequestOptionsTests

- (JiveSearchPlacesRequestOptions *)placeOptions {
    
    return (JiveSearchPlacesRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSearchPlacesRequestOptions alloc] init];
}

- (void)testNameOnly {
    
    self.placeOptions.nameonly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=nameonly", asString, @"Wrong string contents");
}

- (void)testNameOnlyWithOtherFields {
    
    [self.placeOptions addField:@"name"];
    self.placeOptions.nameonly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=nameonly", asString, @"Wrong string contents");
    
    [self.placeOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention),nameonly", asString, @"Wrong string contents");
}

- (void)testTypes {
    
    [self.placeOptions addType:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=type(dm)", asString, @"Wrong string contents");
    
    [self.placeOptions addType:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=type(dm,mention)", asString, @"Wrong string contents");
    
    [self.placeOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
}

- (void)testTypeWithFields {
    
    [self.placeOptions addType:@"dm"];
    [self.placeOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=type(dm)", asString, @"Wrong string contents");
    
    [self.placeOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention),type(dm)", asString, @"Wrong string contents");

    self.placeOptions.nameonly = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention),nameonly,type(dm)", asString, @"Wrong string contents");
}

@end
