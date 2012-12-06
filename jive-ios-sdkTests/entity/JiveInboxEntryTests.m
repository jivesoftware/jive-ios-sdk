//
//  JiveInboxEntryTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveInboxEntryTests.h"
#import "JiveActivityObject.h"

@implementation JiveInboxEntryTests

- (void)setUp {
    
    self.inboxEntry = [[JiveInboxEntry alloc] init];
}

- (void)tearDown {
    
    self.inboxEntry = nil;
}

- (void)testDescription {
    
    JiveActivityObject *activity = [[JiveActivityObject alloc] init];

    [self.inboxEntry setValue:activity forKey:@"object"];
    STAssertEqualObjects(self.inboxEntry.description, @"(null) (null) -'(null)'", @"Empty description");
    
    activity.displayName = @"object";
    STAssertEqualObjects(self.inboxEntry.description, @"(null) (null) -'object'", @"Just a display name");
    
    self.inboxEntry.verb = @"walking";
    STAssertEqualObjects(self.inboxEntry.description, @"(null) walking -'object'", @"Verb and display name");
    
    [activity setValue:[NSURL URLWithString:@"http://test.com"] forKey:@"url"];
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com walking -'object'", @"URL, verb and display name");
    
    activity.displayName = @"tree";
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com walking -'tree'", @"A different display name");
    
    self.inboxEntry.verb = @"sitting";
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com sitting -'tree'", @"A different verb");
    
    [activity setValue:[NSURL URLWithString:@"http://bad.net"] forKey:@"url"];
    STAssertEqualObjects(self.inboxEntry.description, @"http://bad.net sitting -'tree'", @"A different url");
}

@end
