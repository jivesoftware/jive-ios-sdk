//
//  JiveAnnouncementRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAnnouncementRequestOptionsTests.h"

@implementation JiveAnnouncementRequestOptionsTests

- (JiveAnnouncementRequestOptions *)announcementOptions {
    
    return (JiveAnnouncementRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveAnnouncementRequestOptions alloc] init];
}

- (void)testCollapse {
    
    self.announcementOptions.activeOnly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"activeOnly", asString, @"Wrong string contents");
}

- (void)testCollapseWithOtherFields {
    
    [self.announcementOptions addField:@"name"];
    self.announcementOptions.activeOnly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&activeOnly", asString, @"Wrong string contents");
    
    self.announcementOptions.startIndex = 5;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&startIndex=5&activeOnly", asString, @"Wrong string contents");
}

@end
