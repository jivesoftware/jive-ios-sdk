//
//  JivePeopleRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePeopleRequestOptionsTests.h"

@implementation JivePeopleRequestOptionsTests

- (JivePeopleRequestOptions *)peopleOptions {
    
    return (JivePeopleRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JivePeopleRequestOptions alloc] init];
}

- (void)testTitle {
    
    self.peopleOptions.title = @"Head Honcho";
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=title(Head Honcho)", asString, @"Wrong string contents");
    
    self.peopleOptions.title = @"grunt";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=title(grunt)", asString, @"Wrong string contents");
}

- (void)testTitleWithFields {
    
    self.peopleOptions.title = @"Head Honcho";
    [self.peopleOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=title(Head Honcho)", asString, @"Wrong string contents");

    [self.peopleOptions addTag:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm),title(Head Honcho)", asString, @"Wrong string contents");
}

@end
