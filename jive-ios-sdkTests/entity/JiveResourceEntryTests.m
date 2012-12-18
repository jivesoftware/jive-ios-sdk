//
//  JiveResourceEntryTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/18/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveResourceEntryTests.h"
#import "JiveResourceEntry.h"

@implementation JiveResourceEntryTests

- (void)testInstanceFromJSON {
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:2];
    NSArray *allowedJSON = [NSArray arrayWithObject:@"GET"];
    NSURL *ref = [NSURL URLWithString:@"https://dummy.com/testing.html"];
    
    [JSON setValue:[ref absoluteString] forKey:@"ref"];
    [JSON setValue:allowedJSON forKey:@"allowed"];
    
    JiveResourceEntry *resource = [JiveResourceEntry instanceFromJSON:JSON];
    
    STAssertNotNil(resource, @"Object not created");
    STAssertEqualObjects(resource.ref, ref, @"Wrong ref");
    STAssertEquals(resource.allowed.count, allowedJSON.count, @"Wrong number of allowed entries");
    STAssertEqualObjects([resource.allowed objectAtIndex:0], [allowedJSON objectAtIndex:0], @"Wrong allowed entry");
}

@end
