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

- (void)testSort {
    
    self.sortedOptions.sort = JiveSortOrderDefault;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");
    
    self.sortedOptions.sort = JiveSortOrderDateCreatedDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateCreatedDesc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateCreatedAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateCreatedAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLatestActivityDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=latestActivityDesc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLatestActivityAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=latestActivityAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderTitleAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=titleAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderFirstNameAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=firstNameAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLastNameAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=lastNameAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateJoinedDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateJoinedDesc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateJoinedAsc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=dateJoinedAsc", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderStatusLevelDesc;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"sort=statusLevelDesc", asString, @"Wrong string contents");
}

- (void)testSortWithField {
    
    int sortOrder = JiveSortOrderDateCreatedAsc;
    NSString *testField = @"name";
    
    [self.pageOptions addField:testField];
    self.sortedOptions.sort = sortOrder;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&sort=dateCreatedAsc", asString, @"Wrong string contents");
}

- (void)testInvalidSort {
    
    self.sortedOptions.sort = (enum JiveSortOrder)-1;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");
    
    self.sortedOptions.sort = (enum JiveSortOrder)5000;
    asString = [self.options toQueryString];
    STAssertNil(asString, @"Invalid string returned");
}

@end
