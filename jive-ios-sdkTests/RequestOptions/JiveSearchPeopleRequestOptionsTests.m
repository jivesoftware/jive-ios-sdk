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
    STAssertEqualObjects(@"fields=name&filter=search(mention)&filter=nameonly", asString, @"Wrong string contents");
}

@end
