//
//  JiveSortedRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSortedRequestOptionsTests.h"

@implementation JiveSortedRequestOptionsTests

- (JiveSortedRequestOptions *)sortedOptions {

    return (JiveSortedRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSortedRequestOptions alloc] init];
}

- (void)testCount {
    
    enum JiveSortOrder sortOrder = dateCreatedDesc;
    
    self.sortedOptions.sort = sortOrder;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");
    
    sortOrder = dateCreatedAsc;
    self.sortedOptions.sort = sortOrder;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateCreatedAsc", asString, @"Wrong string contents");
    
    sortOrder = latestActivityDesc;
    self.sortedOptions.sort = sortOrder;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=latestActivityDesc", asString, @"Wrong string contents");
    
    sortOrder = latestActivityAsc;
    self.sortedOptions.sort = sortOrder;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=latestActivityAsc", asString, @"Wrong string contents");
    
    sortOrder = titleAsc;
    self.sortedOptions.sort = sortOrder;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=titleAsc", asString, @"Wrong string contents");
}

- (void)testCountWithField {
    
    int sortOrder = dateCreatedAsc;
    NSString *testField = @"name";
    
    [self.pageOptions addField:testField];
    self.sortedOptions.sort = sortOrder;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&sort=dateCreatedAsc", asString, @"Wrong string contents");
}

@end
