//
//  JiveSearchPeopleRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchPeopleRequestOptionsTests.h"

@implementation JiveSearchPeopleRequestOptionsTests

- (JiveSearchPeopleRequestOptions *)peopleOptions {
    
    return (JiveSearchPeopleRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSearchPeopleRequestOptions alloc] init];
}

- (void)testSearch {
    
    [self.peopleOptions addSearchTerm:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=search(dm)", asString, @"Wrong string contents");
    
    [self.peopleOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=search(dm,mention)", asString, @"Wrong string contents");
    
    [self.peopleOptions addSearchTerm:@"(sh,a\\re)"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=search(dm,mention,\\(sh\\,a\\\\re\\))", asString, @"Wrong string contents");
    
    [self.peopleOptions addSearchTerm:@"h)e(j,m"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=search(dm,mention,\\(sh\\,a\\\\re\\),h\\)e\\(j\\,m)", asString, @"Wrong string contents");
}

- (void)testSearchWithFields {
    
    [self.peopleOptions addSearchTerm:@"dm"];
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=search(dm)", asString, @"Wrong string contents");
}

- (void)testNameOnly {
    
    self.peopleOptions.nameonly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=nameonly", asString, @"Wrong string contents");
}

- (void)testNameOnlyWithOtherFields {
    
    [self.peopleOptions addField:@"name"];
    self.peopleOptions.nameonly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=nameonly", asString, @"Wrong string contents");
    
    [self.peopleOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention),nameonly", asString, @"Wrong string contents");
}

@end
