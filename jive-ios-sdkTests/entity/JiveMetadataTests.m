//
//  JiveMetadataTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 8/15/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveMetadataTests.h"
#import "JiveMetadata_internal.h"
#import <OCMock/OCMock.h>
#import "Jive_internal.h"
#import "JiveRetryingJAPIRequestOperation.h"

@interface JiveTestOperation : AFJSONRequestOperation<JiveRetryingOperation>

@end

@implementation JiveMetadataTests

- (void)testNew {
    JiveMetadata *badInit = [JiveMetadata new];
    
    STAssertNil(badInit, @"Calling new on JiveMetadata should return nil.");
}

- (void)testHasVideo_noVideo {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    NSDictionary *objects = @{@"carousel" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/carousel",
                              @"contentVersion" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/contentVersion"
                              };
    __block void (^internalCallback)(NSDictionary *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STAssertTrue(false, @"There should be no errors");
    };
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] objectsOperationOnComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                    onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEquals(obj, (id)errorBlock, @"Wrong error block passed");
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject hasVideo:^(BOOL flagValue) {
        STAssertFalse(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback(objects);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

- (void)testHasVideo_hasVideo {
    OCMockObject *mockJive = [OCMockObject mockForClass:[Jive class]];
    NSDictionary *objects = @{@"carousel" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/carousel",
                              @"video" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/video",
                              @"contentVersion" : @"https://brewspace.jiveland.com/api/core/v3/metadata/objects/contentVersion"
                              };
    __block void (^internalCallback)(NSDictionary *);
    OCMockObject *mockOperation = [OCMockObject mockForClass:[JiveRetryingJAPIRequestOperation class]];
    JiveErrorBlock errorBlock = ^(NSError *error) {
        STAssertTrue(false, @"There should be no errors");
    };
    
    [(JiveRetryingJAPIRequestOperation *)[mockOperation expect] start];
    [[[mockJive expect] andReturn:mockOperation] objectsOperationOnComplete:[OCMArg checkWithBlock:^BOOL(id obj) {
        internalCallback = [obj copy];
        return obj != nil;
    }]
                                                                    onError:[OCMArg checkWithBlock:^BOOL(id obj) {
        STAssertEquals(obj, (id)errorBlock, @"Wrong error block passed");
        return obj != nil;
    }]];
    
    JiveMetadata *testObject = [[JiveMetadata alloc] initWithInstance:(Jive *)mockJive];
    
    [testObject hasVideo:^(BOOL flagValue) {
        STAssertTrue(flagValue, @"The flag should be NO");
    } onError:errorBlock];
    
    STAssertNotNil(internalCallback, @"A callback should have been set.");
    if (internalCallback) {
        internalCallback(objects);
    }
    
    STAssertNoThrow([mockOperation verify], @"The operation was not started.");
    STAssertNoThrow([mockJive verify], @"The operation was not created.");
}

@end
