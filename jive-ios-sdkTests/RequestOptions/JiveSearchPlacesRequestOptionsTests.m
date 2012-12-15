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
    
    [self.placeOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=nameonly", asString, @"Wrong string contents");
}

@end
